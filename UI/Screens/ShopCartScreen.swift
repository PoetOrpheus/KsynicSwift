//
//  ShopCartScreen.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct ShopCartScreen: View {
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.cartState {
                case .idle, .loading:
                    ProgressView()
                case .success(let items):
                    if items.isEmpty {
                        EmptyCartView()
                    } else {
                        CartContentView(items: items)
                    }
                case .error(let message, _):
                    ErrorView(message: message ?? "Ошибка загрузки корзины")
                }
            }
            .navigationTitle("Корзина")
            .onAppear {
                viewModel.loadCart()
            }
        }
    }
}

struct CartContentView: View {
    let items: [CartItem]
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    CartItemRow(item: item)
                }
            }
            
            // Итого
            VStack(spacing: 12) {
                HStack {
                    Text("Итого:")
                        .font(.headline)
                    Spacer()
                    Text("\(viewModel.cartTotal) ₽")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.brandPurple)
                }
                .padding()
                
                Button(action: {
                    // TODO: Оформить заказ
                }) {
                    Text("Оформить заказ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandPurple)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .background(Color.white)
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @ObservedObject private var viewModel = CartViewModel()
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение
            if let firstImage = item.product.imageNames.first {
                Image(firstImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            }
            
            // Информация
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text("\(item.product.price) ₽")
                    .font(.headline)
                    .foregroundColor(.brandPurple)
                
                // Количество
                HStack {
                    Button(action: {
                        viewModel.updateCartItemQuantity(item.id, quantity: item.quantity - 1)
                    }) {
                        Image(systemName: "minus.circle")
                    }
                    
                    Text("\(item.quantity)")
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        viewModel.updateCartItemQuantity(item.id, quantity: item.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            
            Spacer()
            
            // Удалить
            Button(action: {
                viewModel.removeFromCart(item.id)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Корзина пуста")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            Text(message)
                .font(.headline)
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ShopCartScreen_Previews: PreviewProvider {
    static var previews: some View {
        ShopCartScreen()
    }
}


