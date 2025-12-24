//
//  TestData.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation
import SwiftUI

// ====================================================================
// ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С РЕАЛЬНЫМ API
// ====================================================================
// Этот файл содержит примеры данных для демонстрации и тестирования.
// После подключения к реальному API этот файл должен быть удален.

/**
 * Тестовые данные - Бренды
 */
struct TestBrands {
    static let adidas = Brand(
        id: "brand_1",
        name: "Adidas",
        logoUrl: nil
    )
    
    static let calvinKlein = Brand(
        id: "brand_2",
        name: "Calvin Klein",
        logoUrl: nil
    )
    
    static let nike = Brand(
        id: "brand_3",
        name: "Nike",
        logoUrl: nil
    )
    
    static let apple = Brand(
        id: "brand_4",
        name: "Apple",
        logoUrl: nil
    )
    
    static let samsung = Brand(
        id: "brand_5",
        name: "Samsung",
        logoUrl: nil
    )
    
    static let allBrands = [adidas, calvinKlein, nike, apple, samsung]
}

/**
 * Тестовые данные - Продавцы
 */
struct TestSellers {
    static let operatorZamesov = Seller(
        id: "seller_1",
        name: "Оператор замесов",
        avatarUrl: nil,
        rating: 4.9,
        ordersCount: 3400,
        reviewsCount: 543
    )
    
    static let fashionStore = Seller(
        id: "seller_2",
        name: "Fashion Store",
        avatarUrl: nil,
        rating: 4.8,
        ordersCount: 1200,
        reviewsCount: 287
    )
    
    static let techShop = Seller(
        id: "seller_3",
        name: "TechShop",
        avatarUrl: nil,
        rating: 5.0,
        ordersCount: 5600,
        reviewsCount: 892
    )
    
    static let sportStyle = Seller(
        id: "seller_4",
        name: "Sport Style",
        avatarUrl: nil,
        rating: 4.7,
        ordersCount: 2100,
        reviewsCount: 156
    )
    
    static let watchMaster = Seller(
        id: "seller_5",
        name: "Watch Master",
        avatarUrl: nil,
        rating: 4.9,
        ordersCount: 890,
        reviewsCount: 234
    )
    
    static let allSellers = [operatorZamesov, fashionStore, techShop, sportStyle, watchMaster]
}

/**
 * Тестовые данные - Продукты
 */
struct TestProducts {
    // Продукт 1: Кеды Adidas (без скидки)
    static let adidasSneakers = Product(
        id: "product_1",
        name: "Кеды adidas Sportswear Hoops 3.0",
        price: 3743,
        oldPrice: nil,
        discount: nil,
        rating: 4.9,
        reviewsCount: 457,
        images: [],
        imageNames: ["adidas_1_1", "adidas_1", "adidas_2", "adidas_2_1"],
        isTimeLimited: false,
        accentColorHex: "#000000",
        isFavorite: false,
        seller: TestSellers.sportStyle,
        brand: TestBrands.adidas,
        description: "Спортивные кеды Adidas Sportswear Hoops 3.0. Удобная подошва и современный дизайн.",
        specifications: [
            ProductSpecification(name: "Материал верха", value: "Текстиль, синтетика"),
            ProductSpecification(name: "Материал подошвы", value: "Резина"),
            ProductSpecification(name: "Страна производства", value: "Китай"),
            ProductSpecification(name: "Вес", value: "350 г")
        ],
        sizes: [
            ProductSize(id: "size_1_1", value: "40", isAvailable: true),
            ProductSize(id: "size_1_2", value: "41", isAvailable: true),
            ProductSize(id: "size_1_3", value: "42", isAvailable: true),
            ProductSize(id: "size_1_4", value: "43", isAvailable: false)
        ],
        variants: [
            ProductVariant(
                id: "variant_1_1",
                name: "Цвет",
                value: "Черный",
                isAvailable: true,
                imageNames: ["adidas_1", "adidas_1_1"],
                imagesUrl: []
            ),
            ProductVariant(
                id: "variant_1_2",
                name: "Цвет",
                value: "Белый",
                isAvailable: true,
                imageNames: ["adidas_2", "adidas_2_1"],
                imagesUrl: []
            )
        ],
        quantity: 1
    )
    
    // Продукт 2: Часы наручные (со скидкой)
    static let quartzWatch = Product(
        id: "product_2",
        name: "Часы наручные Кварцевые",
        price: 4200,
        oldPrice: 21000,
        discount: 80,
        rating: 5.0,
        reviewsCount: 23,
        images: [],
        imageNames: ["image_for_product_3", "watch_cvarch_1", "watch_cvarch_2", "watch_cvarch_1_2", "watch_cvarch_3"],
        isTimeLimited: true,
        accentColorHex: "#CC3333",
        isFavorite: false,
        seller: TestSellers.watchMaster,
        brand: TestBrands.calvinKlein,
        description: "Элегантность и стиль — важные аспекты мужского образа, и часы являются его незаменимым атрибутом. Эти часы наручные мужские идеально подходят для современных мужчин, стремящихся подчеркнуть свою индивидуальность. Они отлично смотрятся как в повседневной жизни, так и на официальных мероприятиях.\n Каждая деталь этих мужских часов наручных выполнена с вниманием и качеством, что делает их не только красивыми, но и надежными. Если вы ищете наручные часы мужские, которые способны выдерживать эксплуатацию в различных условиях, обратите внимание на модель с водонепроницаемыми характеристиками. Часы наручные мужские водонепроницаемые понравятся тем, кто ведет активный образ жизни, ведь они защищены от воздействия воды и пыли.\n Бренд Calvin Klein символизирует стиль и инновации. Часы Calvin Klein мужские привлекают внимание своим лаконичным дизайном и высоким качеством материалов. Они станут отличным дополнением как к деловому костюму, так и к повседневной одежде. Мужские часы от Calvin Klein — это выбор мужчин, ценящих комфорт и утонченность.\n Не упустите возможность стать обладателем этих великолепных часов. Идеальные часы для работы, отдыха и встреч с друзьями ждут вас! Сделайте шаг к своему стилю уже сегодня!",
        specifications: [
            ProductSpecification(name: "Тип механизма", value: "Кварцевый"),
            ProductSpecification(name: "Материал корпуса", value: "Нержавеющая сталь"),
            ProductSpecification(name: "Водостойкость", value: "30 м"),
            ProductSpecification(name: "Диаметр корпуса", value: "40 мм")
        ],
        variants: [
            ProductVariant(
                id: "variant_2_1",
                name: "Цвет",
                value: "Черный",
                isAvailable: true,
                imageNames: ["watch_cvarch_1", "watch_cvarch_1_2"],
                imagesUrl: []
            ),
            ProductVariant(
                id: "variant_2_2",
                name: "Цвет",
                value: "Золотистый",
                isAvailable: true,
                imageNames: ["watch_cvarch_2"],
                imagesUrl: []
            ),
            ProductVariant(
                id: "variant_3",
                name: "Цвет",
                value: "Серебристый",
                isAvailable: false,
                imageNames: ["watch_cvarch_3"],
                imagesUrl: []
            )
        ],
        quantity: 1
    )
    
    // Продукт 3: Часы Calvin Klein (детальный экран)
    static let calvinKleinWatch = Product(
        id: "product_3",
        name: "Часы наручные Calvin Klein черные мужские",
        price: 4200,
        oldPrice: 21000,
        discount: 80,
        rating: 4.9,
        reviewsCount: 457,
        images: [],
        imageNames: ["watch_calvin", "watch_calvin_1"],
        isTimeLimited: true,
        accentColorHex: "#CC3333",
        isFavorite: true,
        seller: TestSellers.operatorZamesov,
        brand: TestBrands.calvinKlein,
        description: "Премиальные мужские наручные часы Calvin Klein. Черный корпус, кожаный ремешок. Водостойкость 50м.",
        specifications: [
            ProductSpecification(name: "Бренд", value: "Calvin Klein"),
            ProductSpecification(name: "Тип механизма", value: "Кварцевый"),
            ProductSpecification(name: "Материал корпуса", value: "Нержавеющая сталь"),
            ProductSpecification(name: "Материал ремешка", value: "Кожа"),
            ProductSpecification(name: "Водостойкость", value: "50 м"),
            ProductSpecification(name: "Диаметр корпуса", value: "42 мм"),
            ProductSpecification(name: "Толщина корпуса", value: "8 мм"),
            ProductSpecification(name: "Циферблат", value: "Черный с люминесцентными стрелками")
        ],
        variants: [
            ProductVariant(
                id: "variant_3_1",
                name: "Цвет",
                value: "Серый",
                isAvailable: true,
                imageNames: ["watch_calvin"],
                imagesUrl: []
            ),
            ProductVariant(
                id: "variant_3_2",
                name: "Цвет",
                value: "Чёрный",
                isAvailable: true,
                imageNames: ["watch_calvin_1"],
                imagesUrl: []
            )
        ],
        quantity: 2
    )
    
    // Продукт 4: iPhone (техника)
    static let iPhone = Product(
        id: "product_4",
        name: "iPhone 15 Pro 256GB",
        price: 89990,
        oldPrice: 99990,
        discount: 10,
        rating: 4.8,
        reviewsCount: 1234,
        images: [],
        imageNames: ["iphone_1", "iphone_2", "iphone3"],
        isTimeLimited: false,
        accentColorHex: "#007AFF",
        isFavorite: false,
        seller: TestSellers.techShop,
        brand: TestBrands.apple,
        description: "Новый iPhone 15 Pro с чипом A17 Pro, камерой Pro и дисплеем ProMotion.",
        specifications: [
            ProductSpecification(name: "Диагональ экрана", value: "6.1 дюйма"),
            ProductSpecification(name: "Процессор", value: "Apple A17 Pro"),
            ProductSpecification(name: "Объем памяти", value: "256 ГБ"),
            ProductSpecification(name: "Камера", value: "48 Мп + 12 Мп + 12 Мп"),
            ProductSpecification(name: "Батарея", value: "До 23 часов видео"),
            ProductSpecification(name: "ОС", value: "iOS 17"),
            ProductSpecification(name: "Вес", value: "187 г")
        ],
        sizes: [],
        variants: [
            ProductVariant(id: "variant_4_1", name: "Цвет", value: "Титановый синий", isAvailable: true, imageNames: ["iphone_1"], imagesUrl: []),
            ProductVariant(id: "variant_4_2", name: "Цвет", value: "Титановый белый", isAvailable: true, imageNames: ["iphone_2"], imagesUrl: []),
            ProductVariant(id: "variant_4_3", name: "Цвет", value: "Титановый черный", isAvailable: true, imageNames: ["iphone3"], imagesUrl: []),
            ProductVariant(id: "variant_4_5", name: "Память", value: "128GB", isAvailable: true, imageNames: [], imagesUrl: []),
            ProductVariant(id: "variant_4_5", name: "Память", value: "256GB", isAvailable: true, imageNames: [], imagesUrl: []),
            ProductVariant(id: "variant_4_6", name: "Память", value: "512GB", isAvailable: false, imageNames: [], imagesUrl: [])
        ],
        quantity: 1
    )
    
    // Продукт 5: Кроссовки Nike (спорт)
    static let nikeShoes = Product(
        id: "product_5",
        name: "Кроссовки Nike Air Max 270",
        price: 8999,
        oldPrice: nil,
        discount: nil,
        rating: 4.6,
        reviewsCount: 89,
        images: [],
        imageNames: ["watch_1", "watch_2"],
        isTimeLimited: false,
        accentColorHex: "#000000",
        isFavorite: true,
        seller: TestSellers.fashionStore,
        brand: TestBrands.nike,
        description: "Кроссовки Nike Air Max 270 с технологией Air для максимального комфорта при беге и ходьбе.",
        specifications: [
            ProductSpecification(name: "Материал верха", value: "Синтетическая кожа, текстиль"),
            ProductSpecification(name: "Технология подошвы", value: "Air Max"),
            ProductSpecification(name: "Страна производства", value: "Вьетнам"),
            ProductSpecification(name: "Вес", value: "320 г"),
            ProductSpecification(name: "Тип застежки", value: "Шнуровка")
        ],
        sizes: [
            ProductSize(id: "size_5_1", value: "39", isAvailable: true),
            ProductSize(id: "size_5_2", value: "40", isAvailable: true),
            ProductSize(id: "size_5_3", value: "41", isAvailable: true),
            ProductSize(id: "size_5_4", value: "42", isAvailable: true),
            ProductSize(id: "size_5_5", value: "43", isAvailable: false)
        ],
        variants: [
            ProductVariant(id: "variant_5_1", name: "Цвет", value: "Черный/Белый", isAvailable: true, imageNames: [], imagesUrl: []),
            ProductVariant(id: "variant_5_2", name: "Цвет", value: "Красный/Белый", isAvailable: true, imageNames: [], imagesUrl: [])
        ],
        quantity: 1
    )
    
    static let allProducts = [
        adidasSneakers,
        quartzWatch,
        calvinKleinWatch,
        iPhone,
        nikeShoes
    ]
}

// ====================================================================
// КОНЕЦ ТЕСТОВЫХ ДАННЫХ
// ====================================================================


