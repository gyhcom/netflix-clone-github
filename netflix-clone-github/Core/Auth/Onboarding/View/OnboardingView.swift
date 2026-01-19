//
//  OnboardingView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/14/26.
//

import SwiftUI

struct OnboardingView: View {
    @State var index : Int = 0
    let onboardingData = OnboardingItem.onboardingData
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack(spacing: 16){
                PageView(currentPage: $index, pages: 3){
                    ForEach(onboardingData) { item in
                        OnboardingItemView(onboardingModel: item)
                            .tag(item.tag)
                    }
                }
                
                ButtonNetflix(text: "Sign In"){
                    print("Singing in screen")
                }
                    
            }
        }
        
    }
}

#Preview {
    OnboardingView()
}
