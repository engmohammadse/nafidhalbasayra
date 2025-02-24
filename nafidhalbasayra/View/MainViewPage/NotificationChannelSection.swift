//
//  NotificationChannelSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//

import SwiftUI

struct NotificationChannelSection: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var notificationVM = NotificationViewModel()
    @State private var showInternetAlert = false  // متغير لإظهار التنبيه عند عدم وجود الانترنت
    @State private var alertInternetMessage = ""  // لتخزين الرسالة عند عدم وجود الانترنت
    
    var body: some View {
        VStack {
            // التنبيه إذا كانت حالة الانترنت غير متاحة
            
           
            
            if showInternetAlert {
                
                Spacer()
                    .frame(height: screenHeight * 0.2)
                
                VStack {
                  
                    
                    Text("❌ لا يوجد اتصال بالإنترنت.")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                        .foregroundColor(.red)
                        .padding()
                    
                    Text(alertInternetMessage)
                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                        .foregroundColor(.red)
                        .padding()
                    
                    Button(action: {
                        notificationVM.fetchNotifications()
                        
                        InternetChecker.isInternetAvailable { isAvailable in
                            DispatchQueue.main.async {
                                if isAvailable {
                                    self.showInternetAlert = false // إخفاء التنبيه

                                }
                            }
                        }

                        

                    }) {
                        Text("حاول مجددًا")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                            .foregroundColor(.white)
                            .padding()
                            .background(primaryButtonColor)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                

            }
            
            ScrollView {
                Spacer()
                    .frame(height: screenHeight * 0.1)
                
                ForEach(notificationVM.notifications) { notification in
                    MessageView(
                        titleMessage: notification.title,
                        bodyMessage: notification.body,
                        MessageSender: notification.sender,
                        dateMessage: formatDate(notification.createdAt)
                    )
                    
                    Spacer().frame(height: screenHeight * 0.05)
                }
            } 
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير

//                .background(backgroundColorPage)
        }
        .padding(.horizontal, screenWidth * 0.1)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            notificationVM.fetchNotifications()
            
            InternetChecker.isInternetAvailable { isAvailable in
                DispatchQueue.main.async {
                    
                    if !isAvailable {
                        showInternetAlert = true
                    }
                    
                }
                
            }
        }
        .overlay {
            ZStack {
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
    }
    
    // دالة لتنسيق التاريخ من ISO8601 إلى تاريخ قابل للقراءة
    func formatDate(_ isoDate: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy/MM/dd  h:mm a"
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}

#Preview {
    NotificationChannelSection()
}




//import SwiftUI
//
//struct NotificationChannelSection: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var notificationVM = NotificationViewModel()
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                Spacer().frame(height: screenHeight * 0.1)
//                
//                ForEach(notificationVM.notifications) { notification in
//                    MessageView(
//                        titleMessage: notification.title,
//                        bodyMessage: notification.body,
//                        MessageSender: notification.sender,
//                        dateMessage: formatDate(notification.createdAt)
//                    )
//                    
//                    Spacer().frame(height: screenHeight * 0.05)
//                }
//            }
//        }
//        .padding(.horizontal, screenWidth * 0.1)
//        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            notificationVM.fetchNotifications()
//        }
//        .overlay(LogoIUserInfo().offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0))
//        .overlay {
//            ZStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image("Group 56")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
//                }
//                .offset(x: screenWidth * 0.46, y: screenHeight * 0)
//            }
//        }
//    }
//    
//    // دالة لتنسيق التاريخ من ISO8601 إلى تاريخ قابل للقراءة
//    func formatDate(_ isoDate: String) -> String {
//        let dateFormatter = ISO8601DateFormatter()
//        if let date = dateFormatter.date(from: isoDate) {
//            let displayFormatter = DateFormatter()
//            displayFormatter.dateFormat = "yyyy/MM/dd  h:mm a"
//            return displayFormatter.string(from: date)
//        }
//        return isoDate
//    }
//}

#Preview {
    NotificationChannelSection()
}






struct MessageView: View {
    var titleMessage: String
    var bodyMessage: String
    var MessageSender: String
    var dateMessage: String

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(titleMessage)
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
            }

            Spacer().frame(height: screenHeight * 0.03)

            Text(bodyMessage)
                .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))

            Spacer().frame(height: screenHeight * 0.03)

            HStack {
                Spacer()
                Text(MessageSender)
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.031 : screenWidth * 0.023))
            }

            HStack {
                Text(dateMessage)
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                Spacer()
            }
            .offset(x: screenWidth * -0.05, y: screenHeight * 0.01)
        }
        .padding(.horizontal, screenWidth * 0.09)
        .padding(.vertical, screenHeight * 0.025)
        .multilineTextAlignment(.trailing)
        .background(Color.white)
        .cornerRadius(5)
        .navigationBarBackButtonHidden(true)
    }
}










//import SwiftUI
//
//struct NotificationChannelSection: View {
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        
//        VStack{
//            ScrollView{
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.1)
//                
//                message(titleMessage:  "عنوان الرسالة", bodyMessage:  "وقد شهدت أروقة جامعة القادسيّة أولى هذه الجلسات التي انعقدت في  مبادئ الشريعة الإسلاميّة .", MessageSender:  "مرسل الرسالة", dateMessage: "2024/4/16  10:42 AM")
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.05)
//                
//                message(titleMessage:  "عنوان الرسالة", bodyMessage:  "وقد شهدت أروقة جامعة القادسيّة أولى هذه الجلسات التي انعقدت في الأقسام الداخلية بحضور عدد كبير من الطلبة، إذ قدّم المحاضرة إذ قدّم المحاضرة الشيخ حيدر اليونسيّ، متناولًا فيها أهمّيّة التغيير الإيجابيّ، وضرورة اتّباع السلوك القويم المتوافق مع مبادئ الشريعة الإسلاميّة .", MessageSender:  "مرسل الرسالة", dateMessage: "2024/4/16  10:42 AM")
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.05)
//                
//                message(titleMessage:  "عنوان الرسالة", bodyMessage:  "وقد شهدت أروقة جامعة القادسيّة أولى هذه الجلسات التي انعقدت في  مبادئ الشريعة الإسلاميّة .", MessageSender:  "مرسل الرسالة", dateMessage: "2024/4/16  10:42 AM")
//
//                
//                
//                
//            }
//        }
//        .padding(.horizontal, screenWidth * 0.1)
//           
//        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//        .overlay(
//           LogoIUserInfo()
//               .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0))
//        .overlay{
//            ZStack{
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image("Group 56")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
//                }
//                .offset(x: screenWidth * 0.46, y: screenHeight * 0)
//            }
//        }
//        
//        
//    }
//}
//
//#Preview {
//    NotificationChannelSection()
//}
//
//
//struct message: View {
//    @State  var titleMessage: String
//    @State  var bodyMessage: String
//    @State  var MessageSender: String
//    @State  var dateMessage: String
//    
//    var body: some View {
//        
//        VStack {
//        
//            HStack{
//                Spacer()
//                Text(titleMessage)
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
//              
//        
//            }
//            Spacer()
//                .frame(height: screenHeight * 0.03)
//        
//           Text(bodyMessage)
//                .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//          
//        
//            Spacer()
//                .frame(height: screenHeight * 0.03)
//        
//            HStack {
//                Spacer()
//                Text(MessageSender)
//                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.031 : screenWidth * 0.023 ))
//               
//            }
//        
//        
//            HStack {
//        
//                Text(dateMessage)
//                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//               
//                Spacer()
//            }
//            .offset(x: screenWidth * -0.05, y: screenHeight * 0.01)
//        }
//        
//        .padding(.horizontal,screenWidth * 0.09)
//        .padding(.vertical,screenHeight * 0.025)
//            .multilineTextAlignment(.trailing)
//            .background(Color.white)
//            .cornerRadius(5)
//        
//            .navigationBarBackButtonHidden(true)
//        
//    }
//}
//
//    
