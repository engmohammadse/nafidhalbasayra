//
//  NotificationChannelSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//


import SwiftUI

struct NotificationChannelSection: View {
    @Environment(\.dismiss) var dismiss
    @State private var showInternetAlert = false
    @State private var alertInternetMessage = ""

    @StateObject private var coreDataNotificationVM = CoreDataNotificationViewModel.shared

    var body: some View {
        VStack {
         
            ScrollView {
                Spacer().frame(height: uiDevicePhone ? screenHeight * 0.1 : screenHeight * 0.2)

                ForEach(coreDataNotificationVM.savedEntitiesNotification.reversed()) { notification in
                    MessageView(
                        titleMessage: notification.title ?? "",
                        bodyMessage: notification.body ?? "",
                        MessageSender: notification.sender ?? "",
                        dateMessage: formatDate(notification.date ?? "")
                    )
                    Spacer().frame(height: screenHeight * 0.05)
                }
            }

            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, screenWidth * 0.1)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            InternetChecker.isInternetAvailable { isAvailable in
                DispatchQueue.main.async {
                    if isAvailable {
                        let fetcher = FetchAndStoreNotificationsFromAPI(database: coreDataNotificationVM)
                        Task {
                            await fetcher.fetchAndStoreNotifications()
                        }
                        
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

    func formatDate(_ isoDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        if let date = dateFormatter.date(from: isoDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let formattedDate = dateFormatter.string(from: date)

            let periodFormatter = DateFormatter()
            periodFormatter.dateFormat = "a"
            periodFormatter.locale = Locale(identifier: "en_US")

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm"
            timeFormatter.locale = Locale(identifier: "en_US")

            let formattedTime = timeFormatter.string(from: date)
            let period = periodFormatter.string(from: date)
                .replacingOccurrences(of: "AM", with: "صباحًا")
                .replacingOccurrences(of: "PM", with: "مساءً")

            return "\(period)   \(formattedTime)   \(formattedDate)"
        }

        return "تاريخ غير متاح"
    }
}









//import SwiftUI
//
//struct NotificationChannelSection: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var notificationVM = NotificationViewModel()
//    @State private var showInternetAlert = false  // متغير لإظهار التنبيه عند عدم وجود الانترنت
//    @State private var alertInternetMessage = ""  // لتخزين الرسالة عند عدم وجود الانترنت
//    
//    
//    
//  
//    var body: some View {
//        VStack {
//            // التنبيه إذا كانت حالة الانترنت غير متاحة
//            
//           
//            
//            if showInternetAlert {
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.2)
//                
//                VStack {
//                  
//                    
//                    Text("❌ لا يوجد اتصال بالإنترنت.")
//                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
//                        .foregroundColor(.red)
//                        .padding()
//                    
//                    Text(alertInternetMessage)
//                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
//                        .foregroundColor(.red)
//                        .padding()
//                    
//                    Button(action: {
//                        notificationVM.fetchNotifications()
//                        
//                        InternetChecker.isInternetAvailable { isAvailable in
//                            DispatchQueue.main.async {
//                                if isAvailable {
//                                    self.showInternetAlert = false // إخفاء التنبيه
//
//                                }
//                            }
//                        }
//
//                        
//
//                    }) {
//                        Text("حاول مجددًا")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(primaryButtonColor)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//                }
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//                .padding()
//                
//
//            }
//            
//            ScrollView {
//                Spacer()
//                    .frame(height: uiDevicePhone ? screenHeight * 0.1 : screenHeight * 0.2)
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
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير
//
////                .background(backgroundColorPage)
//        }
//        .padding(.horizontal, screenWidth * 0.1)
//        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//        .overlay {
//            LogoIUserInfo()
//                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
//        }
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            notificationVM.fetchNotifications()
//            
//            InternetChecker.isInternetAvailable { isAvailable in
//                DispatchQueue.main.async {
//                    
//                    if !isAvailable {
//                        showInternetAlert = true
//                    }
//                    
//                }
//                
//            }
//        }
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
//                .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
//            }
//        }
//    }
//    
//    func formatDate(_ isoDate: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ✅ تطابق تنسيق API
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // ✅ التأكد من التنسيق القياسي
//        dateFormatter.calendar = Calendar(identifier: .gregorian) // ✅ استخدام التقويم الميلادي
//
//        if let date = dateFormatter.date(from: isoDate) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy/MM/dd" // ✅ تنسيق التاريخ فقط
//            let formattedDate = dateFormatter.string(from: date)
//
//            let periodFormatter = DateFormatter()
//            periodFormatter.dateFormat = "a" // ✅ استخراج AM/PM فقط
//            periodFormatter.locale = Locale(identifier: "en_US")
//
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = "hh:mm" // ✅ استخراج الوقت فقط بدون AM/PM
//            timeFormatter.locale = Locale(identifier: "en_US")
//
//            let formattedTime = timeFormatter.string(from: date)
//            let period = periodFormatter.string(from: date)
//                .replacingOccurrences(of: "AM", with: "صباحًا")
//                .replacingOccurrences(of: "PM", with: "مساءً") // ✅ استبدال AM/PM باللغة العربية
//
//            return "\(period)   \(formattedTime)   \(formattedDate)" // ✅ التاريخ على اليسار، صباحًا/مساءً في المنتصف، الوقت على اليمين
//        }
//
//        return "تاريخ غير متاح"
//    }
//
//
//
//
//
//
//}

//#Preview {
//    NotificationChannelSection()
//}





import SwiftUI

struct MessageView: View {
    var titleMessage: String
    var bodyMessage: String
    var MessageSender: String
    var dateMessage: String

    var body: some View {
        VStack(alignment: .trailing, spacing: screenHeight * 0.015) { // ✅ تنظيم المسافات
            
            // 🏷️ **عنوان الرسالة**
            HStack {
                Spacer()
                Text("\(titleMessage)  📜") // ✅ إضافة الرمز التعبيري
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                    .foregroundColor(.black)
            }
            
            // 📜 **نص الرسالة**
            HStack(alignment: .top) {
                Spacer()
                Text("\(bodyMessage)") // ✅ إضافة الرمز التعبيري
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                    .foregroundColor(.black.opacity(0.8))
            }

            // 🖊️ **المرسل**
            HStack {
                Spacer()
                Text("\(MessageSender)  🖊️ ") // ✅ إضافة الرمز التعبيري
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.031 : screenWidth * 0.023))
                    .foregroundColor(.gray)
            }

            // 📅 **التاريخ والوقت**
            HStack {
                Text("📅   \(dateMessage)") // ✅ إضافة الرمز التعبيري
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                    .foregroundColor(.gray)
                Spacer()
            }

        }
        .padding(.horizontal, screenWidth * 0.08)
        .padding(.vertical, screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: 10) // ✅ إطار منحني أكثر أناقة
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2) // ✅ إضافة ظل ناعم
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10) // ✅ طبقة إضافية شفافة لمظهر زجاجي
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .multilineTextAlignment(.trailing)
        .navigationBarBackButtonHidden(true)
    }
}

