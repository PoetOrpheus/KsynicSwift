//
//  BottomNavItem.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation

/**
 * Элементы нижней навигации
 */
enum BottomNavItem: String, CaseIterable, Identifiable {
    case home = "Home"
    case shopCart = "ShopCart"
    case favorites = "Favorites"
    case profile = "Profile"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Главная"
        case .shopCart:
            return "Корзина"
        case .favorites:
            return "Избранное"
        case .profile:
            return "Профиль"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "home_menu_icon"
        case .shopCart:
            return "shop_menu_icon"
        case .favorites:
            return "lover_menu_icon"
        case .profile:
            return "profile_menu_icon"
        }
    }
}


