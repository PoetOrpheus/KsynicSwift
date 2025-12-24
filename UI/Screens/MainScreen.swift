//
//  MainScreen.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: BottomNavItem = .home
    @StateObject private var productViewModel = ProductViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(BottomNavItem.home)
            
            ShopCartScreen()
                .tabItem {
                    Label("Корзина", systemImage: "cart.fill")
                }
                .tag(BottomNavItem.shopCart)
            
            FavoriteScreen()
                .tabItem {
                    Label("Избранное", systemImage: "heart.fill")
                }
                .tag(BottomNavItem.favorites)
            
            ProfileScreen()
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(BottomNavItem.profile)
        }
        .accentColor(.brandPurple)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}


