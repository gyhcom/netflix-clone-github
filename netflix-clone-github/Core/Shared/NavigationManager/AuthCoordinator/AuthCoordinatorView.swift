//
//  AuthCoordinatorView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 02/01/26.
//

import SwiftUI
import SwiftUINavigation

struct AuthCoordinatorView: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Container@*/VStack/*@END_MENU_TOKEN@*/ {
            CoordinatorView(
                environmentKeyPath: \.authCoordinator) {
                    SignIn()
                        .navigationBarBackButtonHidden() // [정책] signin 화면에서는 백버튼을 표시하지 않음(기본/커스텀 모두 숨김)
                        .toolbar {
                            //                        ToolbarItem(placement: .topBarLeading) {
                            //                            BackButton()
                            //                        } // signin 화면은 백버튼 없음
                            //                        .sharedBackgroundVisibility(.hidden)
                            //
                            ToolbarItem(placement: .principal) {
                                NetflixLogoView()
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                InformationLinks(textColor: .white, isPrivacy: false)
                            }
                            .sharedBackgroundVisibility(.hidden)
                        }
                } destinationBuilder: { destination in
                    switch destination {
                    case .signin:
                        SignIn()
                            .navigationBarBackButtonHidden() // [정책] signin에서는 백버튼 미표시
                            .toolbar {
                                // [설명] signin 화면은 백버튼을 숨기고 로고/트레일링만 유지
                                ToolbarItem(placement: .principal) { // [설명] signin 화면은 기본 백 버튼을 숨기고 커스텀도 없음 → 백 버튼 없음, 로고만 중앙 배치
                                    NetflixLogoView()
                                }
                                
                                ToolbarItem(placement: .topBarTrailing) {
                                    InformationLinks(textColor: .white, isPrivacy: false)
                                }
                                .sharedBackgroundVisibility(.hidden)
                            }
                    case .signup:
                        SignUp() // [설명] 이 화면은 NavigationStack에서 푸시된 화면 → 기본(시스템) 백 버튼이 자동으로 표시됨(숨기지 않는 한)
                        // 커스텀 BackButton을 추가하지 않음: 중복 백 버튼 방지, 시스템 기본 백 버튼을 사용
                            .toolbar {
                                /*
                                 [전(before)] SignUp에서 .navigationBarBackButtonHidden()을 적용하거나, 커스텀 BackButton을 추가했지만 중복 구성/충돌로 인해 버튼이 사라지거나 두 개가 보이는 문제가 있었음.
                                 [후(after)] 기본 백 버튼을 숨기지 않고(.navigationBarBackButtonHidden() 미적용), 커스텀 BackButton을 제거하여 시스템 기본 백 버튼 한 개만 보이도록 정리.
                                 → 한 화면에서는 기본 또는 커스텀 중 하나만 사용하여 충돌 방지.
                                 */
                                ToolbarItem(placement: .principal) {
                                    NetflixLogoView()
                                }
                                
                                ToolbarItem(placement: .topBarTrailing) {
                                    InformationLinks(textColor: .white, isPrivacy: false)
                                }
                                .sharedBackgroundVisibility(.hidden)
                            }
                        
                    case .verifyEmail:
                        VerifyEmail()
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    NetflixLogoView()
                                }
                                
                                ToolbarItem(placement: .topBarTrailing) {
                                    InformationLinks(textColor: .white, isPrivacy: false)
                                }
                                .sharedBackgroundVisibility(.hidden)
                            }
                    }
                }
        }
    }
}

#Preview {
    AuthCoordinatorView()
}

struct BackButton: View {
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

