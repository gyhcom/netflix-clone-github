//
//  OnboardingItemView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/15/26.
//

import SwiftUI

struct OnboardingItemView: View {
    var onboardingModel: OnboardingItem
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack{
                Image(onboardingModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                VStack(spacing: 12){
                    Text(onboardingModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(onboardingModel.subText)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    VStack(){
                        Text("Create a Netflix account and more at")
                            .foregroundStyle(.white)
                        Button("netflix.com/more"){
                            
                        }
                        .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingItemView(
        onboardingModel: OnboardingItem(
            title: "Watch EveryWhere",
            subText: "Stream on yout phone, tablet, laptop, or Tv -it's all here",
            image: .onboarding1,
            tag: 0)
    )
}
