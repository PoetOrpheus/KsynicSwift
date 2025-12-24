//
//  SplashScreen.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct SplashScreen: View {
    let onLoadingComplete: () -> Void
    
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.brandPurple
                .ignoresSafeArea()
            
            VStack {
                // Здесь можно добавить логотип приложения
                Text("Ksynic")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // Анимация появления
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
            
            // Имитация загрузки данных
            Task {
                // Здесь можно загрузить начальные данные
                try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 секунды
                
                onLoadingComplete()
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(onLoadingComplete: {})
    }
}


