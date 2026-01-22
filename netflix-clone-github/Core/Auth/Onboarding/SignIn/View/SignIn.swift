//
//  SwiftUIView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/22/26.
//

import SwiftUI

struct SignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                TextField(
                  "",
                  text: $email,
                  prompt: Text("Email or phone number")
                    .foregroundStyle(.white)
                )
                .keyboardType(.emailAddress)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(.appDarkGray)
                .foregroundStyle(.white)
                .cornerRadius(4)
            }
        }
    }
}

#Preview {
    SignIn()
}
