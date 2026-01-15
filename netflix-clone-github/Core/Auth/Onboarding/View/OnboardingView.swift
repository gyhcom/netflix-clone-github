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
            VStack{
                PageView(currentPage: $index, pages: 3){
                    ForEach(onboardingData) { item in
                        OnboardingItemView(onboardingModel: item)
                    }
                }
            }
        }
        
    }
}

#Preview {
    OnboardingView()
}
