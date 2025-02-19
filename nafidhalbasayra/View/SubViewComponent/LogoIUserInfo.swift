//
//  LogoIUserDetails.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")

        DispatchQueue.main.async {
            self.isLoggedIn = false

            // ✅ إعادة تعيين البيانات لمنع الاستهلاك غير الضروري
            self.objectWillChange.send() // إجبار SwiftUI على التحديث
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let newRootView = NavigationStack {
                RegisterInfoPage()
                    .environmentObject(AppViewModel())
                    .environmentObject(TeacherDataViewModel())
                    .environmentObject(AttendaceStatusViewModel())
                    .environmentObject(CoreDataViewModel())
                    .preferredColorScheme(.light)
            }

            window.rootViewController = UIHostingController(rootView: newRootView)
            window.makeKeyAndVisible()
        }
    }

    
//    func logout() {
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
//
//        DispatchQueue.main.async {
//            self.isLoggedIn = false
//
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                  let window = windowScene.windows.first else { return }
//
//            let newRootView = NavigationStack { // ✅ وضع RegisterInfoPage داخل NavigationStack
//                RegisterInfoPage()
//                    .environmentObject(AppViewModel())
//                    .environmentObject(TeacherDataViewModel())
//                    .environmentObject(AttendaceStatusViewModel())
//                    .environmentObject(CoreDataViewModel())
//                    .preferredColorScheme(.light)
//            }
//
//            window.rootViewController = UIHostingController(rootView: newRootView)
//            window.makeKeyAndVisible()
//        }
//    }

}



import SwiftUI

struct LogoIUserInfo: View {
    
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
    @EnvironmentObject var appViewModel: AppViewModel  // إدارة حالة تسجيل الدخول
    
    @State private var showLogoutConfirmation = false // عرض تأكيد تسجيل الخروج
    
    var body: some View {
        GeometryReader { geometry in
            let geoW = geometry.size.width
            
            HStack {
                
                // ⬇️ إضافة زر تسجيل الخروج عند الضغط على الصورة ⬇️
                Button(action: {
                    showLogoutConfirmation = true // إظهار قائمة تسجيل الخروج
                }) {
                    if let image = teacherData.profileimage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.2) : screenWidth * 0.2)
                            .clipShape(Circle())
                    } else {
                        Image("Group 63")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: screenWidth * 0.07)
                    }
                }
                .confirmationDialog("هل تريد تسجيل الخروج؟", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                    Button("تسجيل الخروج", role: .destructive) {
                        appViewModel.logout()
                    }
                    Button("إلغاء", role: .cancel) { }
                }

                Text(teacherData.userName ?? "user1212")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, geoW * 0.05)
                    .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                    .cornerRadius(5)
                
                Spacer()
                
                Image("Group 1")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: screenWidth * 0.42)
                    .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 40)
            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
        }
    }
}




//import SwiftUI
//
//struct LogoIUserInfo: View {
//    
//   // @ObservedObject var teacherData: TeacherDataViewModel
//    @EnvironmentObject var teacherData: TeacherDataViewModel
//    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
//    
//    var body: some View {
//        GeometryReader { geometry in
//            
//            let geoW = geometry.size.width
//            
//                HStack{
//  
//                    // عرض الصورة إذا كانت موجودة
//                         if let image = teacherData.profileimage {
//                             Image(uiImage: image)
//                                 .resizable()
//                                 .scaledToFit()
//                                 .frame(maxWidth: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.1  : screenWidth * 0.2) : screenWidth * 0.2)
//                         
//                                 .clipShape(Circle())
//                         }
//         
//                         else {
//                           
//                             Image("Group 63")
//                                 .resizable()
//                                 .aspectRatio(contentMode: .fit)
//                                 .frame(maxWidth: screenWidth * 0.07)
//                             
//                         }
//                    
//                    
//                    
//                    
//                        Text(teacherData.userName ?? "user1212")
//                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                            .foregroundStyle(Color.white)
//                            .padding(.horizontal, geoW * 0.05)
//                            .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
//                            .cornerRadius(5)
//                  
//                    
//                    
//                    
//                  
//                    
//                    
//                        Spacer()
//                      
//                    
//                    Image("Group 1")
//                        .resizable()
//                        .renderingMode(.template)  // Forces the image to be drawn as a template (grayscale)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: screenWidth * 0.42 )
//                        .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
//                        .padding(.bottom, 10)
//                }
//                .padding(.horizontal, 40)
//                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//             
//                    
//            
//            
//        }
//    }
//}

//#Preview {
//    LogoIUserInfo()
//            .environmentObject(TeacherDataViewModel())
//}


#Preview {
    // استخدام نفس التهيئة مثلما تستخدمها في التطبيق الفعلي
    let teacherData = TeacherDataViewModel()   // نفس التهيئة كما في @StateObject
    let vmAttendaceStatus = AttendaceStatusViewModel()

    return LogoIUserInfo()
        .environmentObject(teacherData)   // تمرير الـ environmentObject في الـ Preview
        .environmentObject(vmAttendaceStatus)  // إذا كنت بحاجة إليه هنا
}

