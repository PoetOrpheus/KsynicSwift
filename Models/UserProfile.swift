//
//  UserProfile.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation

/**
 * Модель профиля пользователя
 */
struct UserProfile: Codable, Equatable {
    var firstName: String
    var lastName: String
    var gender: String // "Мужской", "Женский", и т.д.
    var birthDate: String // Формат: "DD.MM.YYYY"
    var phone: String
    var email: String
    var displayName: String // Видимое имя на площадке
    var avatarName: String? // Имя изображения аватара из Assets
    
    /**
     * Получить полное имя (имя + фамилия)
     */
    func getFullName() -> String {
        if !firstName.isEmpty && !lastName.isEmpty {
            return "\(firstName) \(lastName)"
        } else if !firstName.isEmpty {
            return firstName
        } else if !lastName.isEmpty {
            return lastName
        } else {
            return ""
        }
    }
    
    /**
     * Получить короткое имя для отображения (например, "Денис Д.")
     */
    func getShortName() -> String {
        if !displayName.isEmpty {
            return displayName
        } else {
            let firstInitial = firstName.prefix(1).uppercased()
            let lastInitial = lastName.prefix(1).uppercased()
            if !firstInitial.isEmpty && !lastInitial.isEmpty {
                return "\(firstName.prefix(1).uppercased())\(lastName.prefix(1).uppercased())."
            } else if !firstName.isEmpty {
                return "\(firstName) \(lastName.prefix(1).uppercased())."
            } else {
                return getFullName()
            }
        }
    }
    
    /**
     * Создать профиль по умолчанию для тестов
     */
    static func `default`() -> UserProfile {
        return UserProfile(
            firstName: "Денис",
            lastName: "Девятгин",
            gender: "Мужской",
            birthDate: "19.09.2001",
            phone: "+7 777 777 77 77",
            email: "asdasdf@mail.ru",
            displayName: "Денис Д.",
            avatarName: "ava_denis"
        )
    }
}


