//
//  CartViewModel.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation
import Combine

/**
 * ViewModel для работы с корзиной
 */
@MainActor
class CartViewModel: ObservableObject {
    
    private let productRepository: ProductRepository
    
    @Published var cartState: UiState<[CartItem]> = .idle
    @Published var cartTotal: Int = 0
    
    // Флаг для отслеживания, были ли данные загружены
    private var hasLoadedCart = false
    
    init(productRepository: ProductRepository = ProductRepositoryImpl()) {
        self.productRepository = productRepository
    }
    
    /**
     * Загрузить корзину
     */
    func loadCart() {
        // Убираем проверку, чтобы корзина всегда обновлялась
        Task {
            cartState = .loading
            do {
                let cartItems = try await productRepository.getCartItems()
                cartState = .success(cartItems)
                await updateCartTotal(cartItems)
                hasLoadedCart = true
            } catch {
                cartState = .error(message: error.localizedDescription, error: error)
            }
        }
    }
    
    /**
     * Добавить товар в корзину
     */
    func addToCart(
        product: Product,
        selectedVariantId: String? = nil,
        selectedSizeId: String? = nil,
        quantity: Int = 1
    ) {
        Task {
            do {
                let success = try await productRepository.addToCart(
                    product: product,
                    selectedVariantId: selectedVariantId,
                    selectedSizeId: selectedSizeId,
                    quantity: quantity
                )
                if success {
                    // Оптимизированное обновление - получаем только новые данные
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /**
     * Оптимизированное обновление состояния корзины без полной перезагрузки
     */
    func refreshCartState() async {
        do {
            let cartItems = try await productRepository.getCartItems()
            cartState = .success(cartItems)
            await updateCartTotal(cartItems)
        } catch {
            // Обработка ошибки
        }
    }
    
    /**
     * Обновить количество товара в корзине
     */
    func updateCartItemQuantity(_ cartItemId: String, quantity: Int) {
        Task {
            do {
                let success = try await productRepository.updateCartItemQuantity(cartItemId, quantity: quantity)
                if success {
                    // Оптимизированное обновление
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /**
     * Переключить выбранное состояние товара в корзине
     */
    func toggleCartItemSelection(_ cartItemId: String) {
        Task {
            do {
                let success = try await productRepository.toggleCartItemSelection(cartItemId)
                if success {
                    // Оптимизированное обновление
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /**
     * Удалить товар из корзины
     */
    func removeFromCart(_ cartItemId: String) {
        Task {
            do {
                let success = try await productRepository.removeFromCart(cartItemId)
                if success {
                    // Оптимизированное обновление
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /**
     * Очистить корзину
     */
    func clearCart() {
        Task {
            do {
                let success = try await productRepository.clearCart()
                if success {
                    cartState = .success([])
                    cartTotal = 0
                    hasLoadedCart = false
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /**
     * Обновить общую стоимость корзины
     */
    private func updateCartTotal(_ cartItems: [CartItem]) async {
        do {
            let total = try await productRepository.getCartTotal()
            cartTotal = total
        } catch {
            // Обработка ошибки
        }
    }
    
    /**
     * Получить количество товаров в корзине
     */
    func getCartItemsCount() -> Int {
        if case .success(let items) = cartState {
            return items.reduce(0) { $0 + $1.quantity }
        }
        return 0
    }
}


