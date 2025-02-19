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
                     .padding(.all, screenWidth * 0.025)
             }
             .background(.white)
             .cornerRadius(5)
             .offset(x: screenWidth * 0.17 ,y: screenHeight * 0.05)
             
             Spacer()
                 .frame(height: screenHeight * 0.07)

             ScrollView { ForEach(Array(vmAttendaceStatus.savedEntitiesAttendace.enumerated()),id: \.element) { index, entity in
                 studentHistory(entity: entity, orderNumber: index + 1) }
             }
             
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
                 .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
             }
         }
         .navigationBarBackButtonHidden(true)
         
             
         
     }
 }










 struct studentHistory :View {
     @State private var repeatSend : Bool = false
     @State private var repeatSendState : Bool = false

     @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
     var entity: AttendaceStatus
     var orderNumber: Int
     
     
     
     var body: some View {
         
         
         
           VStack {
               
       
               
               
               Color.clear
                  
               
               VStack {
                       
                       HStack{
                           
                           VStack{
                               Text("الحالة")
                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               Spacer()
                                   
                                   .frame(height: screenHeight * 0.02)
                              
                                  
                               if repeatSendState == true {
                                   Text("مرسل")
                                       .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               } else {
                                   Text("غير مرسل")
                                       .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                       .foregroundStyle(redColorFalse)
                               }
                               
                               
                           }
                           Spacer()
                               .frame(width: screenWidth * 0.1)
                           
                           VStack{
                               Text("الطلبة الحاضرين")
                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               Spacer()
                                   .frame(height: screenHeight * 0.02)
                               Text(entity.numberOfStudents ?? "no")
                                   .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                           }
                           
                           
                           Spacer()
                               .frame(width: screenWidth * 0.05)
                           
                           VStack{
                               Text("التاريخ")
                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               Spacer()
                                   .frame(height: screenHeight * 0.02)
                               Text("\(entity.date ?? Date(), formatter: studentHistory.dateFormatter)") .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                           }
    
                       }
                       
                   if repeatSend == false {
                       HStack(spacing: 0) {
                               
                                  
                                  // Second half with blue background
                                  ZStack {
                                   
                                      
                                      Button(action: {
                                          
                                          DispatchQueue.main.asyncAfter(deadline: .now() ) {
                                              let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
                                              attendanceUploader.sendPendingAttendanceData()
                                          }
                                          
                                          
                                          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                              vmAttendaceStatus.fetchAttendaceStatus()
                                          }
                                         
                                          
                                      }){
                                          Text("اعادة ارسال")
                                              .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.036 : screenWidth * 0.023 ))
                                              .foregroundColor(.white)
                                              .padding(.all, screenWidth * 0.02)
                                      }
                                      
                                  }
                                
                                  .frame(maxWidth: .infinity) // Takes up half of the HStack width
                       }
                       .background(primaryButtonColor)
                   }
                   
                  
                              
                       
                       
                       
               }
               .frame(maxWidth: screenWidth * 0.85)
               .padding(.top, screenHeight * 0.025)
               .padding(.bottom, repeatSend == false ? 0 : screenHeight * 0.015)
//               .padding(.bottom, repeatSend == false ? screenHeight * 0.015 : 0 )
                   
                   
                      
                      
                       
                       
               
                   .background(Color.white)
               .cornerRadius(5)
               
               
               
                  

           }
           .overlay{
               //  Image("Group 124")
                 //Text("\(orderNumber)")
                 Circle()
                     .fill(primaryColor)
                     .frame(width: screenWidth * 0.06)
                     .overlay( Text("\(orderNumber)")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                       .foregroundColor(.white))
                   
                     .frame(width: screenWidth * 0.06)
                     .offset(y: repeatSend == false ? screenHeight * -0.075 : screenHeight * -0.05 )
                
             }
         
           .onAppear{
               // تحديد إذا كان تم إرسال البيانات بناءً على قيمة الـ state
                         if entity.state == 1 {
                             repeatSendState = true
                             repeatSend = true
                         } else {
                             repeatSendState = false
                             repeatSend = false
                         }
           }
           

         
     }
     
      //Formatter to display the date
     static var dateFormatter: DateFormatter {
         let formatter = DateFormatter()
         formatter.dateStyle = .short
         return formatter
     }
     
 }

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

    return HistoryAttendance()
        .environmentObject(previewModel) // توفير EnvironmentObject في البريفيو
}

