//
//  VerifyEmail.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/25/26.
//

import SwiftUI

struct VerifyEmail: View {
    var body: some View{
        ZStack{
            LinearGradient(
                colors: [
                    Color(
                        red: 0.0,
                        green: 0.0,
                        blue: 0.0
                    ),
                    Color(
                        red: 0.2431372549,
                        green: 0.0,
                        blue: 0.0
                    ),
                    Color(
                        red: 0.2431372549,
                        green: 0.0,
                        blue: 0.0
                    ),
                    Color(
                        red: 0.0,
                        green: 0.0,
                        blue: 0.0
                    ),
                ],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
        }
    }
}

#Preview {
    VerifyEmail()
}
