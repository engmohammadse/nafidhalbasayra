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
                    let uploader = AttendanceUploader(database: vmAttendaceStatus)
                        }
        }
    }
}
