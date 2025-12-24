//
//  ContentView.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                SplashScreen(onLoadingComplete: {
                    isLoading = false
                })
            } else {
                MainScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


