//
//  MainParentView.swift
//  nafidhalbasayra
//
//  Created by muhammad on 22/12/2024.
//


import SwiftUI

struct MainParentView: View {
    @StateObject var teacherData = TeacherDataViewModel()
   // @StateObject var coreDataViewModel = CoreDataViewModel()
    @StateObject var studentViewModel = StudentViewModel.shared
    @StateObject var studentFetcher = fetchAndStoreStudentsFromBackEnd(database: StudentViewModel.shared)
    @StateObject var attendanceFetcher = fetchAndStoreAttendancesFromBackEnd(database: AttendaceStatusViewModel.shared)

    @Environment(\.scenePhase) private var scenePhase // 🔹 متابعة حالة التطبيق

    var body: some View {
        let loginState = UserDefaults.standard.integer(forKey: "loginState")
        NavigationStack {
            
         
            
            if loginState == 2 {
                MainViewPage()
                    .preferredColorScheme(.light)
                    .environmentObject(teacherData)
                   // .environmentObject(coreDataViewModel)
                
            } else if loginState == 1 {
                registerPageWaitProcess()
                    .preferredColorScheme(.light)
                    .environmentObject(teacherData)
                  //  .environmentObject(coreDataViewModel)
            } else if loginState == 0 {
                
                RegisterInfoPage()
                   // .environmentObject(coreDataViewModel)
                    .preferredColorScheme(.light)
                    .environmentObject(teacherData)
                   // .environmentObject(coreDataViewModel)
                    .onAppear {
                                UserDefaults.standard.removeObject(forKey: "imageDownloadError")
                            }
                
            } else if loginState == 3 {
                registerPageDecline()
                  //  .environmentObject(coreDataViewModel)
                    .preferredColorScheme(.light)
                    .environmentObject(teacherData)
            } else {
                Text("جارٍ تحميل البيانات...") // ✅ شاشة مؤقتة في حال لم يتم تعيين loginState بعد
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            uploadData() // تحميل البيانات عند فتح الصفحة لأول مرة
          
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                uploadData() // تحميل البيانات عند إعادة فتح التطبيق من الخلفية
            }
        }
    }

    // 🔹 دالة تحميل بيانات الحضور والطلاب
    func uploadData() {
        Task {
                           await attendanceFetcher.fetchAndStoreAttendances(teacherID: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7")
                       }
        
        Task {
                   await studentFetcher.fetchAndStoreStudents(teacherID: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7") // 🔹 جلب الطلاب عند إعادة فتح التطبيق
               }
        //
//        let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//        attendanceUploader.sendPendingAttendanceData()
//
//        let studentUploader = StudentUploader(database: studentViewModel)
//        studentUploader.sendPendingStudentData()
//
//        print("✅ تم تحميل البيانات بنجاح!")
    }
}






#Preview {
    MainParentView()
}











//import SwiftUI
//
//struct MainParentView: View {
//    @StateObject var teacherData = TeacherDataViewModel()
//    @ObservedObject var vmAttendaceStatus = AttendaceStatusViewModel.shared
//    @StateObject var coreDataViewModel = CoreDataViewModel()
//    @StateObject var studentViewModel = StudentViewModel.shared
//
//    @Environment(\.scenePhase) private var scenePhase // 🔹 متابعة حالة التطبيق
//
//    var body: some View {
//        NavigationStack {
//            let loginState = UserDefaults.standard.integer(forKey: "loginState")
//            
//            if loginState == 2 {
//                MainViewPage()
//                    .preferredColorScheme(.light)
//                    .environmentObject(teacherData)
//                    .environmentObject(vmAttendaceStatus)
//                    .environmentObject(coreDataViewModel)
//                    .onAppear {
//                        uploadData() // تحميل البيانات عند فتح الصفحة لأول مرة
//                    }
//                    .onChange(of: scenePhase) { newPhase in
//                        if newPhase == .active {
//                            uploadData() // تحميل البيانات عند إعادة فتح التطبيق من الخلفية
//                        }
//                    }
//            } else {
//                RegisterInfoPage()
//                    .preferredColorScheme(.light)
//                    .environmentObject(teacherData)
//                    .environmentObject(vmAttendaceStatus)
//                    .environmentObject(coreDataViewModel)
//                    .onAppear {
//                        uploadData()
//                    }
//                    .onChange(of: scenePhase) { newPhase in
//                        if newPhase == .active {
//                            uploadData()
//                        }
//                    }
//            }
//        }
//    }
//
//    // 🔹 دالة تحميل بيانات الحضور والطلاب
//    func uploadData() {
//        print("🔄 تحميل بيانات الحضور والطلاب...")
//
//        let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//        attendanceUploader.sendPendingAttendanceData()
//
//        let studentUploader = StudentUploader(database: studentViewModel)
//        studentUploader.sendPendingStudentData()
//
//        print("✅ تم تحميل البيانات بنجاح!")
//    }
//}


















//import SwiftUI
//
//struct MainParentView: View {
//    @StateObject var teacherData = TeacherDataViewModel()
//    @ObservedObject var vmAttendaceStatus = AttendaceStatusViewModel.shared // ✅ استخدام Singleton
//    @StateObject var coreDataViewModel = CoreDataViewModel()
//    
//    @StateObject var studentViewModel = StudentViewModel.shared // إضافة StudentViewModel
//
//    var body: some View {
//        NavigationStack {
//            // أي شاشة (أو شاشات) تحتاج هذه الـ ViewModels
//            // سيتم وضعها هنا أو التنقّل منها
//            
//            
//            let loginState = UserDefaults.standard.integer(forKey: "loginState")
//            
//            if loginState == 2 {
//                
//                 MainViewPage()
//                    .preferredColorScheme(.light)
//                    .environmentObject(teacherData)
//                    .environmentObject(vmAttendaceStatus)
//                    .environmentObject(coreDataViewModel)
//                
//            }  else {
//                
//                RegisterInfoPage()
//                    .preferredColorScheme(.light)
//                    .environmentObject(teacherData)
//                    .environmentObject(vmAttendaceStatus)
//                    .environmentObject(coreDataViewModel)
//                    .onAppear {
//
//                        let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//                        attendanceUploader.sendPendingAttendanceData()
//
//                        
//                        // إرسال بيانات الطلاب
//                        let studentUploader = StudentUploader(database: studentViewModel)
//                        studentUploader.sendPendingStudentData() // استدعاء الدالة لإرسال بيانات الطلاب
//
//                        
//                       
//
//
//                            }
//            }
//            
//          
//            
//            
//            
//        }
//    }
//    
//    
//
//    
//}
