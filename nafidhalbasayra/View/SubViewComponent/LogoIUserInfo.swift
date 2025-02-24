//
//  LogoIUserDetails.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//


import SwiftUI

class AppViewModel: ObservableObject {
    // ✅ إنشاء Singleton
    
    @Environment(\.dismiss) var dismiss

    static let shared = AppViewModel()
    
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")

    private init() {} // ✅ اجعل `init()` خاصًا لمنع إنشاء كائن جديد

    func logout() {
        let defaults = UserDefaults.standard

        // ✅ مسح جميع بيانات المستخدم من UserDefaults
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "teacherId")
        defaults.removeObject(forKey: "rejectionReason")
        defaults.removeObject(forKey: "loginState")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "profileImagePath") // ✅ إزالة مسار الصورة
        
        // ✅ مسح الصورة من FileManager
        deleteProfileImage()
           
        defaults.synchronize()

        DispatchQueue.main.async {
            self.isLoggedIn = false

            // ✅ استخدام الـ Singleton لمسح البيانات **بدون إعادة تحميل Persistent Store**
            AttendaceStatusViewModel.shared.clearAllAttendanceData()
            StudentViewModel.shared.clearAllStudentData()

            // ✅ إعادة تعيين `rootViewController`
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let newRootView = NavigationStack {
                RegisterInfoPage()
                    .environmentObject(AppViewModel.shared) // ✅ الآن `shared` موجودة
                    .environmentObject(TeacherDataViewModel())
                    .environmentObject(AttendaceStatusViewModel.shared)
                    .environmentObject(StudentViewModel.shared)
                    .environmentObject(CoreDataViewModel())
                    .preferredColorScheme(.light)
            }

            window.rootViewController = UIHostingController(rootView: newRootView)
            window.makeKeyAndVisible()
        }
    }
}




import SwiftUI

struct LogoIUserInfo: View {
    
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
    @EnvironmentObject var studentViewModel: StudentViewModel  // ✅ إضافته هنا
    @EnvironmentObject var appViewModel: AppViewModel  // إدارة تسجيل الخروج
    
    @State private var showLogoutConfirmation = false // تأكيد تسجيل الخروج
    
    @State private var profileImage: UIImage? = getSavedProfileImage()

    
    var body: some View {
        GeometryReader { geometry in
            let geoW = geometry.size.width
            
            HStack {
                // ⬇️ زر تسجيل الخروج ⬇️
                Button(action: {
                    showLogoutConfirmation = true // عرض تأكيد تسجيل الخروج
                }) {
                    
                    if let image = profileImage {
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
                        AppViewModel.shared.logout() // ✅ استخدم Singleton مباشرةً

                    }

                    Button("إلغاء", role: .cancel) { }
                }

                Text(UserDefaults.standard.string(forKey: "username") ?? "لا يوجد مستخدم")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, geoW * 0.05)
                    .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                    .cornerRadius(5)
                    .padding(.horizontal, screenWidth * 0.005)
                
                Spacer()
                
                Image("Group 1")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.5 : screenWidth * 0.4)
                    .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, screenWidth * 0.08)
//            .padding(.bottom, screenHeight * 0.005)
            .offset(y: uiDevicePhone ? -screenHeight * 0.01 : 0) // 🔼 رفع العنصر للأعلى قليلًا
            

           // .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            .background(
                VStack {
                    Color(red: 236/255, green: 242/255, blue: 245/255)
                        .frame(height: screenHeight * 0.3) // ✅ زيادة الخلفية فقط
                }
                    .offset(y: screenHeight * -0.135)
            )


            .onAppear {
                           // ✅ الاستماع إلى الإشعار عند تحديث الصورة
                           NotificationCenter.default.addObserver(forName: NSNotification.Name("ProfileImageUpdated"), object: nil, queue: .main) { _ in
                               self.profileImage = getSavedProfileImage() // 🔄 إعادة تحميل الصورة
                           }
                       }
                       .onDisappear {
                           // ✅ إزالة المستمع لتوفير الموارد
                           NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ProfileImageUpdated"), object: nil)
                       }
        }

    }
}



#Preview {
    let teacherData = TeacherDataViewModel()
    let vmAttendaceStatus = AttendaceStatusViewModel.shared // ✅ استخدام الـ Singleton
    let studentViewModel = StudentViewModel.shared
    let appViewModel = AppViewModel.shared // ✅ استخدام Singleton

    return LogoIUserInfo()
        .environmentObject(teacherData)
        .environmentObject(vmAttendaceStatus) // ✅ استخدام الكائن المشترك
        .environmentObject(studentViewModel)
        .environmentObject(appViewModel) // ✅ استخدام نفس كائن AppViewModel
}








//import SwiftUI
//
//class AppViewModel: ObservableObject {
//    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
//    
//    func logout(attendanceViewModel: AttendaceStatusViewModel, studentViewModel: StudentViewModel) {
//        let defaults = UserDefaults.standard
//
//        // ✅ مسح جميع بيانات المستخدم من UserDefaults
//        defaults.removeObject(forKey: "isLoggedIn")
//        defaults.removeObject(forKey: "teacherId")
//        defaults.removeObject(forKey: "rejectionReason")
//        defaults.removeObject(forKey: "loginState")
//        defaults.synchronize()
//
//        DispatchQueue.main.async {
//            self.isLoggedIn = false
//
//            // ✅ مسح بيانات الحضور وإعادة تهيئة Core Data
//            attendanceViewModel.clearAllAttendanceData()
//            studentViewModel.clearAllStudentData()
//
//            // ✅ إعادة تحميل Persistent Store بعد المسح
//            attendanceViewModel.container.loadPersistentStores { _, error in
//                if let error = error {
//                    print("❌ خطأ في إعادة تحميل Core Data بعد الحذف: \(error.localizedDescription)")
//                } else {
//                    print("✅ تم إعادة تحميل Core Data بعد الحذف.")
//                }
//            }
//
//            // ✅ إعادة تعيين `rootViewController`
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                  let window = windowScene.windows.first else { return }
//
//            let newRootView = NavigationStack {
//                RegisterInfoPage()
//                    .environmentObject(AppViewModel())
//                    .environmentObject(TeacherDataViewModel())
//                    .environmentObject(attendanceViewModel) // ✅ استخدام نفس الكائن
//                    .environmentObject(studentViewModel) // ✅ استخدام نفس الكائن
//                    .environmentObject(CoreDataViewModel())
//                    .preferredColorScheme(.light)
//            }
//
//            window.rootViewController = UIHostingController(rootView: newRootView)
//            window.makeKeyAndVisible()
//        }
//    }
//
//
//}
//
//
//
//import SwiftUI
//
//struct LogoIUserInfo: View {
//    
//    @EnvironmentObject var teacherData: TeacherDataViewModel
//    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
//    @EnvironmentObject var studentViewModel: StudentViewModel
//
//    @EnvironmentObject var appViewModel: AppViewModel  // إدارة حالة تسجيل الدخول
//    
//    @State private var showLogoutConfirmation = false // عرض تأكيد تسجيل الخروج
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let geoW = geometry.size.width
//            
//            HStack {
//                
//                // ⬇️ إضافة زر تسجيل الخروج عند الضغط على الصورة ⬇️
//                Button(action: {
//                    showLogoutConfirmation = true // إظهار قائمة تسجيل الخروج
//                }) {
//                    if let image = teacherData.profileimage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.2) : screenWidth * 0.2)
//                            .clipShape(Circle())
//                    } else {
//                        Image("Group 63")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(maxWidth: screenWidth * 0.07)
//                    }
//                }
//                .confirmationDialog("هل تريد تسجيل الخروج؟", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
//                    Button("تسجيل الخروج", role: .destructive) {
//                        appViewModel.logout(attendanceViewModel: vmAttendaceStatus, studentViewModel: studentViewModel)
//
//                    }
//                    Button("إلغاء", role: .cancel) { }
//                }
//
//                Text(teacherData.userName ?? "user1212")
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                    .foregroundStyle(Color.white)
//                    .padding(.horizontal, geoW * 0.05)
//                    .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
//                    .cornerRadius(5)
//                
//                Spacer()
//                
//                Image("Group 1")
//                    .resizable()
//                    .renderingMode(.template)
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: screenWidth * 0.42)
//                    .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
//                    .padding(.bottom, 10)
//            }
//            .padding(.horizontal, 40)
//            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//        }
//    }
//}
//
//
//
//
////import SwiftUI
////
////struct LogoIUserInfo: View {
////    
////   // @ObservedObject var teacherData: TeacherDataViewModel
////    @EnvironmentObject var teacherData: TeacherDataViewModel
////    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
////    
////    var body: some View {
////        GeometryReader { geometry in
////            
////            let geoW = geometry.size.width
////            
////                HStack{
////  
////                    // عرض الصورة إذا كانت موجودة
////                         if let image = teacherData.profileimage {
////                             Image(uiImage: image)
////                                 .resizable()
////                                 .scaledToFit()
////                                 .frame(maxWidth: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.1  : screenWidth * 0.2) : screenWidth * 0.2)
////                         
////                                 .clipShape(Circle())
////                         }
////         
////                         else {
////                           
////                             Image("Group 63")
////                                 .resizable()
////                                 .aspectRatio(contentMode: .fit)
////                                 .frame(maxWidth: screenWidth * 0.07)
////                             
////                         }
////                    
////                    
////                    
////                    
////                        Text(teacherData.userName ?? "user1212")
////                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
////                            .foregroundStyle(Color.white)
////                            .padding(.horizontal, geoW * 0.05)
////                            .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
////                            .cornerRadius(5)
////                  
////                    
////                    
////                    
////                  
////                    
////                    
////                        Spacer()
////                      
////                    
////                    Image("Group 1")
////                        .resizable()
////                        .renderingMode(.template)  // Forces the image to be drawn as a template (grayscale)
////                        .aspectRatio(contentMode: .fit)
////                        .frame(maxWidth: screenWidth * 0.42 )
////                        .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
////                        .padding(.bottom, 10)
////                }
////                .padding(.horizontal, 40)
////                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
////             
////                    
////            
////            
////        }
////    }
////}
//
////#Preview {
////    LogoIUserInfo()
////            .environmentObject(TeacherDataViewModel())
////}
//
//
//#Preview {
//    // استخدام نفس التهيئة مثلما تستخدمها في التطبيق الفعلي
//    let teacherData = TeacherDataViewModel()   // نفس التهيئة كما في @StateObject
//    let vmAttendaceStatus = AttendaceStatusViewModel()
//
//    return LogoIUserInfo()
//        .environmentObject(teacherData)   // تمرير الـ environmentObject في الـ Preview
//        .environmentObject(vmAttendaceStatus)  // إذا كنت بحاجة إليه هنا
//}

