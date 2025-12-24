//
//  ProductRepositoryImpl.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation

/**
 * Реализация репозитория продуктов
 *
 * ====================================================================
 * ВНИМАНИЕ: Используются тестовые данные из TestData.swift
 * После интеграции с реальным API замените логику на работу с API/БД
 * ====================================================================
 */
class ProductRepositoryImpl: ProductRepository {
    
    private let localDataStore = LocalDataStore.shared
    private var favoriteProductIds = Set<String>()
    private var isFavoritesInitialized = false
    
    // Хранение корзины в памяти
    private var cartItems: [String: CartItem] = [:]
    
    func getAllProducts() async throws -> [Product] {
        // Сначала инициализируем избранные из локального хранилища
        await initializeFavoritesFromLocalStorage()
        
        // Затем пытаемся загрузить из кэша
        if let cachedProducts = localDataStore.getCachedProducts(),
           !localDataStore.shouldRefreshCache() {
            // Восстанавливаем imageNames из оригинальных тестовых данных
            let restoredProducts = restoreVariantsImageNames(cachedProducts)
            // Используем кэшированные данные, обновляя их с учетом избранных
            return updateProductsWithFavorites(restoredProducts)
        }
        
        // Имитация задержки сети (загрузка с сервера) - только если кэш отсутствует или устарел
        try await Task.sleep(nanoseconds: 500_000_000) // 500ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        let products = TestProducts.allProducts
        
        let productsWithFavorites = updateProductsWithFavorites(products)
        
        // Сохраняем в кэш
        localDataStore.cacheProducts(productsWithFavorites)
        
        return productsWithFavorites
    }
    
    /**
     * Инициализировать избранные из локального хранилища
     */
    private func initializeFavoritesFromLocalStorage() async {
        if !isFavoritesInitialized {
            let savedFavorites = localDataStore.getFavoriteProductIds()
            favoriteProductIds = savedFavorites
            
            // Если сохраненных избранных нет, инициализируем из тестовых данных
            if favoriteProductIds.isEmpty {
                for product in TestProducts.allProducts {
                    if product.isFavorite {
                        favoriteProductIds.insert(product.id)
                    }
                }
                // Сохраняем начальные избранные
                localDataStore.saveFavoriteProductIds(favoriteProductIds)
            }
            
            isFavoritesInitialized = true
        }
    }
    
    /**
     * Обновить продукты с учетом избранных
     */
    private func updateProductsWithFavorites(_ products: [Product]) -> [Product] {
        return products.map { product in
            // Создаем новый Product с обновленным isFavorite
            return Product(
                id: product.id,
                name: product.name,
                price: product.price,
                oldPrice: product.oldPrice,
                discount: product.discount,
                rating: product.rating,
                reviewsCount: product.reviewsCount,
                images: product.images,
                imageNames: product.imageNames,
                isTimeLimited: product.isTimeLimited,
                accentColorHex: product.accentColorHex,
                isFavorite: favoriteProductIds.contains(product.id),
                seller: product.seller,
                brand: product.brand,
                description: product.description,
                variants: product.variants,
                sizes: product.sizes,
                specifications: product.specifications,
                quantity: product.quantity
            )
        }
    }
    
    /**
     * Восстанавливает imageNames для вариантов продукта из оригинальных тестовых данных
     */
    private func restoreVariantsImageNames(_ products: [Product]) -> [Product] {
        let originalProducts = Dictionary(uniqueKeysWithValues: TestProducts.allProducts.map { ($0.id, $0) })
        
        return products.map { product in
            guard let originalProduct = originalProducts[product.id] else {
                return product
            }
            
            // Создаем Map оригинальных вариантов по id для быстрого поиска
            let originalVariantsMap = Dictionary(uniqueKeysWithValues: originalProduct.variants.map { ($0.id, $0) })
            
            // Восстанавливаем imageNames для каждого варианта
            let restoredVariants = product.variants.map { variant -> ProductVariant in
                guard let originalVariant = originalVariantsMap[variant.id] else {
                    return variant
                }
                
                // Всегда восстанавливаем imageNames из оригинала
                if variant.imageNames.isEmpty {
                    return ProductVariant(
                        id: variant.id,
                        name: variant.name,
                        value: variant.value,
                        isAvailable: variant.isAvailable,
                        imageNames: originalVariant.imageNames,
                        imagesUrl: variant.imagesUrl
                    )
                }
                return variant
            }
            
            // Также восстанавливаем imageNames продукта
            let restoredImageNames = product.imageNames.isEmpty ? originalProduct.imageNames : product.imageNames
            
            // Создаем новый Product с обновленными данными
            var updatedProduct = Product(
                id: product.id,
                name: product.name,
                price: product.price,
                oldPrice: product.oldPrice,
                discount: product.discount,
                rating: product.rating,
                reviewsCount: product.reviewsCount,
                images: product.images,
                imageNames: restoredImageNames,
                isTimeLimited: product.isTimeLimited,
                accentColorHex: product.accentColorHex,
                isFavorite: product.isFavorite,
                seller: product.seller,
                brand: product.brand,
                description: product.description,
                variants: restoredVariants,
                sizes: product.sizes,
                specifications: product.specifications,
                quantity: product.quantity
            )
            return updatedProduct
        }
    }
    
    func getProductById(_ id: String) async throws -> Product? {
        // Инициализируем избранные, если еще не инициализированы
        await initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        guard let product = TestProducts.allProducts.first(where: { $0.id == id }) else {
            return nil
        }
        
        // Создаем новый Product с обновленным isFavorite
        var updatedProduct = Product(
            id: product.id,
            name: product.name,
            price: product.price,
            oldPrice: product.oldPrice,
            discount: product.discount,
            rating: product.rating,
            reviewsCount: product.reviewsCount,
            images: product.images,
            imageNames: product.imageNames,
            isTimeLimited: product.isTimeLimited,
            accentColorHex: product.accentColorHex,
            isFavorite: favoriteProductIds.contains(id),
            seller: product.seller,
            brand: product.brand,
            description: product.description,
            variants: product.variants,
            sizes: product.sizes,
            specifications: product.specifications,
            quantity: product.quantity
        )
        return updatedProduct
    }
    
    func getProductsByCategory(_ categoryId: String) async throws -> [Product] {
        // Инициализируем избранные, если еще не инициализированы
        await initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 400_000_000) // 400ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        // В реальном приложении здесь будет фильтрация по категории
        // Пока возвращаем все продукты
        let products = TestProducts.allProducts
        return updateProductsWithFavorites(products)
    }
    
    func searchProducts(_ query: String) async throws -> [Product] {
        // Инициализируем избранные, если еще не инициализированы
        await initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 400_000_000) // 400ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        let lowerQuery = query.lowercased()
        let filteredProducts = TestProducts.allProducts.filter { product in
            product.name.lowercased().contains(lowerQuery) ||
            product.brand?.name.lowercased().contains(lowerQuery) == true ||
            product.description?.lowercased().contains(lowerQuery) == true
        }
        return updateProductsWithFavorites(filteredProducts)
    }
    
    func getFavoriteProducts() async throws -> [Product] {
        // Инициализируем избранные, если еще не инициализированы
        await initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        return TestProducts.allProducts
            .filter { favoriteProductIds.contains($0.id) }
            .map { product in
                var updatedProduct = product
                updatedProduct.isFavorite = true
                return updatedProduct
            }
    }
    
    func addToFavorites(_ productId: String) async throws -> Bool {
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 200_000_000) // 200ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        favoriteProductIds.insert(productId)
        
        // Сохраняем в локальное хранилище
        localDataStore.saveFavoriteProductIds(favoriteProductIds)
        
        return true
    }
    
    func removeFromFavorites(_ productId: String) async throws -> Bool {
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 200_000_000) // 200ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        favoriteProductIds.remove(productId)
        
        // Сохраняем в локальное хранилище
        localDataStore.saveFavoriteProductIds(favoriteProductIds)
        
        return true
    }
    
    func getCartItems() async throws -> [CartItem] {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        // Загружаем корзину из локального хранилища при первом запросе
        if cartItems.isEmpty {
            await loadCartFromLocalStorage()
        } else {
            // ВСЕГДА обновляем состояние избранного перед возвратом корзины
            await updateCartItemsFavoriteState()
        }
        
        return Array(cartItems.values)
    }
    
    func addToCart(
        product: Product,
        selectedVariantId: String?,
        selectedSizeId: String?,
        quantity: Int
    ) async throws -> Bool {
        try await Task.sleep(nanoseconds: 200_000_000) // 200ms
        
        // Создаем уникальный ID для элемента корзины
        let cartItemId = generateCartItemId(
            productId: product.id,
            variantId: selectedVariantId,
            sizeId: selectedSizeId
        )
        
        // Проверяем, есть ли уже такой товар в корзине
        if let existingItem = cartItems[cartItemId] {
            // Если товар уже есть, увеличиваем количество
            cartItems[cartItemId] = CartItem(
                id: existingItem.id,
                product: existingItem.product,
                selectedVariantId: existingItem.selectedVariantId,
                selectedSizeId: existingItem.selectedSizeId,
                quantity: existingItem.quantity + quantity,
                isSelected: existingItem.isSelected
            )
        } else {
            // Добавляем новый товар в корзину (по умолчанию выбран)
            cartItems[cartItemId] = CartItem(
                id: cartItemId,
                product: product,
                selectedVariantId: selectedVariantId,
                selectedSizeId: selectedSizeId,
                quantity: quantity,
                isSelected: true
            )
        }
        
        // Сохраняем в DataStore
        await saveCartToLocalStorage()
        
        return true
    }
    
    func updateCartItemQuantity(_ cartItemId: String, quantity: Int) async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        guard let item = cartItems[cartItemId] else {
            return false
        }
        
        if quantity <= 0 {
            // Удаляем товар, если количество <= 0
            cartItems.removeValue(forKey: cartItemId)
        } else {
            let updatedItem = CartItem(
                id: item.id,
                product: item.product,
                selectedVariantId: item.selectedVariantId,
                selectedSizeId: item.selectedSizeId,
                quantity: quantity,
                isSelected: item.isSelected
            )
            cartItems[cartItemId] = updatedItem
        }
        
        await saveCartToLocalStorage()
        return true
    }
    
    func toggleCartItemSelection(_ cartItemId: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        guard let item = cartItems[cartItemId] else {
            return false
        }
        
        let updatedItem = CartItem(
            id: item.id,
            product: item.product,
            selectedVariantId: item.selectedVariantId,
            selectedSizeId: item.selectedSizeId,
            quantity: item.quantity,
            isSelected: !item.isSelected
        )
        cartItems[cartItemId] = updatedItem
        
        await saveCartToLocalStorage()
        return true
    }
    
    func removeFromCart(_ cartItemId: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        let removed = cartItems.removeValue(forKey: cartItemId) != nil
        
        if removed {
            await saveCartToLocalStorage()
        }
        
        return removed
    }
    
    func clearCart() async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        cartItems.removeAll()
        await saveCartToLocalStorage()
        
        return true
    }
    
    func getCartTotal() async throws -> Int {
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        // Считаем только выбранные товары
        return cartItems.values
            .filter { $0.isSelected }
            .reduce(0) { $0 + $1.getTotalPrice() }
    }
    
    // MARK: - Private Helpers
    
    /**
     * Сохранить корзину в локальное хранилище
     */
    private func saveCartToLocalStorage() async {
        localDataStore.saveCartItems(Array(cartItems.values))
    }
    
    /**
     * Загрузить корзину из локального хранилища при инициализации
     */
    private func loadCartFromLocalStorage() async {
        let savedCartData = localDataStore.getCartItemsData()
        guard !savedCartData.isEmpty else { return }
        
        // Загружаем все продукты, чтобы восстановить корзину
        do {
            let allProducts = try await getAllProducts()
            let productsMap = Dictionary(uniqueKeysWithValues: allProducts.map { ($0.id, $0) })
            
            // Восстанавливаем корзину из сохраненных данных
            for cartItemData in savedCartData {
                if let product = productsMap[cartItemData.productId] {
                    cartItems[cartItemData.id] = CartItem(
                        id: cartItemData.id,
                        product: product,
                        selectedVariantId: cartItemData.selectedVariantId,
                        selectedSizeId: cartItemData.selectedSizeId,
                        quantity: cartItemData.quantity,
                        isSelected: cartItemData.isSelected
                    )
                }
            }
        } catch {
            print("ProductRepositoryImpl: Ошибка при загрузке корзины: \(error)")
        }
    }
    
    /**
     * Обновить состояние избранного для продуктов в корзине
     */
    private func updateCartItemsFavoriteState() async {
        // ВСЕГДА перезагружаем избранные из LocalDataStore для получения актуального состояния
        let currentFavorites = localDataStore.getFavoriteProductIds()
        favoriteProductIds = currentFavorites
        
        // Обновляем все товары в корзине с актуальным состоянием избранного
        for (id, cartItem) in cartItems {
            let shouldBeFavorite = favoriteProductIds.contains(cartItem.product.id)
            if cartItem.product.isFavorite != shouldBeFavorite {
                let updatedProduct = Product(
                    id: cartItem.product.id,
                    name: cartItem.product.name,
                    price: cartItem.product.price,
                    oldPrice: cartItem.product.oldPrice,
                    discount: cartItem.product.discount,
                    rating: cartItem.product.rating,
                    reviewsCount: cartItem.product.reviewsCount,
                    images: cartItem.product.images,
                    imageNames: cartItem.product.imageNames,
                    isTimeLimited: cartItem.product.isTimeLimited,
                    accentColorHex: cartItem.product.accentColorHex,
                    isFavorite: shouldBeFavorite,
                    seller: cartItem.product.seller,
                    brand: cartItem.product.brand,
                    description: cartItem.product.description,
                    variants: cartItem.product.variants,
                    sizes: cartItem.product.sizes,
                    specifications: cartItem.product.specifications,
                    quantity: cartItem.product.quantity
                )
                let updatedItem = CartItem(
                    id: cartItem.id,
                    product: updatedProduct,
                    selectedVariantId: cartItem.selectedVariantId,
                    selectedSizeId: cartItem.selectedSizeId,
                    quantity: cartItem.quantity,
                    isSelected: cartItem.isSelected
                )
                cartItems[id] = updatedItem
            }
        }
    }
    
    /**
     * Генерирует уникальный ID для элемента корзины
     */
    private func generateCartItemId(productId: String, variantId: String?, sizeId: String?) -> String {
        return "\(productId)_\(variantId ?? "no_variant")_\(sizeId ?? "no_size")"
    }
}


