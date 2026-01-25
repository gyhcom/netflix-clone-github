//
//  AuthDestinations.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/25/26.
//

import SwiftUI
import SwiftUINavigation

enum AuthDestinations: Hashable {
    case signin
    case signup
    case verifyEmail
}

typealias AuthCoordinator = NavigationCoordinator<AuthDestinations>

extension EnvironmentValues {
    @Entry var authCoordinator = AuthCoordinator()
}
