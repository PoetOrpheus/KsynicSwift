//
//  HomeScreen.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок с поиском
                    TopHeaderSection(onSearchClick: {
                        // TODO: Показать экран поиска
                    })
                    
                    // Категории
                    CategoriesRow()
                    
                    // Сетка продуктов
                    ProductGrid(
                        products: getProducts(),
                        onProductClick: { product in
                            // TODO: Показать детали продукта
                        },
                        onToggleFavorite: { productId in
                            Task {
                                _ = await viewModel.toggleFavorite(productId)
                            }
                        }
                    )
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadProducts()
            }
        }
    }
    
    private func getProducts() -> [Product] {
        if case .success(let products) = viewModel.productsState {
            return products
        }
        return []
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

// Заглушки для компонентов (будут реализованы позже)
struct TopHeaderSection: View {
    let onSearchClick: () -> Void
    
    var body: some View {
        HStack {
            Text("Ksynic")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: onSearchClick) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
        .background(Color.brandPurple)
        .foregroundColor(.white)
    }
}

struct CategoriesRow: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(1..<10) { index in
                    CategoryCard(categoryName: "Категория \(index)")
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryCard: View {
    let categoryName: String
    
    var body: some View {
        VStack {
            Image(systemName: "square.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            Text(categoryName)
                .font(.caption)
        }
        .frame(width: 80)
    }
}

struct ProductGrid: View {
    let products: [Product]
    let onProductClick: (Product) -> Void
    let onToggleFavorite: (String) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(products) { product in
                ProductCard(
                    product: product,
                    onClick: { onProductClick(product) },
                    onToggleFavorite: { onToggleFavorite(product.id) }
                )
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    let onClick: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение продукта
            ZStack(alignment: .topTrailing) {
                if let firstImage = product.imageNames.first {
                    Image(firstImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                }
                
                Button(action: onToggleFavorite) {
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(product.isFavorite ? .red : .gray)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Название и цена
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text("\(product.price) ₽")
                        .font(.headline)
                        .foregroundColor(.brandPurple)
                    
                    if let oldPrice = product.oldPrice {
                        Text("\(oldPrice) ₽")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            onClick()
        }
    }
}


