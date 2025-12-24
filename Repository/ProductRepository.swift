//
//  ProductRepository.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation
import Combine

/**
 * Репозиторий для работы с продуктами
 * Здесь будет логика получения данных (из API, локальной БД и т.д.)
 */
protocol ProductRepository {
    /**
     * Получить все продукты
     */
    func getAllProducts() async throws -> [Product]
    
    /**
     * Получить продукт по ID
     */
    func getProductById(_ id: String) async throws -> Product?
    
    /**
     * Получить продукты по категории
     */
    func getProductsByCategory(_ categoryId: String) async throws -> [Product]
    
    /**
     * Поиск продуктов
     */
    func searchProducts(_ query: String) async throws -> [Product]
    
    /**
     * Получить избранные продукты
     */
    func getFavoriteProducts() async throws -> [Product]
    
    /**
     * Добавить продукт в избранное
     */
    func addToFavorites(_ productId: String) async throws -> Bool
    
    /**
     * Удалить продукт из избранного
     */
    func removeFromFavorites(_ productId: String) async throws -> Bool
    
    /**
     * Получить все товары в корзине
     */
    func getCartItems() async throws -> [CartItem]
    
    /**
     * Добавить товар в корзину
     */
    func addToCart(
        product: Product,
        selectedVariantId: String?,
        selectedSizeId: String?,
        quantity: Int
    ) async throws -> Bool
    
    /**
     * Обновить количество товара в корзине
     */
    func updateCartItemQuantity(_ cartItemId: String, quantity: Int) async throws -> Bool
    
    /**
     * Переключить выбранное состояние товара в корзине
     */
    func toggleCartItemSelection(_ cartItemId: String) async throws -> Bool
    
    /**
     * Удалить товар из корзины
     */
    func removeFromCart(_ cartItemId: String) async throws -> Bool
    
    /**
     * Очистить корзину
     */
    func clearCart() async throws -> Bool
    
    /**
     * Получить общую стоимость корзины
     */
    func getCartTotal() async throws -> Int
}


