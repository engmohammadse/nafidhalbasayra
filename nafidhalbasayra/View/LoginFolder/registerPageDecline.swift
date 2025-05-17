//
//  registerPage5.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//






import SwiftUI

struct registerPageDecline: View {
    
    @State private var rejectionReason: String = "جارٍ جلب سبب الرفض..."
    @EnvironmentObject var teacherData : TeacherDataViewModel
    @EnvironmentObject var coreDataViewModel : CoreDataViewModel
    
    @State private var path = NavigationPath()
    @State private var showNoInternetAlert = false
    @State private var isLoading = false // ✅ مؤشر التحميل

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Image("Group 3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: uiDevicePhone ? screenHeight * 0.085 : screenHeight * 0.085)
                
                Spacer().frame(height: screenHeight * 0.05)
                
                VStack {
                    Text("\(rejectionReason)")
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255))
                }
                .padding()
                .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8 )
                .background(Color(red: 234 / 255, green: 225 / 255, blue: 225 / 255))
                .cornerRadius(5)
                
                Spacer().frame(height: screenHeight * 0.03)
                
                Text("اعادة ادخال البيانات")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.02))
                    .frame(height: screenHeight * 0.04)
                    .foregroundColor(.white)
                    .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8)
                    .background( Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                    .cornerRadius(5)
                    .onTapGesture {
                        InternetChecker.isInternetAvailable { isAvailable in
                            DispatchQueue.main.async {
                                if isAvailable {
                                    isLoading = true // ✅ ابدأ التحميل
                                    
                                    TeacherStateResetter.resetTeacherState { success, state, error in
                                        DispatchQueue.main.async {
                                            isLoading = false // ✅ أوقف التحميل بعد الاستجابة
                                            
                                            if success {
                                                path.append("registerInfo")
                                            }
//                                            else {
//                                                print("❌ فشل إعادة الضبط: \(error ?? "خطأ غير معروف")")
//                                            }
                                        }
                                    }
                                } else {
                                    showNoInternetAlert = true
                                }
                            }
                        }
                    }
                
                // ✅ إظهار مؤشر التحميل إن كان جاري
                if isLoading {
                    ProgressView("جارٍ التحميل...")
                        .padding()
                }
            }
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
            .overlay {
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                let reason = UserDefaults.standard.string(forKey: "rejectionReason") ?? "لا يوجد تفاصيل للرفض"
                rejectionReason = reason
            }
            .navigationDestination(for: String.self) { value in
                if value == "registerInfo" {
                    RegisterInfoPage()
                        .environmentObject(teacherData)
                        .onAppear {
                            clearUserData()
                        }
                }
            }
            .alert(isPresented: $showNoInternetAlert) {
                Alert(title: Text("لا يوجد اتصال"),
                      message: Text("يرجى التحقق من اتصال الإنترنت."),
                      dismissButton: .default(Text("موافق")))
            }
        }
    }

    private func clearUserData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "teacherId")
        defaults.removeObject(forKey: "rejectionReason")
        defaults.removeObject(forKey: "loginState")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "profileImagePath")

        deleteProfileImage()

        AttendaceStatusViewModel.shared.clearAllAttendanceData()
        StudentViewModel.shared.clearAllStudentData()
        
        let coreDataViewModel = CoreDataViewModel.shared
        coreDataViewModel.deleteAllTeacherInfo()
        
        let coreDataNotificationVM = CoreDataNotificationViewModel.shared
        coreDataNotificationVM.deleteAllNotifications()
    }
}


//#Preview {
//    registerPageDecline()
//        .environmentObject(TeacherDataViewModel())
//}
