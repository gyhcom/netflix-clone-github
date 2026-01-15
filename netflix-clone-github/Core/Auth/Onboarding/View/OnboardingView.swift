//
//  OnboardingView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/14/26.
//

import SwiftUI

struct OnboardingView: View {
    @State var index : Int = 0
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                PageView(currentPage: $index, pages: 3){
                    VStack{
                        Text("Page 1")
                    }
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .tag(0)
                    VStack{
                        Text("Page 2")
                    }
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .tag(1)
                    VStack{
                        Text("Page 3")
                    }
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .tag(2)
                }
            }
            
        }
        
    }
}

#Preview {
    OnboardingView()
}
