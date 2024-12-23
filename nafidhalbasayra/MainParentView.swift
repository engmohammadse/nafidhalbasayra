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
    


    var body: some View {
        NavigationStack {
            // أي شاشة (أو شاشات) تحتاج هذه الـ ViewModels
            // سيتم وضعها هنا أو التنقّل منها
            RegisterInfoPage()
                .preferredColorScheme(.light)
                .environmentObject(teacherData)
                .environmentObject(vmAttendaceStatus)
                .environmentObject(coreDataViewModel)
                .onAppear {
                    let uploader = AttendanceUploader()

                    // البيانات التي سيتم إرسالها
                    let teacherId = "67b9909e8dcdb77b0e0c7" // استخدم ID صحيح
                    let studentsNumber = 34
                    let message = "تم تسجيل الحضور بنجاح"
                    let location = "{\"lng\":232.334,\"lat\":344.3434}" // صيغة الموقع المطلوبة
                    let date = "2024-12-24"
                    //let image = "attendanceImage"

                    // استدعاء الدالة
                    uploader.sendAttendanceData(
                        teacherId: teacherId,
                        studentsNumber: studentsNumber,
                        //image: image,
                        message: message,
                        location: location,
                        date: date
                    ) { success, response in
                        if success {
                            print("✅ Success: \(response ?? "No response")")
                        } else {
                            print("❌ Failure: \(response ?? "Unknown error")")
                        }
                    }
                        }
        }
    }
}
