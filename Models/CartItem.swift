//
//  CartItem.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation

/**
 * Модель товара в корзине
 * Содержит информацию о продукте, выбранном варианте, размере и количестве
 */
struct CartItem: Identifiable, Codable, Equatable {
    let id: String // Уникальный ID элемента корзины (может быть комбинацией productId + variantId + sizeId)
    let product: Product
    let selectedVariantId: String? // ID выбранного варианта (цвет и т.д.)
    let selectedSizeId: String? // ID выбранного размера
    var quantity: Int // Количество товара
    var isSelected: Bool // Выбран ли товар для покупки (по умолчанию выбран)
    
    /**
     * Вычисляет итоговую цену за все количество товара
     */
    func getTotalPrice() -> Int {
        return product.price * quantity
    }
    
    /**
     * Получить название выбранного варианта
     */
    func getSelectedVariantName() -> String? {
        guard let variantId = selectedVariantId else { return nil }
        return product.variants.first { $0.id == variantId }?.name
    }
    
    /**
     * Получить название выбранного размера
     */
    func getSelectedSizeName() -> String? {
        guard let sizeId = selectedSizeId else { return nil }
        return product.sizes.first { $0.id == sizeId }?.value
    }
}


