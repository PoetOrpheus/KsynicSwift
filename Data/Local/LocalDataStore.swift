//
//  LocalDataStore.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation
import Combine

/**
 * Класс для работы с локальным хранилищем данных
 * Использует UserDefaults для простоты (можно заменить на Core Data или Realm)
 */
class LocalDataStore {
    
    static let shared = LocalDataStore()
    
    private let userDefaults = UserDefaults.standard
    
    // Ключи для хранения данных
    private let favoriteProductIdsKey = "favorite_product_ids"
    private let cachedProductsKey = "cached_products_json"
    private let productsCacheTimestampKey = "products_cache_timestamp"
    private let userProfileKey = "user_profile_json"
    private let cartItemsKey = "cart_items_json"
    private let isLoggedInKey = "is_logged_in"
    
    private init() {}
    
    // MARK: - Favorites
    
    /**
     * Получить список ID избранных продуктов
     */
    func getFavoriteProductIds() -> Set<String> {
        if let array = userDefaults.array(forKey: favoriteProductIdsKey) as? [String] {
            return Set(array)
        }
        return Set<String>()
    }
    
    /**
     * Сохранить список ID избранных продуктов
     */
    func saveFavoriteProductIds(_ productIds: Set<String>) {
        userDefaults.set(Array(productIds), forKey: favoriteProductIdsKey)
    }
    
    /**
     * Добавить продукт в избранное
     */
    func addToFavorites(productId: String) {
        var favorites = getFavoriteProductIds()
        favorites.insert(productId)
        saveFavoriteProductIds(favorites)
    }
    
    /**
     * Удалить продукт из избранного
     */
    func removeFromFavorites(productId: String) {
        var favorites = getFavoriteProductIds()
        favorites.remove(productId)
        saveFavoriteProductIds(favorites)
    }
    
    /**
     * Проверить, находится ли продукт в избранном
     */
    func isFavorite(productId: String) -> Bool {
        return getFavoriteProductIds().contains(productId)
    }
    
    // MARK: - Products Cache
    
    /**
     * Сохранить кэш продуктов
     */
    func cacheProducts(_ products: [Product]) {
        do {
            let encoder = JSONEncoder()
            let productsData = try encoder.encode(products)
            let productsJson = String(data: productsData, encoding: .utf8) ?? ""
            let timestamp = Date().timeIntervalSince1970
            
            userDefaults.set(productsJson, forKey: cachedProductsKey)
            userDefaults.set(timestamp, forKey: productsCacheTimestampKey)
        } catch {
            print("LocalDataStore: Ошибка при кэшировании продуктов: \(error)")
        }
    }
    
    /**
     * Получить кэш продуктов
     */
    func getCachedProducts() -> [Product]? {
        guard let productsJson = userDefaults.string(forKey: cachedProductsKey),
              !productsJson.isEmpty,
              let productsData = productsJson.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let products = try decoder.decode([Product].self, from: productsData)
            return products
        } catch {
            print("LocalDataStore: Ошибка при загрузке кэша продуктов: \(error)")
            return nil
        }
    }
    
    /**
     * Получить время последнего обновления кэша
     */
    func getCacheTimestamp() -> TimeInterval? {
        let timestamp = userDefaults.double(forKey: productsCacheTimestampKey)
        return timestamp > 0 ? timestamp : nil
    }
    
    /**
     * Очистить кэш продуктов
     */
    func clearProductsCache() {
        userDefaults.removeObject(forKey: cachedProductsKey)
        userDefaults.removeObject(forKey: productsCacheTimestampKey)
    }
    
    /**
     * Проверить, нужно ли обновлять кэш (например, если прошло более 1 часа)
     */
    func shouldRefreshCache(maxCacheAgeMs: TimeInterval = 3600) -> Bool {
        guard let timestamp = getCacheTimestamp() else {
            return true
        }
        let now = Date().timeIntervalSince1970
        return (now - timestamp) > maxCacheAgeMs
    }
    
    // MARK: - User Profile
    
    /**
     * Сохранить профиль пользователя
     */
    func saveUserProfile(_ profile: UserProfile) {
        do {
            let encoder = JSONEncoder()
            let profileData = try encoder.encode(profile)
            let profileJson = String(data: profileData, encoding: .utf8) ?? ""
            userDefaults.set(profileJson, forKey: userProfileKey)
        } catch {
            print("LocalDataStore: Ошибка при сохранении профиля: \(error)")
        }
    }
    
    /**
     * Получить профиль пользователя
     */
    func getUserProfile() -> UserProfile? {
        guard let profileJson = userDefaults.string(forKey: userProfileKey),
              !profileJson.isEmpty,
              let profileData = profileJson.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let profile = try decoder.decode(UserProfile.self, from: profileData)
            return profile
        } catch {
            print("LocalDataStore: Ошибка при загрузке профиля: \(error)")
            return nil
        }
    }
    
    /**
     * Получить профиль пользователя или профиль по умолчанию
     */
    func getUserProfileOrDefault() -> UserProfile {
        return getUserProfile() ?? UserProfile.default()
    }
    
    // MARK: - Cart
    
    /**
     * DTO для сохранения данных корзины
     */
    struct CartItemData: Codable {
        let id: String
        let productId: String
        let selectedVariantId: String?
        let selectedSizeId: String?
        let quantity: Int
        let isSelected: Bool
    }
    
    /**
     * Сохранить корзину
     */
    func saveCartItems(_ cartItems: [CartItem]) {
        do {
            // Конвертируем CartItem в упрощенную структуру для сохранения
            let cartItemsData = cartItems.map { item in
                CartItemData(
                    id: item.id,
                    productId: item.product.id,
                    selectedVariantId: item.selectedVariantId,
                    selectedSizeId: item.selectedSizeId,
                    quantity: item.quantity,
                    isSelected: item.isSelected
                )
            }
            
            let encoder = JSONEncoder()
            let cartItemsDataEncoded = try encoder.encode(cartItemsData)
            let cartItemsJson = String(data: cartItemsDataEncoded, encoding: .utf8) ?? ""
            userDefaults.set(cartItemsJson, forKey: cartItemsKey)
        } catch {
            print("LocalDataStore: Ошибка при сохранении корзины: \(error)")
        }
    }
    
    /**
     * Получить сохраненные данные корзины
     */
    func getCartItemsData() -> [CartItemData] {
        guard let cartItemsJson = userDefaults.string(forKey: cartItemsKey),
              !cartItemsJson.isEmpty,
              let cartItemsData = cartItemsJson.data(using: .utf8) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let cartItems = try decoder.decode([CartItemData].self, from: cartItemsData)
            return cartItems
        } catch {
            print("LocalDataStore: Ошибка при загрузке корзины: \(error)")
            return []
        }
    }
    
    /**
     * Очистить корзину
     */
    func clearCartItems() {
        userDefaults.removeObject(forKey: cartItemsKey)
    }
    
    // MARK: - Authentication
    
    /**
     * Проверить, авторизован ли пользователь
     */
    func isLoggedIn() -> Bool {
        return userDefaults.bool(forKey: isLoggedInKey)
    }
    
    /**
     * Сохранить состояние авторизации
     */
    func setLoggedIn(_ isLoggedIn: Bool) {
        userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
    }
    
    /**
     * Выйти из аккаунта
     */
    func logout() {
        userDefaults.set(false, forKey: isLoggedInKey)
        // Можно также очистить профиль, если нужно
        // userDefaults.removeObject(forKey: userProfileKey)
    }
}


