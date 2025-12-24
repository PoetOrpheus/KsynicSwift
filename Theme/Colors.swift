//
//  Colors.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

extension Color {
    // Основные цвета из макета
    static let purpleGradientStart = Color(hex: "#6A85B6") ?? Color.blue
    static let purpleGradientEnd = Color(hex: "#BAC8E0") ?? Color.blue.opacity(0.5)
    static let brandPurple = Color(hex: "#7B61FF") ?? Color.purple
    static let discountRed = Color(hex: "#E94242") ?? Color.red
    static let backgroundLight = Color(hex: "#F5F5F5") ?? Color.gray.opacity(0.1)
    
    // Material3 цвета (для совместимости)
    static let purple80 = Color(hex: "#D0BCFF") ?? Color.purple.opacity(0.8)
    static let purpleGrey80 = Color(hex: "#CCC2DC") ?? Color.gray.opacity(0.8)
    static let pink80 = Color(hex: "#EFB8C8") ?? Color.pink.opacity(0.8)
    
    static let purple40 = Color(hex: "#6650a4") ?? Color.purple.opacity(0.4)
    static let purpleGrey40 = Color(hex: "#625b71") ?? Color.gray.opacity(0.4)
    static let pink40 = Color(hex: "#7D5260") ?? Color.pink.opacity(0.4)
}


