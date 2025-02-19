//
//  MainParentView.swift
//  nafidhalbasayra
//
//  Created by muhammad on 22/12/2024.
//

import SwiftUI

struct MainParentView: View {
    @StateObject var teacherData = TeacherDataViewModel()
    @StateObject var vmAttendaceStatus = AttendaceStatusViewModel()
    @StateObject var coreDataViewModel = CoreDataViewModel()
    
    @StateObject var studentViewModel = StudentViewModel() // إضافة StudentViewModel

    var body: some View {
        NavigationStack {
            // أي شاشة (أو شاشات) تحتاج هذه الـ ViewModels
            // سيتم وضعها هنا أو التنقّل منها
            
            
            let loginState = UserDefaults.standard.integer(forKey: "loginState")
            
            if loginState == 2 {
                
                 MainViewPage()
                    .preferredColorScheme(.light)
                    .environmentObject(teacherData)
                    .environmentObject(vmAttendaceStatus)
                    .environmentObject(coreDataViewModel)
                
            }  else {
                
                RegisterInfoPage()
                    .preferredColorScheme(.light)
                    .environmentObject(teacherData)
                    .environmentObject(vmAttendaceStatus)
                    .environmentObject(coreDataViewModel)
                    .onAppear {

                        let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
                        attendanceUploader.sendPendingAttendanceData()

                        
                        // إرسال بيانات الطلاب
                        let studentUploader = StudentUploader(database: studentViewModel)
                        studentUploader.sendPendingStudentData() // استدعاء الدالة لإرسال بيانات الطلاب

                        
                       


                            }
            }
            
          
        }
    }
}
