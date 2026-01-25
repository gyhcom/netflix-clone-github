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
        } destinationBuilder: { destination in
            switch destination {
            case .signin:
                SignIn()
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
