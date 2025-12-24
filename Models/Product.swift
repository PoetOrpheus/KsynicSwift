//
//  Product.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation
import SwiftUI

/**
 * Модель продукта
 */
struct Product: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let price: Int // Цена в копейках (для точности) или в рублях
    let oldPrice: Int? // Старая цена (опционально)
    let discount: Int? // Скидка в процентах (опционально)
    let rating: Double // Рейтинг от 0.0 до 5.0
    let reviewsCount: Int // Количество отзывов
    let images: [String] // Список URL изображений продукта (для реальных данных)
    let imageNames: [String] // Список имен изображений из Assets (для тестовых данных)
    let isTimeLimited: Bool // Ограниченное по времени предложение
    let accentColorHex: String // Акцентный цвет продукта в hex формате
    var isFavorite: Bool // В избранном
    let seller: Seller? // Информация о продавце
    let brand: Brand? // Информация о бренде
    let description: String? // Описание продукта
    let variants: [ProductVariant] // Варианты продукта (цвет, материал и т.д., но НЕ размеры)
    let sizes: [ProductSize] // Размеры продукта
    let specifications: [ProductSpecification] // Характеристики продукта
    var quantity: Int // Количество в корзине (для корзины)
    
    /**
     * Вычисляет процент скидки на основе старой и новой цены
     */
    func calculateDiscountPercent() -> Int? {
        guard let oldPrice = oldPrice, oldPrice > price, oldPrice > 0 else {
            return discount
        }
        return Int(((Double(oldPrice - price) / Double(oldPrice)) * 100))
    }
    
    /**
     * Проверяет, есть ли скидка на товар
     */
    func hasDiscount() -> Bool {
        return oldPrice != nil && oldPrice! > price
    }
    
    /**
     * Получить акцентный цвет
     */
    var accentColor: Color {
        Color(hex: accentColorHex) ?? Color.black
    }
}

/**
 * Модель продавца
 */
struct Seller: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let avatarUrl: String? // URL аватара продавца
    let rating: Double // Рейтинг продавца
    let ordersCount: Int // Количество заказов
    let reviewsCount: Int // Количество отзывов
}

/**
 * Модель бренда
 */
struct Brand: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let logoUrl: String? // URL логотипа бренда
}

/**
 * Модель характеристики продукта (пара ключ-значение)
 */
struct ProductSpecification: Codable, Equatable {
    let name: String // Название характеристики (например, "Материал", "Размер")
    let value: String // Значение характеристики (например, "Кожа", "42x30x10 см")
}

/**
 * Модель размера продукта
 */
struct ProductSize: Identifiable, Codable, Equatable {
    let id: String
    let value: String // Значение размера (например, "40", "M", "XL")
    let isAvailable: Bool // Доступен ли размер
}

/**
 * Модель варианта продукта (размер, цвет и т.д.)
 */
struct ProductVariant: Identifiable, Codable, Equatable {
    let id: String
    let name: String // Название варианта (например, "Размер: L" или "Цвет: Красный")
    let value: String // Значение варианта
    let isAvailable: Bool // Доступен ли вариант
    var imageNames: [String] // Список имен изображений варианта из Assets (для тестовых данных)
    let imagesUrl: [String] // Список URL изображений варианта для карусели (для реальных данных)
    
    /**
     * Получить первое изображение варианта (для миниатюры в списке вариантов)
     */
    func getFirstImageName() -> String? {
        return imageNames.first
    }
    
    /**
     * Получить первый URL изображения варианта (для миниатюры в списке вариантов)
     */
    func getFirstImageUrl() -> String? {
        return imagesUrl.first
    }
    
    /**
     * Проверяет, есть ли изображения у варианта
     */
    func hasImages() -> Bool {
        return !imageNames.isEmpty || !imagesUrl.isEmpty
    }
}

// MARK: - Color Extension для работы с hex цветами
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

