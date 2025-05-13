//
//  LoginPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/09/2024.
//








// new
//import SwiftUI
//
//struct RegisterInfoPage: View {
//    
//    @StateObject private var viewModel = LoginViewModel()
//    @EnvironmentObject var teacherData: TeacherDataViewModel
//    
//    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
//    
//    // Additional state
//    @State private var isButtonDisabled = true
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    @State var showError: Bool = true
//    @State var textFieldText1: String = ""
//    @State var textFieldText2: String = ""
//    @State private var isPressed = false
//    @FocusState private var isTextFieldFocused1: Bool
//    @FocusState private var isTextFieldFocused2: Bool
//    @State private var isPasswordVisible: Bool = false
//    
//    // New navigation state variable
//    @State private var selectedDestination: String? = nil
//
//    var body: some View {
//        // ScrollView allows scrolling when keyboard appears
//        ScrollView {
//            VStack(spacing: 4) {
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.08)
//                
//                Image("Group 3")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: screenWidth * 0.2, height: screenHeight * 0.15)
//                
//                Text("تسجيل الدخول")
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.5)
//                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.07))
//                    .foregroundColor(Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                    .bold()
//                
//                // Login status logic
//                LoginStatusView(viewModel: viewModel)
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.01)
//                
//                // Username Field
//                LazyVStack(spacing: 6) {
//                    Text("اسم المستخدم")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                        .padding(.trailing, screenWidth * 0.05)
//                    
//                    TextField("user1", text: $viewModel.username)
//                        .frame(height: screenHeight * 0.05)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .focused($isTextFieldFocused1)
//                        .onChange(of: viewModel.username) { newValue in
//                            let trimmedValue = newValue.replacingOccurrences(of: " ", with: "").lowercased()
//                            
//                            viewModel.username = trimmedValue
//                            teacherData.userName = trimmedValue
//                            
//                            // Check username and password length
//                            checkLoginButtonState()
//                        }
//                        .disabled(viewModel.isLoading)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(
//                                    isTextFieldFocused1
//                                    ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255)
//                                    : .clear,
//                                    lineWidth: screenWidth * 0.004
//                                )
//                        )
//                        .frame(maxWidth: screenWidth * 0.8)
//                }
//                .padding(.vertical, screenHeight * 0.02)
//                
//                // Password Field with Eye Icon
//                LazyVStack(spacing: 6) {
//                    Text("كلمة المرور")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                        .padding(.trailing, screenWidth * 0.05)
//                    
//                    ZStack {
//                        HStack {
//                            // Password Field
//                            if isPasswordVisible {
//                                TextField("1234", text: $viewModel.password)
//                                .keyboardType(.asciiCapableNumberPad) // English numbers only
//                                .textContentType(.oneTimeCode) // Hide language change button
//                                .disableAutocorrection(true)
//                                .autocapitalization(.none)
//                                .multilineTextAlignment(.trailing)
//                                .focused($isTextFieldFocused2)
//                                .onChange(of: viewModel.password) { newValue in
//                                        viewModel.password = newValue.filter { "0123456789".contains($0) }
//                                        checkLoginButtonState()
//                                }
//                                .disabled(viewModel.isLoading)
//                                  
//                            } else {
//                                SecureField("1234", text: $viewModel.password)
//                                    .keyboardType(.asciiCapableNumberPad)
//                                    .textContentType(.oneTimeCode)
//                                    .disableAutocorrection(true)
//                                    .autocapitalization(.none)
//                                    .multilineTextAlignment(.trailing)
//                                    .focused($isTextFieldFocused2)
//                                    .onChange(of: viewModel.password) { newValue in
//                                        viewModel.password = newValue.filter { "0123456789".contains($0) }
//                                        checkLoginButtonState()
//                                    }
//                                    .disabled(viewModel.isLoading)
//                            }
//                        }
//        
//                        .overlay {
//                            // Eye Button
//                            Button(action: {
//                                isPasswordVisible.toggle()
//                            }) {
//                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.trailing, screenWidth * 0.6) // Adjust padding for left alignment
//                        }
//                        .frame(height: screenHeight * 0.05)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(
//                                    isTextFieldFocused2
//                                    ? Color(red: 113 / 255, green: 138 / 255, blue: 161 / 255)
//                                    : .clear,
//                                    lineWidth: screenWidth * 0.004
//                                )
//                        )
//                        .frame(maxWidth: screenWidth * 0.8)
//                    }
//                }
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.015)
//                
//                // Login Button - MODIFIED FOR COMPATIBILITY
//                Button(action: {
//                    hideKeyboardExplicitly()
//                    // Call the new method instead of the original login()
//                    loginWithoutNavigation()
//                }) {
//                    Text("تسجيل الدخول")
//                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                        .frame(height: screenHeight * 0.05)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: screenWidth * 0.8)
//                }
//                .background(isPressed
//                            ? Color.black
//                            : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                .cornerRadius(5)
//                .disabled(viewModel.isLoading)
//                .opacity(viewModel.isLoading ? 0.5 : 1.0)
//                
//                // NAVIGATION LINKS FOR iOS 16.6 COMPATIBILITY
//                NavigationLink(destination:
//                    LoginPageWelcom()
//                        .environmentObject(teacherData)
//                        .preferredColorScheme(.light),
//                    tag: "registerInfo",
//                    selection: $selectedDestination) {
//                    EmptyView()
//                }
//                
//                NavigationLink(destination:
//                    registerPageWaitProcess()
//                        .environmentObject(teacherData)
//                        .preferredColorScheme(.light),
//                    tag: "waitProcess",
//                    selection: $selectedDestination) {
//                    EmptyView()
//                }
//                
//                NavigationLink(destination:
//                    MainViewPage()
//                        .environmentObject(teacherData)
//                        .preferredColorScheme(.light),
//                    tag: "homePage",
//                    selection: $selectedDestination) {
//                    EmptyView()
//                }
//                
//                NavigationLink(destination:
//                    registerPageDecline()
//                        .environmentObject(teacherData)
//                        .preferredColorScheme(.light),
//                    tag: "rejectionIssue",
//                    selection: $selectedDestination) {
//                    EmptyView()
//                }
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.2)
//                
//            } // End of VStack
//            .padding(.horizontal, 40)
//            .frame(maxWidth: .infinity)
//        } // End of ScrollView
//        .scrollDismissesKeyboard(.interactively)  // iOS 16+ to hide keyboard on scroll
//        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//        .navigationBarBackButtonHidden(true)
//        .background(Color.clear)
//        .hideKeyboard()
//        .onDisappear {
//            UserDefaults.standard.removeObject(forKey: "imageDownloadError")
//        }
//    }
//    
//    // New method for handling login without using navigationDestination
//    private func loginWithoutNavigation() {
//        viewModel.isLoading = true
//        
//        // Simulate login delay (adjust based on your actual login process)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.viewModel.isLoading = false
//            
//            // This is where your login logic would go
//            // For example, check credentials, API calls, etc.
//            
//            // Then determine the destination based on login result:
//            
//            // For testing purposes, assuming successful login to LoginPageWelcom
////            self.viewModel.nextPage = .registerInfo
//            
//            // Set the selected destination based on nextPage
//            switch self.viewModel.nextPage {
//            case .registerInfo:
//                self.selectedDestination = "registerInfo"
//            case .waitProcess:
//                self.selectedDestination = "waitProcess"
//            case .homePage:
//                self.selectedDestination = "homePage"
//            case .rejectionIssue:
//                self.selectedDestination = "rejectionIssue"
//            case .none:
//                self.selectedDestination = nil
//            }
//        }
//    }
//    
//    // Update login button state when inputs change
//    private func checkLoginButtonState() {
//        DispatchQueue.main.async {
//            isButtonDisabled = viewModel.username.count < 5 || viewModel.password.count < 6
//        }
//    }
//}
//
//// MARK: - Keyboard hiding function
//extension View {
//    func hideKeyboardExplicitly() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
//                                        to: nil, from: nil, for: nil)
//    }
//}



 
//old
import SwiftUI

struct RegisterInfoPage: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
    //@EnvironmentObject var coreDataViewModel : CoreDataViewModel
    
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
                           // guard trimmedValue != newValue else { return }
                            
                            // حدّث الحقول مرة واحدة فقط
                            viewModel.username   = trimmedValue
                            teacherData.userName = trimmedValue
                            
                            // تحقق من طول اسم المستخدم وكلمة المرور
                            checkLoginButtonState() //  تحديث الزر عند إدخال اسم المستخدم

                        }
                        .disabled(viewModel.isLoading)
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
                                .keyboardType(.asciiCapableNumberPad) //  أرقام إنجليزية فقط
                                .textContentType(.oneTimeCode) //  يخفي زر تغيير اللغة في بعض لوحات المفاتيح
                                .disableAutocorrection(true) //  منع التصحيح التلقائي
                                .autocapitalization(.none) //  منع تحويل الأحرف الكبيرة
                                .multilineTextAlignment(.trailing)
                                .focused($isTextFieldFocused2)
                                .onChange(of: viewModel.password) { newValue in
                                        viewModel.password = newValue.filter { "0123456789".contains($0) }
                                        checkLoginButtonState() //  تحديث الزر عند إدخال اسم المستخدم

                                                         }
                                .disabled(viewModel.isLoading)
                                  
                            } else {
                                SecureField("1234", text: $viewModel.password)
                                    .keyboardType(.asciiCapableNumberPad) //  أرقام إنجليزية فقط
                                    .textContentType(.oneTimeCode) //  يخفي زر تغيير اللغة في بعض لوحات المفاتيح
                                    .disableAutocorrection(true) //  منع التصحيح التلقائي
                                    .autocapitalization(.none) //  منع تحويل الأحرف الكبيرة
                                    .multilineTextAlignment(.trailing)
                                    .focused($isTextFieldFocused2)
                                    .onChange(of: viewModel.password) { newValue in
                                        viewModel.password = newValue.filter { "0123456789".contains($0) }
                                        checkLoginButtonState() //  تحديث الزر عند إدخال اسم المستخدم

                                                         }
                                    .disabled(viewModel.isLoading)
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
                       
                    }
                }
                
                Spacer()
                    .frame(height: screenHeight * 0.015)
                
                // Login Button
                
                // استبدل كود الزر الحالي بهذا
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
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5 : 1.0)

                // إضافة NavigationLink المخفية للتنقل بدلاً من navigationDestination
                .background(
                    Group {
                        NavigationLink(
                            destination: LoginPageWelcom()
                                .environmentObject(teacherData)
                                .preferredColorScheme(.light),
                            isActive: Binding(
                                get: { viewModel.nextPage == .registerInfo && viewModel.navigateToNextPage },
                                set: { _ in }
                            )
                        ) { EmptyView() }
                        
                        NavigationLink(
                            destination: registerPageWaitProcess()
                                .environmentObject(teacherData)
                                .preferredColorScheme(.light),
                            isActive: Binding(
                                get: { viewModel.nextPage == .waitProcess && viewModel.navigateToNextPage },
                                set: { _ in }
                            )
                        ) { EmptyView() }
                        
                        NavigationLink(
                            destination: MainViewPage()
                                .environmentObject(teacherData)
                                .preferredColorScheme(.light),
                            isActive: Binding(
                                get: { viewModel.nextPage == .homePage && viewModel.navigateToNextPage },
                                set: { _ in }
                            )
                        ) { EmptyView() }
                        
                        NavigationLink(
                            destination: registerPageDecline()
                                .environmentObject(teacherData)
                                .preferredColorScheme(.light),
                            isActive: Binding(
                                get: { viewModel.nextPage == .rejectionIssue && viewModel.navigateToNextPage },
                                set: { _ in }
                            )
                        ) { EmptyView() }
                    }
                )
                
//                Button(action: {
//                    hideKeyboardExplicitly()
//                    viewModel.login()
//                    viewModel.isLoading = true
//                }) {
//                    Text("تسجيل الدخول")
//                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
//                        .frame(height: screenHeight * 0.05)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: screenWidth * 0.8)
//                }
//                .background(isPressed
//                            ? Color.black
//                            : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                .cornerRadius(5)
//                .disabled(viewModel.isLoading)
//                .opacity(viewModel.isLoading ? 0.5 : 1.0)
//                .navigationDestination(isPresented: $viewModel.navigateToNextPage) {
//                    switch viewModel.nextPage {
//                    case .registerInfo:
//                        LoginPageWelcom()
//                            .environmentObject(teacherData)
//                            .preferredColorScheme(.light)
//
//                           // .environmentObject(vmAttendaceStatus)
//                    case .waitProcess:
//                        registerPageWaitProcess()
//                            .environmentObject(teacherData)
//                            .preferredColorScheme(.light)
//
//                            //.environmentObject(vmAttendaceStatus)
//                    case .homePage:
//                        MainViewPage()
//                           // .environmentObject(vmAttendaceStatus)
//                           // .environmentObject(coreDataViewModel)
//                            .environmentObject(teacherData)
//                            .preferredColorScheme(.light)
//
//
//                    case .rejectionIssue:
//                        registerPageDecline()
//                            .environmentObject(teacherData)
//                            .preferredColorScheme(.light)
//
//                            //.environmentObject(vmAttendaceStatus)
//                    case .none:
//                        EmptyView()
//                    }
//                }
                
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
        .onDisappear {
                    UserDefaults.standard.removeObject(forKey: "imageDownloadError")
                }

     
    }
    
    //  تحديث زر تسجيل الدخول عند أي تعديل في المدخلات
      private func checkLoginButtonState() {
          DispatchQueue.main.async {
              isButtonDisabled = viewModel.username.count < 5 || viewModel.password.count < 6
          }
      }
 
}

//struct LoginPage1_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterInfoPage()
//            .environmentObject(TeacherDataViewModel())
//            .environmentObject(AttendaceStatusViewModel.shared)
//            .environmentObject(CoreDataViewModel.shared)
//    }
//}

// MARK: - دالة إخفاء الكيبورد
extension View {
    func hideKeyboardExplicitly() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}








