//
//  VerifyEmail.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/25/26.
//

import SwiftUI

struct VerifyEmail: View {
//    var email: String
    
    
    @Environment(\.authCoordinator) var router
    @Environment(\.toast) var toast
    
    @State var isInvalid: Bool = false
    @State var code: String = ""
    
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
            
            VStack {
//                Text("OTP for email \(email)")
//                    .font(.headline)
//                    .foregroundStyle(.white)
                
                VStack {
                    VerificationField(
                        type: .six,
                        isInValid: $isInvalid,
                        isLoading: false,
                        onChange: { value in
                            print("change:", value)
                        },
                        onComplete: { value async in
                            print("final value:", value)
                            await MainActor.run{
                                code = value
                            }
                        },
                        configuration: .init(
                            colors: .init(
                                typing: .white,
                                active: .white,
                                valid: .green,
                                invalid: .red,
                                text: .white,
                                loadingText: .white.opacity(0.5)
                            ),
                            sizes: .init(spacing: 10)
                        )
                    )
                }
                .padding()
            }
        }
    }
}

#Preview {
    VerifyEmail()
}
