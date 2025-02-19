//
//  registerPage4.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct registerPageAccept: View {
    
    @State private var isPressed: Bool = false
    @EnvironmentObject var teacherData : TeacherDataViewModel
    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
    @EnvironmentObject var coreDataViewModel : CoreDataViewModel
    
    let teacherId = UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"

    @StateObject var viewModelAttendance: fetchAndStoreAttendancesFromBackEnd = fetchAndStoreAttendancesFromBackEnd(database: AttendaceStatusViewModel.shared)


    var body: some View {
        VStack {
            
            Image("Group 3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: uiDevicePhone ? screenHeight * 0.085 : screenHeight * 0.085)
            Spacer()
                .frame(height: uiDevicePhone ? screenHeight * 0.05 : screenHeight * 0.05)
            
            VStack{
                Text("تم قبول طلب التسجيل، يمكنك استخدام التطبيق")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.02))
                    .multilineTextAlignment(.center)
                   
            }
            .padding()
            .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8 )
            .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
            .cornerRadius(5)
            
            Spacer()
                .frame(height: screenHeight * 0.03)
            
            NavigationLink(
                destination: MainViewPage()
                    .environmentObject(teacherData)
                    .environmentObject(vmAttendaceStatus)
                , // استبدل `NextView()` بالـ View الذي تريد الانتقال إليه
                label: {
                    Text("بدء استخدام التطبيق")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.02))
                        .frame(height: screenHeight * 0.04)
                        .foregroundColor(.white)
                        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8)
                }
            )
            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
            .cornerRadius(5)

            
//            Button(action: {
//                
//            }){
//                Text("بدء استخدام التطبيق")
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.02))
//                    .frame(height: screenHeight * 0.04)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8)
//            }
//            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//            .cornerRadius(5)
            
             
        }
        .onAppear {
            
            Task {
                // تأخير التنفيذ لمدة معينة (مثلاً 2 ثانية)
                try await Task.sleep(nanoseconds: 20 * 1_000_000_000) // 2 ثانية
                await viewModelAttendance.fetchAndStoreAttendances(teacherID: teacherId)
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
        }
        
}

#Preview {
    registerPageAccept()
        .environmentObject(TeacherDataViewModel())
}

