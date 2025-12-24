//
//  UserProfileViewModel.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation
import Combine

/**
 * ViewModel для управления профилем пользователя
 */
@MainActor
class UserProfileViewModel: ObservableObject {
    
    private let localDataStore = LocalDataStore.shared
    
    @Published var profileState: UserProfile?
    
    private var hasLoadedProfile = false
    
    init() {
        loadProfile()
    }
    
    /**
     * Загрузить профиль из локального хранилища
     */
    func loadProfile() {
        if hasLoadedProfile { return }
        
        Task {
            let profile = localDataStore.getUserProfileOrDefault()
            profileState = profile
            hasLoadedProfile = true
        }
    }
    
    /**
     * Принудительно перезагрузить профиль из локального хранилища
     */
    func refreshProfile() {
        Task {
            let profile = localDataStore.getUserProfileOrDefault()
            profileState = profile
            hasLoadedProfile = true
        }
    }
    
    /**
     * Обновить профиль
     */
    func updateProfile(_ profile: UserProfile) {
        Task {
            localDataStore.saveUserProfile(profile)
            profileState = profile
        }
    }
    
    /**
     * Обновить отдельное поле профиля
     */
    func updateProfileField(
        firstName: String? = nil,
        lastName: String? = nil,
        gender: String? = nil,
        birthDate: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        displayName: String? = nil,
        avatarName: String? = nil
    ) {
        let currentProfile = profileState ?? UserProfile.default()
        var updatedProfile = currentProfile
        
        if let firstName = firstName {
            updatedProfile.firstName = firstName
        }
        if let lastName = lastName {
            updatedProfile.lastName = lastName
        }
        if let gender = gender {
            updatedProfile.gender = gender
        }
        if let birthDate = birthDate {
            updatedProfile.birthDate = birthDate
        }
        if let phone = phone {
            updatedProfile.phone = phone
        }
        if let email = email {
            updatedProfile.email = email
        }
        if let displayName = displayName {
            updatedProfile.displayName = displayName
        }
        if let avatarName = avatarName {
            updatedProfile.avatarName = avatarName
        }
        
        updateProfile(updatedProfile)
    }
    
    /**
     * Получить текущий профиль или профиль по умолчанию
     */
    func getCurrentProfile() -> UserProfile {
        return profileState ?? UserProfile.default()
    }
}


