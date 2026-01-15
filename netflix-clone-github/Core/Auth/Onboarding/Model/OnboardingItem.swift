//
//  Onboardingitem.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/15/26.
//

import Foundation
import SwiftUI

struct OnboardingItem: Identifiable {
    var id : UUID = UUID()
    var title: String
    var subText: String
    var image: ImageResource
    var tag: Int
    
    static var onboardingData: [OnboardingItem] = [
        .init(
            title: "Watch EveryWhere",
            subText: "Stream on your phone, tablet, laptop and TV.",
            image: .onboarding1,
            tag: 0),
        .init(
            title: "There's plan for every fan",
            subText: "Join today, no reason to wait",
            image: .onboarding2,
            tag: 1),
        .init(
            title: "Cancel online anytime",
            subText: "Join today, no reason to wait",
            image: .onboarding3,
            tag: 2)
    ]
}
