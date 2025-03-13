//
//  register.swift
//  nafidhalbasayra
//
//  Created by muhammad on 09/10/2024.
//



import SwiftUI

struct registerPageWaitProcess: View {
    @State private var isCheckingStatus = false
    @State private var statusMessage: String? = nil
    @State private var currentPage: AppNavigation? = nil //  المتغير لتحديد الصفحة الحالية

    var body: some View {
        if currentPage == .home {
            registerPageAccept() //  الانتقال إلى الصفحة الرئيسية
        } else if currentPage == .rejection {
            registerPageDecline() //  الانتقال إلى صفحة الرفض
        } else {
            //  صفحة الانتظار الأصلية
            VStack {
                Spacer()
                    .frame(height: screenHeight * 0.05)
                
                Image("Group 3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: uiDevicePhone ? screenHeight * 0.085 : screenHeight * 0.085)

                Spacer()
                    .frame(height: screenHeight * 0.2)
                
                

               // VStack {
                    Text("تجري مراجعة بياناتك، يرجى الانتظار قد يستغرق الامر بضع ساعات سيصلك اشعار بمجرد انتهاء مراجعة بياناتك")
                    
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                               .multilineTextAlignment(.center)
                               // نفس عرض زر "فحص حالة القبول"
                               .frame(width: screenWidth * 0.85)
                               .frame(height: screenHeight * 0.1)
                               // تسمح بالتوسّع عموديًا عند الحاجة لعدة أسطر
                              // .fixedSize(horizontal: false, vertical: true)
                               // يمكنك تحديد عدد الأسطر أو جعله مفتوحًا
                        .lineLimit(UIDevice.current.userInterfaceIdiom == .pad ? 2 : nil)
                       
             
               // }
                //.padding()
                .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
                .cornerRadius(5)
                .overlay{
                    VStack{
                        if isCheckingStatus {
                            ProgressView()
                        } else {
                            
                            // ✅ عرض رسالة للمستخدم إذا كان هناك خطأ أو حالة قيد المراجعة
                            if let errorMessage = statusMessage {
                                Text(errorMessage)
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.032 : screenWidth * 0.02))
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                        }
                    }
                    .position(x: uiDevicePhone ? screenWidth * 0.43 : screenWidth * 0.43 ,y: screenHeight * -0.1)
                }
                

                Spacer().frame(height: screenHeight * 0.03)

                // ✅ زر "فحص حالة القبول"
                Button(action: checkAcceptanceStatus) {
                    
                    HStack {
                     
                            Text("فحص حالة القبول")
                       
                    }
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.05)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
//                    .frame(width: screenWidth * 0.7, height: screenHeight * 0.05)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
                }
                .disabled(isCheckingStatus)

              
            }
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding(.horizontal, screenWidth * 0.1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))

            .overlay {
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.00 : screenHeight * 0.02)
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // ✅ دالة فحص حالة القبول
    private func checkAcceptanceStatus() {
        isCheckingStatus = true
        statusMessage = nil

        APIManager.shared.checkAcceptanceStatus { result in
            DispatchQueue.main.async {
                isCheckingStatus = false
                switch result {
                case .success(let state):
                    if state == 2 {
                        currentPage = .home //  الانتقال إلى الصفحة الرئيسية
                        let defaults = UserDefaults.standard
                        let loginState = 2
                        defaults.set(loginState, forKey: "loginState")
                    } else if state == 3 {
                        currentPage = .rejection //  الانتقال إلى صفحة الرفض
                        let defaults = UserDefaults.standard
                        let loginState = 0
                        defaults.set(loginState, forKey: "loginState")
                    } else {
                        statusMessage = "⏳ لا تزال بياناتك قيد المراجعة."
                    }
                case .failure(let error):
                    statusMessage = "❌ حدث خطأ: \(error.localizedDescription)"
                }
            }
        }
    }
}

//  تعريف `AppNavigation`
enum AppNavigation: Hashable {
    case home
    case wait
    case register
    case rejection
}

#Preview {
    registerPageWaitProcess()
}




//import SwiftUI
//
//struct registerPageWaitProcess: View {
//    @State private var isCheckingStatus = false
//    @State private var nextPage: NavigationPage? = nil // ✅ استخدام `NavigationPage` بدلاً من `PageType`
//    @State private var statusMessage: String? = nil
//
//    var body: some View {
//       // NavigationStack {
//            VStack {
//                Image("Group 3")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: uiDevicePhone ? screenHeight * 0.085 : screenHeight * 0.085)
//                
//                Spacer().frame(height: screenHeight * 0.05)
//                
//                VStack {
//                    Text("تجري مراجعة بياناتك، يرجى الانتظار قد يستغرق الامر بضع ساعات سيصلك اشعار بمجرد انتهاء مراجعة بياناتك")
//                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                        .multilineTextAlignment(.center)
//                }
//                .padding()
//                .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
//                .cornerRadius(5)
//                
//                Spacer().frame(height: screenHeight * 0.03)
//
//                // ✅ زر "فحص حالة القبول"
//                Button(action: checkAcceptanceStatus) {
//                    HStack {
//                        if isCheckingStatus {
//                            ProgressView()
//                        } else {
//                            Text("فحص حالة القبول")
//                        }
//                    }
//                    .frame(width: screenWidth * 0.7, height: screenHeight * 0.05)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                }
//                .disabled(isCheckingStatus)
//
//                // ✅ عرض رسالة للمستخدم إذا كان هناك خطأ أو حالة قيد المراجعة
//                if let errorMessage = statusMessage {
//                    Text(errorMessage)
//                        .font(.headline)
//                        .foregroundColor(.red)
//                        .padding()
//                }
//
//                // ✅ NavigationLink يقوم بتوجيه المستخدم بناءً على `nextPage`
//                NavigationLink(value: nextPage) {
//                    EmptyView()
//                }
//            }
//            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .overlay {
//                LogoIUserInfo()
//                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
//            }
//            .navigationBarBackButtonHidden(true)
//            .navigationDestination(for: NavigationPage.self) { page in
//                switch page {
//                case .home:
//                    MainViewPage() // ✅ استخدم `MainViewPage()`
//                case .rejection:
//                    registerPageDecline() // ✅ استخدم `registerPageDecline()`
//                }
//            }
//      //  }
//    }
//
//    // ✅ دالة فحص حالة القبول
//    private func checkAcceptanceStatus() {
//        isCheckingStatus = true
//        statusMessage = nil
//
//        APIManager.shared.checkAcceptanceStatus { result in
//            DispatchQueue.main.async {
//                isCheckingStatus = false
//                switch result {
//                case .success(let state):
//                    if state == 2 {
//                        nextPage = .home // ✅ الانتقال إلى الصفحة الرئيسية
//                    } else if state == 3 {
//                        nextPage = .rejection // ✅ الانتقال إلى صفحة الرفض
//                    } else {
//                        statusMessage = "⏳ لا تزال بياناتك قيد المراجعة."
//                    }
//                case .failure(let error):
//                    statusMessage = "❌ حدث خطأ: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//}
//
//// ✅ تعريف `NavigationPage` (بدلًا من `PageType`)
//enum NavigationPage: Hashable {
//    case home
//    case rejection
//}
//
//#Preview {
//    registerPageWaitProcess()
//}







//import SwiftUI
//
//struct registerPageWaitProcess: View {
//    
//    @State private var isPressed: Bool = false
//    @EnvironmentObject var teacherData: TeacherDataViewModel
//
//    
//    var body: some View {
//        VStack {
//            
//            Image("Group 3")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: uiDevicePhone ? screenHeight * 0.085 : screenHeight * 0.085)
//            Spacer()
//                .frame(height: screenHeight * 0.05)
//            
//            VStack{
//                Text("تجري مراجعة بياناتك، يرجى الانتظار قد يستغرق الامر بضع ساعات سيصلك اشعار بمجرد انتهاء مراجعة بياناتك")
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                    .multilineTextAlignment(.center)
//                    
//                   
//            }
//            .padding()
//            .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
//            .cornerRadius(5)
//            
//            
//          
//             
//        }
//        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//        .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//        .overlay {
//            LogoIUserInfo()
//                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
//        }
//        .navigationBarBackButtonHidden(true)
//       
//    }
//}
//
//#Preview {
//    registerPageWaitProcess()
//        .environmentObject(TeacherDataViewModel())
//}
