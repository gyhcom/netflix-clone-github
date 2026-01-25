//
//  AuthCoordinatorView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/25/26.
//

import SwiftUI
import SwiftUINavigation
struct AuthCoordinatorView: View {
    var body: some View {
        CoordinatorView(environmentKeyPath: \.authCoordinator){
            SignIn()
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        BackButton()
                    }
                    .sharedBackgroundVisibility(.hidden)
                    
                    ToolbarItem(placement: .principal){
                        NetFlixLogoView()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing){
                        InformationLinks(textColor: .white, isPrivacy: false)
                    }
                    .sharedBackgroundVisibility(.hidden)
                }
        } destinationBuilder: { destination in
            switch destination {
            case .signin:
                SignIn()
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            BackButton()
                        }
                        .sharedBackgroundVisibility(.hidden)
                        ToolbarItem(placement: .principal){
                            InformationLinks(textColor: .white, isPrivacy: false)
                        }
                        .sharedBackgroundVisibility(.hidden)
                    }
            case .signup:
                SignUp()
            case .verifyEmail:
                VerifyEmail()
            }
        }
    }
}

#Preview {
    AuthCoordinatorView()
}

struct BackButton: View{
    @Environment(\.authCoordinator) var coordinator
    var body: some View {
        Button {
            coordinator.navigateBack()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.white)
        }
    }
}
