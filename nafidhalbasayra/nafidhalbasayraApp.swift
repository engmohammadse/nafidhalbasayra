//
//  nafidhalbasayraApp.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//


import SwiftUI



@main
struct nafidhalbasayraApp: App {
    @StateObject private var teacherData = TeacherDataViewModel()
    @StateObject private var vmAttendaceStatus = AttendaceStatusViewModel()
    @StateObject private var coreDataViewModel = CoreDataViewModel()

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if showSplash {
                    LoginPage0()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showSplash = false
                            }
                        }
                } else {
                    // MainViewPage()
                   // LoginPageWelcom()
                    //registerPage2()
                    TeacherInfoView()
                        .preferredColorScheme(.light)
                        .environmentObject(vmAttendaceStatus)
                        .environmentObject(teacherData)  // تأكد من تمرير البيانات هنا
                        .environmentObject(coreDataViewModel)
                }
            }
        }
    }
}












//import SwiftUI
//
//@main
//struct nafidhalbasayraApp: App {
//    @StateObject private var teacherData = TeacherDataViewModel()
//
//    @StateObject private var vmAttendaceStatus = AttendaceStatusViewModel()
//    
//    @State private var showSplash = true
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack {
//                if showSplash {
//                    LoginPage0()
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                showSplash = false
//                            }
//                        }
//                } else {
//                       //MainViewPage()
//                        LoginPageWelcom()
//                        .preferredColorScheme(.light)
//                        .environmentObject(vmAttendaceStatus)
//                        .environmentObject(teacherData)
//                }
//            }
//        }
//    }
//}








//import SwiftUI
//
//@main
//struct nafidhalbasayraApp: App {
//  //  let persistenceController = PersistenceController.shared
//    @StateObject var teacherData = TeacherDataViewModel()
//    @StateObject private var vmAttendaceStatus = AttendaceStatusViewModel()
//    
//    @State private var showSplash = true
//
//    var body: some Scene {
//        WindowGroup {
//            
//             
//            
//            NavigationStack{
//                
//                if showSplash {
//                    
//                    LoginPage0()
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                showSplash = false // Hide splash screen after 3 seconds
//                                
//                                
//                                
//                            }
//                            
//                        }
//                    
//                    
//                } else{
//                    
//   
//                    
////                    AddStudentToStudentDataSection()
//                       
//               
//                            //LoginPage1()
//                    MainViewPage()
//                        .preferredColorScheme(.light)
//                        .environmentObject(vmAttendaceStatus)
//                  
//                }
//                
//                
//            }
//            
////            ContentView()
////                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
