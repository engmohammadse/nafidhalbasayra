//
//  UserManual.swift
//  nafidhalbasayra
//
//  Created by muhammad on 19/10/2024.
//

import SwiftUI


struct UserManual: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var guideVM = GuideViewModel() // 🔹 جلب البيانات

    var body: some View {
        VStack {
            ScrollView {
                Spacer()
                    .frame(height: screenHeight * 0.1)

                // 🔹 عرض البيانات باستخدام ForEach
                ForEach(Array(guideVM.guides.enumerated()), id: \.element._id) { index, guide in
                    guidInfo(index: index, title: guide.title, description: guide.description, youtubeURL: guide.youtube_url)
                }
            }
            .padding(.all, screenWidth * 0.1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير

        }
        .background(backgroundColorPage)
        .onAppear {
            guideVM.fetchGuides() // جلب البيانات عند فتح الصفحة
        }
        .overlay {
            ZStack {
                Button(action: { dismiss() }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
    }
}




struct guidInfo: View {
    var index: Int  // رقم تسلسلي لكل عنصر
    var title: String
    var description: String
    var youtubeURL: String

    var body: some View {
        VStack {
            Color.clear
            VStack {
                Text(title)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.033 : screenWidth * 0.023))
                    .foregroundStyle(primaryColor)

                Spacer()
                    .frame(height: screenHeight * 0.01)

                Text(description)
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.028 : screenWidth * 0.023))
                    .foregroundStyle(primaryColor)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, screenWidth * 0.02)

                Spacer()
                    .frame(height: screenHeight * 0.01)

                HStack {
                    Link(destination: URL(string: youtubeURL)!) {
                        Text("مشاهدة الفيديو على يوتيوب")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                            .foregroundStyle(primaryColor)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.all, screenWidth * 0.015)
                .background(buttonAccentColor)
            }
            .padding(.top, screenHeight * 0.02)
            .background(Color.white)
            .cornerRadius(5)
            .overlay {
                // 🔹 إضافة دائرة تحتوي على رقم الدليل بدل الصورة
                Text("\(index + 1)")  // يبدأ من 1 بدلاً من 0
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.035))
                    .foregroundColor(.white)
                    .frame(width: screenWidth * 0.08, height: screenWidth * 0.08)
                    .background(primaryColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(y: screenHeight * -0.065)
            }
        }
    }
}




















//struct UserManual: View {
//    
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        
//        
//        VStack{
//            
//            ScrollView{
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.1)
//                
//                
//                guidInfo()
//                guidInfo()
//                guidInfo()
//                
//            }
//            .padding(.all, screenWidth * 0.1)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//          
//            
//        }
//        .background(backgroundColorPage)
//        
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
//                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
//            }
//        }
//        
//        .overlay {
//            LogoIUserInfo()
//                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
//        }
//        
//        .navigationBarBackButtonHidden(true)
//        
//        
//        
//        
//        
//    }
//}
//
//#Preview {
//    UserManual()
//}
//
//
//
//
//struct guidInfo: View {
//    var body: some View {
//        VStack {
//            Color.clear
//            VStack{
//                
//                Text("كيفية رفع موقف حضور الطلبة")
//                    .multilineTextAlignment(.trailing)
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.033 : screenWidth * 0.023 ))
//                    .foregroundStyle(primaryColor)
//                    
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.01)
//                
//                
//                Text("فيديو تعليمي عن كيفية رفع الحضور اليومي للطلبة في الدورة")
//                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.028 : screenWidth * 0.023 ))
//                    .foregroundStyle(primaryColor)
//                    .multilineTextAlignment(.trailing)
//                    .padding(.horizontal, screenWidth * 0.02)
//                Spacer()
//                    .frame(height: screenHeight * 0.01)
//                
//                HStack{
//                    Button(action: {}){
//                        Text("مشاهدة الفيديو على يوتيوب")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
//                            .foregroundStyle(primaryColor)
//                            .frame(maxWidth: .infinity)
//                    }
//                }
//                //.frame(width: screenWidth * 0.8)
//               
//                .padding(.all, screenWidth * 0.015)
//                .background(buttonAccentColor)
//            }
//            .padding(.top, screenHeight * 0.02)
//            .background(Color.white)
//            .cornerRadius(5)
//            .overlay{
//                Image("Group 124")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: screenWidth * 0.06)
//                    .offset(y: screenHeight * -0.065)
//               
//        }
//        }
//        
//        
//    }
//}
