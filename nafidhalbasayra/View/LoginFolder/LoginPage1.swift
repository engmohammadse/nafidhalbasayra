//
//  LoginPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/09/2024.
//

import SwiftUI

struct LoginPage1: View {
    
    @StateObject private var viewModel = LoginViewModel()

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showError: Bool = true
    @State var textFieldText1: String = ""
    @State var textFieldText2: String = ""
    @State private var isPressed = false
    @FocusState private var isTextFieldFocused1: Bool
    @FocusState private var isTextFieldFocused2: Bool
    @State private var isPasswordVisible: Bool = false
    @State private var isNavigate: Bool = false

    // Define screen dimensions
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack(spacing: 2) {
            Spacer()
                .frame(height: screenHeight * 0.02)

            Image("Group 3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth * 0.2, height: screenHeight * 0.15)

            Spacer()
                .frame(height: screenHeight * 0.02)

            Text("تسجيل الدخول")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.07))
                .foregroundColor(Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .bold()
              
            
            
            
            
//            if viewModel.isLoggedIn {
//                            Text("Logged in successfully!")
//                                .foregroundColor(.green)
//                        } else  if let loginError = viewModel.loginError {
//                            Text("هنالك مشكلة في تسجيل الدخول")
//                                .frame(maxWidth: screenWidth * 0.8, maxHeight: screenHeight * 0.05)
//                                .padding(.horizontal)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.5)
//                                .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
//                                .foregroundColor(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255))
//                                .bold()
//                                .background(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255).opacity(0.1))
//                                .cornerRadius(5)
//                         }
            
            
            if viewModel.isLoggedIn {
                Text(viewModel.responseMessage.isEmpty ? "Logged in successfully!" : viewModel.responseMessage)
                    .foregroundColor(.green)
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
                    .frame(maxWidth: screenWidth * 0.8, maxHeight: screenHeight * 0.05)
                    .transition(.opacity) // Transition for fade effect
                    .animation(.easeIn(duration: 0.5), value: viewModel.isLoggedIn) // Updated animation
            } else if let loginError = viewModel.loginError {
                Text(loginError)  // Display the login error message directly
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
                    .transition(.opacity) // Transition for fade effect
                    .animation(.easeIn(duration: 0.5), value: viewModel.loginError) // Updated animation
            }


            
            
           

//            if showError {
//                Text("هنالك مشكلة في تسجيل الدخول")
//                    .frame(maxWidth: screenWidth * 0.8, maxHeight: screenHeight * 0.05)
//                    .padding(.horizontal)
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.5)
//                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
//                    .foregroundColor(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255))
//                    .bold()
//                    .background(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255).opacity(0.1))
//                    .cornerRadius(5)
//            }

            Spacer()
                .frame(height: screenHeight * 0.04)

            // Username Field
            VStack(spacing: 6) {
                Text("اسم المستخدم")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                    .padding(.trailing, screenWidth * 0.05)

                TextField("user1", text: $viewModel.username)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .focused($isTextFieldFocused1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(isTextFieldFocused1 ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255) : .clear, lineWidth: screenWidth * 0.004)
                    )
                    .frame(maxWidth: screenWidth * 0.8)
            }

            Spacer()
                .frame(height: screenHeight * 0.02) 
            // Password Field with Eye Icon
            
            VStack(spacing: 6) {
                Text("كلمة المرور")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                    .padding(.trailing, screenWidth * 0.05)

                ZStack {
                    HStack {
                        // Password Field
                        if isPasswordVisible {
                            TextField("1234", text: $viewModel.password)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isTextFieldFocused2)
                        } else {
                            SecureField("1234", text: $viewModel.password)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isTextFieldFocused2)
                        }
                            

                        
                    }
                    .overlay{
                        // Eye Button
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, screenWidth * 0.6) // Adjust padding for left alignment
                    }
                    .frame(height: screenHeight * 0.05)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(isTextFieldFocused2 ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255) : .clear, lineWidth: screenWidth * 0.004)
                    )
                    .frame(maxWidth: screenWidth * 0.8)
                }
            }

            Spacer()
                .frame(height: screenHeight * 0.015)

            // Login Button
            Button(action: {
                isPressed.toggle()
                withAnimation(.easeInOut(duration: 0.5)) {
                    showError.toggle()
                }
                
                viewModel.login()
                
                // Navigate to the next screen upon successful login
                //isNavigate = true
            }) {
                Text("تسجيل الدخول")
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                    .frame(height: screenHeight * 0.05)
                    .foregroundColor(.white)
                    .frame(maxWidth: screenWidth * 0.8)
            }
            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
            .cornerRadius(5)
            .navigationDestination(isPresented: $isNavigate) {
                LoginPageWelcom() // Assuming this is your destination view
            }

            Spacer()
                .frame(maxHeight: screenHeight * 0.3)
            
            
           
            
            
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct LoginPage1_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage1()
    }
}
