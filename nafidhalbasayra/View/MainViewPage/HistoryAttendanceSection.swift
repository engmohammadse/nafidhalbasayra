//
//  AttendanceEnrollmentSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 19/10/2024.
//

import SwiftUI

struct HistoryAttendance: View {
    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel

    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        
         VStack{
             
             
             HStack{
                 
                 Text("عدد مرات تسجيل الحضور: \(vmAttendaceStatus.savedEntitiesAttendace.count)")                     .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.037 : screenWidth * 0.023 ))
                     .padding(.all, screenWidth * 0.023)
             }
             .background(.white)
             .cornerRadius(5)
             .offset(x: uiDevicePhone ? screenWidth * 0.17 : screenWidth * 0.27 ,y: uiDevicePhone ? screenHeight * 0.06 : screenHeight * 0.07)
             .padding(.bottom, screenHeight * 0.005)
             
             Spacer()
                 .frame(height: screenHeight * 0.07)

             ScrollView {
                 Spacer()
                     .frame(height: screenHeight * 0.05)
                 
                 ForEach(Array(vmAttendaceStatus.savedEntitiesAttendace.enumerated()),id: \.element) { index, entity in
                 studentHistory(entity: entity, orderNumber: index + 1)
                 
                     Spacer()
                         .frame(height: screenHeight * 0.03)
                 
             }
             }
             .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير

             .frame(maxWidth: .infinity)
             
             
           
             
             
             
         }
         .padding(.all, screenWidth * 0.02)
         .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//         .overlay{
//
//             LogoIUserInfo()
//                 .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
//              
//         }
        
         .onAppear {
             vmAttendaceStatus.fetchAttendaceStatus() // 🛑 إعادة تحميل البيانات عند فتح الصفحة
         }

     
         
         
         
         .overlay{
             ZStack{
                 Button(action: {
                     dismiss()
                 }) {
                     Image("Group 56")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
                 }
                 .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
             }
         }
        
         .overlay {
             LogoIUserInfo()
                 .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
         }
         .navigationBarBackButtonHidden(true)
         
             
         
     }
 }



struct studentHistory: View {
    @State private var repeatSend: Bool = false
    @State private var repeatSendState: Bool = false

    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
    var entity: AttendaceStatus
    var orderNumber: Int
    @State private var showNoInternetToast = false

    

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: screenHeight * 0.015) {
                // ✅ **الصف الأول: العناوين**
                HStack {
                    Spacer()
                    Text("الحالة")
                   // Spacer(minLength: screenWidth * 0.08) // ✅ **مسافة صغيرة**
                    Spacer(minLength: uiDevicePhone ? screenWidth * 0.12 : screenWidth * 0.2)
                    Text("الطلبة الحاضرين")
                    //Spacer(minLength: screenWidth * 0.18) // ✅ **زيادة المسافة بين "التاريخ" و "الطلبة الحاضرين"**
                    Spacer(minLength: uiDevicePhone ? screenWidth * 0.15 : screenWidth * 0.1)
                    Text("التاريخ")
                    Spacer()
                }
                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.038 : screenWidth * 0.025))
                .frame(maxWidth: .infinity)

                // ✅ **الصف الثاني: البيانات (يجب أن تكون أسفل العناوين مباشرة)**
                HStack {
                    Spacer()
                    Text(repeatSendState ? "مرسل" : "غير مرسل")
                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                        .foregroundColor(repeatSendState ? .green : redColorFalse)
                        .frame(minWidth: screenWidth * 0.2, alignment: .center)

                   // Spacer()
                    Spacer(minLength: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.08)

                    Text(entity.numberOfStudents ?? "no")
                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                        .frame(minWidth: screenWidth * 0.2, alignment: .center)

                   // Spacer()
                    Spacer(minLength: uiDevicePhone ? screenWidth * 0.05 : screenWidth * 0.08)

                    Text(formatDate(entity.date))
                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.032 : screenWidth * 0.023))
                        .minimumScaleFactor(0.8) // ✅ **تصغير الخط تلقائيًا إذا كان العرض ضيقًا**
                        .lineLimit(1) // ✅ **منع تأثير التاريخ على التصميم العام**

                    Spacer()
                }
                .padding(.bottom, screenHeight * 0.01) //

                .frame(maxWidth: .infinity)

                // ✅ **مسافة بين البيانات والزر**
//                Spacer(minLength: screenHeight * 0.02)

                // ✅ **زر إعادة الإرسال (مدمج داخل الكارت)**
                if !repeatSend {
                    Button(action: {
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now()) {
//                            let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//                            attendanceUploader.sendPendingAttendanceData()
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            vmAttendaceStatus.fetchAttendaceStatus()
//                        }
                        
                        InternetChecker.isInternetAvailable { isAvailable in
                            DispatchQueue.main.async {
                                if isAvailable {
                                    
                                    Task {
                                        
                                        let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
                                        attendanceUploader.sendPendingAttendanceData()
                                        
                                        repeatSendState = true
                                        repeatSend = true
                                        
                                        vmAttendaceStatus.fetchAttendaceStatus()
                                     
                                           }
                                } else {
                                    
                                    withAnimation {
                                         showNoInternetToast = true
                                                      }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showNoInternetToast = false
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        
                        
                    }) {
                        Text("إعادة الإرسال")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity) // ✅ **عرض الزر مساوي لعرض الكارت**
                            .frame(height: screenHeight * 0.045)
                    }
                    .background(primaryButtonColor)
                    .cornerRadius(2)
                    .overlay(
                               VStack {
                                   if showNoInternetToast {
                                       Text("⚠️ لا يوجد اتصال بالإنترنت")
                                           .padding()
                                           .background(Color.red.opacity(0.8))
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                           .transition(.opacity)
                                           .onAppear {
                                               withAnimation(.easeInOut(duration: 0.5)) {
                                                   showNoInternetToast = true
                                               }
                                           }
                                           .onDisappear {
                                               withAnimation(.easeInOut(duration: 0.5)) {
                                                   showNoInternetToast = false
                                               }
                                           }
                                   }
                               }
                               .padding(.bottom, 50),
                               alignment: .bottom
                           )
                }
            }
            .padding(.top, screenHeight * 0.015)
//            .padding(.bottom, screenHeight * 0.02) // ✅ **تقليل المسافة بين البيانات والزر**
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2) // ✅ **تحسين المظهر والظل**
        }
        .padding(.horizontal, screenWidth * 0.05) // ✅ **إضافة مسافة من اليمين واليسار**
        
        .overlay {
            // ✅ **رقم التسلسل داخل دائرة**
            Circle()
                .fill(primaryColor)
                .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.045)
                .overlay(
                    Text("\(orderNumber)")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                        .foregroundColor(.white)
                )
                .position(x: screenWidth * 0.47, y: screenHeight * 0.0)
        }
        .onAppear {
            repeatSendState = entity.state == 1
            repeatSend = repeatSendState
        }
    }

    // ✅ **دالة تنسيق التاريخ مع تقليل الحجم إذا لزم الأمر**
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "تاريخ غير متاح" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd  hh:mm a"
        dateFormatter.locale = Locale(identifier: "ar")

        let formattedDate = dateFormatter.string(from: date)
            .replacingOccurrences(of: "AM", with: "صباحًا")
            .replacingOccurrences(of: "PM", with: "مساءً")

        return formattedDate
    }
}







//#Preview {
//    let previewModel = AttendaceStatusViewModel.shared
//    
//    let sampleEntity = AttendaceStatus(context: previewModel.container.viewContext)
//    sampleEntity.id = UUID().uuidString
//    sampleEntity.numberOfStudents = "25"
//    sampleEntity.date = Date()
//    sampleEntity.state = 0
//
//    previewModel.savedEntitiesAttendace.append(sampleEntity)
//    
//    let sampleEntity2 = AttendaceStatus(context: previewModel.container.viewContext)
//    sampleEntity.id = UUID().uuidString
//    sampleEntity.numberOfStudents = "25"
//    sampleEntity.date = Date()
//    sampleEntity.state = 1
//
//    previewModel.savedEntitiesAttendace.append(sampleEntity2)
//
//    return HistoryAttendance()
//        .environmentObject(previewModel) // توفير EnvironmentObject في البريفيو
//}

