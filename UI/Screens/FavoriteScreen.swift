//
//  FavoriteScreen.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct FavoriteScreen: View {
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.favoriteProductsState {
                case .idle, .loading:
                    ProgressView()
                case .success(let products):
                    if products.isEmpty {
                        EmptyFavoritesView()
                    } else {
                        FavoriteProductsList(products: products)
                    }
                case .error(let message, _):
                    ErrorView(message: message ?? "Ошибка загрузки избранного")
                }
            }
            .navigationTitle("Избранное")
            .onAppear {
                viewModel.loadFavoriteProducts()
            }
        }
    }
}

struct FavoriteProductsList: View {
    let products: [Product]
    @ObservedObject private var viewModel = ProductViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(products) { product in
                    ProductCard(
                        product: product,
                        onClick: {
                            // TODO: Показать детали продукта
                        },
                        onToggleFavorite: {
                            Task {
                                _ = await viewModel.toggleFavorite(product.id)
                            }
                        }
                    )
                }
            }
            .padding()
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Нет избранных товаров")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FavoriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteScreen()
    }
}


