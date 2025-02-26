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
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
                            attendanceUploader.sendPendingAttendanceData()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            vmAttendaceStatus.fetchAttendaceStatus()
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




//
//struct studentHistory: View {
//    @State private var repeatSend: Bool = false
//    @State private var repeatSendState: Bool = false
//
//    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
//    var entity: AttendaceStatus
//    var orderNumber: Int
//
//    var body: some View {
//        VStack(spacing: 0) {
//            VStack(spacing: screenHeight * 0.015) { // ✅ تقليل المسافات بين العناصر
//                // ✅ الصف الأول: العناوين (يجب أن تكون متناسقة في المحاذاة)
//                HStack {
//                    Spacer()
//                    Text("الحالة")
//                    Spacer(minLength: screenWidth * 0.1) // ✅ زيادة المسافة
//                    Text("الطلبة الحاضرين")
//                    Spacer(minLength: screenWidth * 0.15)
//                    Text("التاريخ")
//                    Spacer()
//                }
//                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.038 : screenWidth * 0.025))
//                .frame(maxWidth: .infinity)
//
//                // ✅ الصف الثاني: البيانات (كل عنصر أسفل عنوانه مباشرة)
//                HStack {
//                    Spacer()
//                    Text(repeatSendState ? "مرسل" : "غير مرسل")
//                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
//                        .foregroundColor(repeatSendState ? .green : redColorFalse)
//                        .frame(minWidth: screenWidth * 0.2, alignment: .center)
//                        .padding(.bottom, screenHeight * 0.01)
//
//                    Spacer()
//
//                    Text(entity.numberOfStudents ?? "no")
//                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
//                        .frame(minWidth: screenWidth * 0.2, alignment: .center)
//
//                    Spacer()
//
//                    Text(formatDate(entity.date))
//                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.032 : screenWidth * 0.023))
//                        .minimumScaleFactor(0.8)
//                        //.frame(minWidth: screenWidth * 0.3, alignment: .center)
//
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity)
//
//                //Spacer(minLength: screenHeight * 0.005) // ✅ زيادة المسافة بين الصف الثاني والزر
//
//                // ✅ زر إعادة الإرسال **ملتصق بأسفل الكارت وبعرض الكارت بالكامل**
//                if !repeatSend {
//                    Button(action: {
//                        DispatchQueue.main.asyncAfter(deadline: .now()) {
//                            let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//                            attendanceUploader.sendPendingAttendanceData()
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            vmAttendaceStatus.fetchAttendaceStatus()
//                        }
//                    }) {
//                        Text("إعادة الإرسال")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: screenHeight * 0.045)
//                    }
//                    .background(primaryButtonColor)
//                    .cornerRadius(5)
//                }
//            }
//            //.frame(maxWidth: screenWidth * 0.85)
//            .padding(.top, screenHeight * 0.015)
//           // .padding(.bottom, screenHeight * 0.015) // ✅ تقليل المسافة أسفل الزر
//            .background(Color.white)
//            .cornerRadius(10) // ✅ زوايا ناعمة
//            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2) // ✅ تحسين الظل
//        }
//         .padding(.horizontal, screenWidth * 0.05) // ✅ مسافة من اليمين واليسار
//
//        .overlay {
//            // ✅ رقم التسلسل داخل دائرة
//            Circle()
//                .fill(primaryColor)
//                .frame(width: screenWidth * 0.06)
//                .overlay(
//                    Text("\(orderNumber)")
//                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
//                        .foregroundColor(.white)
//                )
//                .position(x: screenWidth * 0.47, y: screenHeight * 0.055)
//        }
//        .onAppear {
//            repeatSendState = entity.state == 1
//            repeatSend = repeatSendState
//        }
//    }
//
//    // ✅ دالة تنسيق التاريخ
//    func formatDate(_ date: Date?) -> String {
//        guard let date = date else { return "تاريخ غير متاح" }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm a"
//        dateFormatter.locale = Locale(identifier: "ar")
//
//        let formattedDate = dateFormatter.string(from: date)
//            .replacingOccurrences(of: "AM", with: "صباحًا")
//            .replacingOccurrences(of: "PM", with: "مساءً")
//
//        return formattedDate
//    }
//}






//
//
// struct studentHistory :View {
//     @State private var repeatSend : Bool = false
//     @State private var repeatSendState : Bool = false
//
//     @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
//     var entity: AttendaceStatus
//     var orderNumber: Int
//     
//     
//     
//     var body: some View {
//         
//         
//         
//           VStack {
//               
//       
//               Color.clear
//                   .frame(height: screenHeight * 0.05)
//                  
//               
//               VStack {
//                       
//                       HStack{
//                           
//                           VStack{
//                               Text("الحالة")
//                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                               Spacer()
//                                   
//                                   .frame(height: screenHeight * 0.02)
//                              
//                                  
//                               if repeatSendState == true {
//                                   Text("مرسل")
//                                       .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                               } else {
//                                   Text("غير مرسل")
//                                       .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                                       .foregroundStyle(redColorFalse)
//                               }
//                               
//                               
//                           }
//                           Spacer()
//                               .frame(width: screenWidth * 0.1)
//                           
//                           VStack{
//                               Text("الطلبة الحاضرين")
//                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                               Spacer()
//                                   .frame(height: screenHeight * 0.02)
//                               Text(entity.numberOfStudents ?? "no")
//                                   .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                           }
//                           
//                           
//                           Spacer()
//                               .frame(width: screenWidth * 0.05)
//                           
//                           VStack{
//                               Text("التاريخ")
//                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                               Spacer()
//                                   .frame(height: screenHeight * 0.02)
//                               Text(formatDate(entity.date))
//                                 .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                           }
//    
//                       }
//                       
//                   if repeatSend == false {
//                       HStack(spacing: 0) {
//                               
//                                  
//                                  // Second half with blue background
//                                  ZStack {
//                                   
//                                      
//                                      Button(action: {
//                                          
//                                          DispatchQueue.main.asyncAfter(deadline: .now() ) {
//                                              let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//                                              attendanceUploader.sendPendingAttendanceData()
//                                          }
//                                          
//                                          
//                                          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                              vmAttendaceStatus.fetchAttendaceStatus()
//                                          }
//                                         
//                                          
//                                      }){
//                                          Text("اعادة ارسال")
//                                              .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.036 : screenWidth * 0.023 ))
//                                              .foregroundColor(.white)
//                                              .padding(.all, screenWidth * 0.02)
//                                      }
//                                      
//                                  }
//                                
//                                  .frame(maxWidth: .infinity) // Takes up half of the HStack width
//                       }
//                       .background(primaryButtonColor)
//                   }
//                   
//                  
//                              
//                       
//                       
//                       
//               }
//               .frame(maxWidth: screenWidth * 0.85)
//               .padding(.top, screenHeight * 0.025)
//               .padding(.bottom, repeatSend == false ? 0 : screenHeight * 0.015)
////               .padding(.bottom, repeatSend == false ? screenHeight * 0.015 : 0 )
//                   
//                   
//                      
//                      
//                       
//                       
//               
//                   .background(Color.white)
//               .cornerRadius(5)
//               
//               
//               
//                  
//
//           }
//           .overlay{
//               //  Image("Group 124")
//                 //Text("\(orderNumber)")
//                 Circle()
//                     .fill(primaryColor)
//                     .frame(width: screenWidth * 0.06)
//                     .overlay( Text("\(orderNumber)")
//                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
//                       .foregroundColor(.white))
//                   
//                     .frame(width: screenWidth * 0.06)
//                     .position(x: screenWidth * 0.47, y: screenHeight * 0.055) // تعديل الإحداثيات
//
////                     .offset(y: repeatSend == false ? screenHeight * -0.075 : screenHeight * -0.05 )
//                
//             }
//         
//           .onAppear{
//               // تحديد إذا كان تم إرسال البيانات بناءً على قيمة الـ state
//                         if entity.state == 1 {
//                             repeatSendState = true
//                             repeatSend = true
//                         } else {
//                             repeatSendState = false
//                             repeatSend = false
//                         }
//           }
//           
//
//         
//     }
//     
//      //Formatter to display the date
//     func formatDate(_ date: Date?) -> String {
//         guard let date = date else { return "تاريخ غير متاح" }
//
//         let dateFormatter = DateFormatter()
//         dateFormatter.dateFormat = "yyyy/MM/dd hh:mm a"
//         dateFormatter.locale = Locale(identifier: "ar")
//         
//         let formattedDate = dateFormatter.string(from: date)
//             .replacingOccurrences(of: "AM", with: "صباحًا")
//             .replacingOccurrences(of: "PM", with: "مساءً")
//
//         return formattedDate
//     }
//
//     
//     
//     
//
//     
// }

//#Preview {
//    HistoryAttendance()
//        .environmentObject(AttendaceStatusViewModel())
//}


#Preview {
    let previewModel = AttendaceStatusViewModel.shared
    
    let sampleEntity = AttendaceStatus(context: previewModel.container.viewContext)
    sampleEntity.id = UUID().uuidString
    sampleEntity.numberOfStudents = "25"
    sampleEntity.date = Date()
    sampleEntity.state = 0

    previewModel.savedEntitiesAttendace.append(sampleEntity)
    
    let sampleEntity2 = AttendaceStatus(context: previewModel.container.viewContext)
    sampleEntity.id = UUID().uuidString
    sampleEntity.numberOfStudents = "25"
    sampleEntity.date = Date()
    sampleEntity.state = 1

    previewModel.savedEntitiesAttendace.append(sampleEntity2)

    return HistoryAttendance()
        .environmentObject(previewModel) // توفير EnvironmentObject في البريفيو
}

