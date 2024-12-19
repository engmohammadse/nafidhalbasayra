//
//  LoginStatusView.swift
//  nafidhalbasayra
//
//  Created by muhammad on 19/12/2024.
//

import SwiftUI

struct LoginStatusView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("جاري تسجيل الدخول...") // مؤشر التحميل
                    .padding()
            } else {
                LazyVStack {
                    if !viewModel.isConnectedToInternet {
                        Text("الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال.")
                            .frame(maxWidth: screenWidth * 0.8, maxHeight: screenHeight * 0.05)
                            .padding(.horizontal)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
                            .foregroundColor(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255))
                            .bold()
                            .background(
                                Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255).opacity(0.1)
                                    .cornerRadius(5)
                            )
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5), value: viewModel.isConnectedToInternet)

                    } else if viewModel.isLoggedIn {
                        Text(viewModel.responseMessage.isEmpty ? "Logged in successfully!" : "تم بنجاح تسجيل الدخول")
                            .foregroundColor(.green)
                            .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
                            .frame(maxWidth: screenWidth * 0.8, maxHeight: screenHeight * 0.05)
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5), value: viewModel.isLoggedIn)

                    } else if let loginError = viewModel.loginError {
                        Text(loginError)
                            .frame(maxWidth: screenWidth * 0.8, maxHeight: screenHeight * 0.05)
                            .padding(.horizontal)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
                            .foregroundColor(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255))
                            .bold()
                            .background(
                                Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255).opacity(0.1)
                                    .cornerRadius(5)
                            )
                            .transition(.opacity.combined(with: .scale))
                            .animation(.easeIn(duration: 0.5), value: viewModel.loginError)
                    }
                }
            }
        }
    }
}
