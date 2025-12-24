//
//  ProfileScreen.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct ProfileScreen: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var isLoggedIn = LocalDataStore.shared.isLoggedIn()
    
    var body: some View {
        NavigationView {
            Group {
                if isLoggedIn {
                    if let profile = viewModel.profileState {
                        ProfileContentView(profile: profile)
                    } else {
                        ProgressView()
                    }
                } else {
                    LoginRequiredView()
                }
            }
            .navigationTitle("Профиль")
            .onAppear {
                viewModel.refreshProfile()
            }
        }
    }
}

struct ProfileContentView: View {
    let profile: UserProfile
    @StateObject private var viewModel = UserProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Аватар и имя
                VStack(spacing: 12) {
                    if let avatarName = profile.avatarName {
                        Image(avatarName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(profile.getShortName())
                                    .font(.title)
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    Text(profile.getFullName())
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(profile.displayName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Информация
                VStack(alignment: .leading, spacing: 12) {
                    ProfileInfoRow(title: "Телефон", value: profile.phone)
                    ProfileInfoRow(title: "Email", value: profile.email)
                    ProfileInfoRow(title: "Пол", value: profile.gender)
                    ProfileInfoRow(title: "Дата рождения", value: profile.birthDate)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Кнопки действий
                VStack(spacing: 12) {
                    Button(action: {
                        // TODO: Редактировать профиль
                    }) {
                        Text("Редактировать профиль")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandPurple)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // TODO: Выйти
                        LocalDataStore.shared.logout()
                        isLoggedIn = false
                    }) {
                        Text("Выйти")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct LoginRequiredView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Войдите в аккаунт")
                .font(.title2)
                .foregroundColor(.gray)
            
            Button(action: {
                // TODO: Показать экран входа
            }) {
                Text("Войти")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.brandPurple)
                    .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}

