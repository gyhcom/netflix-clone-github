//
//  ContentView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/10/26.
//

import SwiftUI

struct ContentView: View {
    @State var showSplash: Bool = true
    var body: some View {
        Group{
            if showSplash {
                NetflixSplashView(showSplash: $showSplash)
                    .transition(.opacity.combined(with: .move(edge: .leading)))
            }else{
                OnboardingView()
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .animation(.easeIn(duration: 0.5),  value: showSplash)
        
    }
}

#Preview {
    ContentView()
}

