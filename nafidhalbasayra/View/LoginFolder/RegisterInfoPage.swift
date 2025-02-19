//
//  LoginPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/09/2024.
//


import SwiftUI

struct RegisterInfoPage: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
    @EnvironmentObject var coreDataViewModel : CoreDataViewModel
    
    // الحالة الإضافية
    @State private var isButtonDisabled = true
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showError: Bool = true
    @State var textFieldText1: String = ""
    @State var textFieldText2: String = ""
    @State private var isPressed = false
    @FocusState private var isTextFieldFocused1: Bool
    @FocusState private var isTextFieldFocused2: Bool
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        // ScrollView يسمح بالتمرير عند ظهور الكيبورد
        ScrollView {
            VStack(spacing: 4) {
                
                Spacer()
                    .frame(height: screenHeight * 0.08)
                
                Image("Group 3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth * 0.2, height: screenHeight * 0.15)
                
                Text("تسجيل الدخول")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.07))
                    .foregroundColor(Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                    .bold()
                
                // المنطق الخاص بالدخول
                LoginStatusView(viewModel: viewModel)
                
                Spacer()
                    .frame(height: screenHeight * 0.01)
                
                // Username Field
                LazyVStack(spacing: 6) {
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
                        .onChange(of: viewModel.username) { newValue in
                            let trimmedValue = newValue.replacingOccurrences(of: " ", with: "").lowercased()
                            
                            // امنع إعادة التعيين لو لم يتغير الحقل فعليًا:
                            guard trimmedValue != newValue else { return }
                            
                            // حدّث الحقول مرة واحدة فقط
                            viewModel.username   = trimmedValue
                            teacherData.userName = trimmedValue
                            
                            // تحقق من طول اسم المستخدم وكلمة المرور
                            isButtonDisabled = trimmedValue.count < 5 || viewModel.password.count < 6
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(
                                    isTextFieldFocused1
                                    ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255)
                                    : .clear,
                                    lineWidth: screenWidth * 0.004
                                )
                        )
                        .frame(maxWidth: screenWidth * 0.8)
                }
                .padding(.vertical, screenHeight * 0.02)
                
                // Password Field with Eye Icon
                LazyVStack(spacing: 6) {
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
                        .overlay {
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
                                .stroke(
                                    isTextFieldFocused2
                                    ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255)
                                    : .clear,
                                    lineWidth: screenWidth * 0.004
                                )
                        )
                        .frame(maxWidth: screenWidth * 0.8)
                        .onChange(of: viewModel.password) { newValue in
                            // تحقق من طول كلمة المرور
                            isButtonDisabled = viewModel.username.count < 5 || newValue.count < 6
                        }
                    }
                }
                
                Spacer()
                    .frame(height: screenHeight * 0.015)
                
                // Login Button
                Button(action: {
                    hideKeyboardExplicitly()
                    viewModel.login()
                    viewModel.isLoading = true
                }) {
                    Text("تسجيل الدخول")
                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                        .frame(height: screenHeight * 0.05)
                        .foregroundColor(.white)
                        .frame(maxWidth: screenWidth * 0.8)
                }
                .background(isPressed
                            ? Color.black
                            : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .cornerRadius(5)
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
                .navigationDestination(isPresented: $viewModel.navigateToNextPage) {
                    switch viewModel.nextPage {
                    case .registerInfo:
                        LoginPageWelcom()
                            .environmentObject(teacherData)
                           // .environmentObject(vmAttendaceStatus)
                    case .waitProcess:
                        registerPageWaitProcess()
                            .environmentObject(teacherData)
                            //.environmentObject(vmAttendaceStatus)
                    case .homePage:
                        registerPageAccept()
                            .environmentObject(teacherData)
                            .environmentObject(vmAttendaceStatus)
                    case .rejectionIssue:
                        registerPageDecline()
                            .environmentObject(teacherData)
                            //.environmentObject(vmAttendaceStatus)
                    case .none:
                        EmptyView()
                    }
                }
                
                Spacer()
                    .frame(height: screenHeight * 0.2)
                
            } // End of VStack
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity)
        } // End of ScrollView
        .scrollDismissesKeyboard(.interactively)  // iOS 16+ لإخفاء الكيبورد عند السحب
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .navigationBarBackButtonHidden(true)
        .background(Color.clear)
        .hideKeyboard()
    }
}

struct LoginPage1_Previews: PreviewProvider {
    static var previews: some View {
        RegisterInfoPage()
            .environmentObject(TeacherDataViewModel())
            .environmentObject(AttendaceStatusViewModel.shared)
            .environmentObject(CoreDataViewModel())
    }
}

// MARK: - دالة إخفاء الكيبورد
extension View {
    func hideKeyboardExplicitly() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}












//
//struct LoginPage1_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterInfoPage()
//            .environmentObject(TeacherDataViewModel())
//    }
//}








//import SwiftUI
//
//struct RegisterInfoPage: View {
//    
//    @StateObject private var viewModel = LoginViewModel()
//    @EnvironmentObject var teacherData: TeacherDataViewModel
//    
//    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
//    @EnvironmentObject var coreDataViewModel : CoreDataViewModel
//
//    
//    //@State private var isGo: Bool = false
//    
//    @State private var isButtonDisabled = true
//
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    @State var showError: Bool = true
//    @State var textFieldText1: String = ""
//    @State var textFieldText2: String = ""
//    @State private var isPressed = false
//    @FocusState private var isTextFieldFocused1: Bool
//    @FocusState private var isTextFieldFocused2: Bool
//    @State private var isPasswordVisible: Bool = false
//
//
//    
//
//    var body: some View {
//        VStack(spacing: 4) {
//           Spacer()
//           // Color.clear
//                .frame(height: screenHeight * 0.08)
//            
////            .padding(.vertical, screenHeight * 0.02)
//
//
//            Image("Group 3")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: screenWidth * 0.2, height: screenHeight * 0.15)
//
////            Spacer()
////                .frame(height: screenHeight * 0.02)
//                //.padding(.vertical, screenHeight * 0.015)
//
//
//            Text("تسجيل الدخول")
//                .lineLimit(1)
//                .minimumScaleFactor(0.5)
//                .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.07))
//                .foregroundColor(Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                .bold()
//              
//            
//            
//            
//              // logic section and check
//            LoginStatusView(viewModel: viewModel)
//
//
//
//            Spacer()
//                .frame(height: screenHeight * 0.01)
//            
//            
//
//            // Username Field
//            LazyVStack(spacing: 6) {
//                Text("اسم المستخدم")
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                    .padding(.trailing, screenWidth * 0.05)
//
//                TextField("user1", text: $viewModel.username)
//                    .frame(height: screenHeight * 0.05)
//                    .multilineTextAlignment(.trailing)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .cornerRadius(5)
//                    .focused($isTextFieldFocused1)
//                    .onChange(of: viewModel.username) { newValue in
//                        let trimmedValue = newValue.replacingOccurrences(of: " ", with: "").lowercased()
//                        
//                        // امنع إعادة التعيين لو لم يتغير الحقل فعليًا:
//                        guard trimmedValue != newValue else { return }
//                        
//                        // حدّث الحقول مرة واحدة فقط
//                        viewModel.username   = trimmedValue
//                        teacherData.userName = trimmedValue
//                        
//                        // تحقق من طول اسم المستخدم وكلمة المرور
//                        isButtonDisabled = trimmedValue.count < 5 || viewModel.password.count < 6
//                    }
//
////                    .onChange(of: viewModel.username) { newValue in
////                        
////                        
////                        // إزالة جميع الفراغات
////                               let trimmedValue = newValue.replacingOccurrences(of: " ", with: "")
////                               
////                               // تحويل الأحرف إلى صغيرة
////                               viewModel.username = trimmedValue.lowercased()
////                               teacherData.userName = trimmedValue.lowercased()
////                               
////                               // تحقق من طول اسم المستخدم وكلمة المرور
////                               isButtonDisabled = viewModel.username.count < 5 || viewModel.password.count < 6
////                        
////                        
////                                       }
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(isTextFieldFocused1 ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255) : .clear, lineWidth: screenWidth * 0.004)
//                    )
//                    .frame(maxWidth: screenWidth * 0.8)
//            }
//
////            Spacer()
////                .frame(height: screenHeight * 0.02)
//            
//            .padding(.vertical, screenHeight * 0.02)
//            // Password Field with Eye Icon
//            
//            LazyVStack(spacing: 6) {
//                Text("كلمة المرور")
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                    .padding(.trailing, screenWidth * 0.05)
//
//                ZStack {
//                    HStack {
//                        // Password Field
//                        if isPasswordVisible {
//                            TextField("1234", text: $viewModel.password)
//                                .keyboardType(.numberPad)
//                                .multilineTextAlignment(.trailing)
//                                .focused($isTextFieldFocused2)
//                        } else {
//                            SecureField("1234", text: $viewModel.password)
//                                .keyboardType(.numberPad)
//                                .multilineTextAlignment(.trailing)
//                                .focused($isTextFieldFocused2)
//                        }
//                            
//
//                        
//                    }
//                    .overlay{
//                        // Eye Button
//                        Button(action: {
//                            isPasswordVisible.toggle()
//                        }) {
//                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.trailing, screenWidth * 0.6) // Adjust padding for left alignment
//                    }
//                    .frame(height: screenHeight * 0.05)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .cornerRadius(5)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(isTextFieldFocused2 ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255) : .clear, lineWidth: screenWidth * 0.004)
//                    )
//                    .frame(maxWidth: screenWidth * 0.8)
//                    .onChange(of: viewModel.password) { newValue in
//                                            // تحقق من طول كلمة المرور
//                                            isButtonDisabled = viewModel.username.count < 5 || newValue.count < 6
//                                        }
//                }
//            }
//
//            Spacer()
//                .frame(height: screenHeight * 0.015)
//
//            // Login Button //
//            
//            
//            Button(action: {
////
//                hideKeyboardExplicitly()
//                viewModel.login()
//                viewModel.isLoading = true
//               
//                
//
//            }) {
//                Text("تسجيل الدخول")
//                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                    .frame(height: screenHeight * 0.05)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: screenWidth * 0.8)
//            }
//            
//
//            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//            
//            .cornerRadius(5)
//            .disabled( isButtonDisabled )
//            .opacity(isButtonDisabled ? 0.5 : 1.0)
//            
//
////            .navigationDestination(isPresented: $viewModel.navigateToNextPage) {
////                LoginPageWelcom().environmentObject(teacherData) // Assuming this is your destination view
////            }
//            
//            
//            // Dynamic Navigation
//                       .navigationDestination(isPresented: $viewModel.navigateToNextPage) {
//                           switch viewModel.nextPage {
//                           case .registerInfo:
//                               LoginPageWelcom()
//                                   .environmentObject(teacherData)
//                                   .environmentObject(vmAttendaceStatus)
//                           case .waitProcess:
//                               registerPageWaitProcess()
//                                   .environmentObject(teacherData)
//                                   .environmentObject(vmAttendaceStatus)
//                           case .homePage:
//                               registerPageAccept()
//                                   .environmentObject(teacherData)
//                                   .environmentObject(vmAttendaceStatus)
//                           case .rejectionIssue:
//                               registerPageDecline()
//                                   .environmentObject(teacherData)
//                                   .environmentObject(vmAttendaceStatus)
//                           case .none:
//                               EmptyView()
//                           }
//                       }
//
//            
//            
//
//            Spacer()
//                .frame(height: screenHeight * 0.2)
//            
//            
//           
//            
//            
//        }
//
//        
//
//        .padding(.horizontal, 40)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//       // .ignoresSafeArea(.keyboard, edges: .bottom)
//        .navigationBarBackButtonHidden(true)
//        .background(
//                    Color.clear // Ensure it works on all devices
//                )
//                .hideKeyboard()
//    }
//    
//    
//
//
//}

