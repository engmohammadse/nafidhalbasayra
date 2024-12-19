//
//  LogoIUserDetails.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//

import SwiftUI

struct LogoIUserInfo: View {
    
   // @ObservedObject var teacherData: TeacherDataViewModel
    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            let geoW = geometry.size.width
            
                HStack{
  
                    // عرض الصورة إذا كانت موجودة
                         if let image = teacherData.profileimage {
                             Image(uiImage: image)
                                 .resizable()
                                 .scaledToFit()
                                 .frame(maxWidth: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.1  : screenWidth * 0.2) : screenWidth * 0.2)
                         
                                 .clipShape(Circle())
                         }
         
                         else {
                           
                             Image("Group 63")
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(maxWidth: geoW * 0.07)
                             
                         }
                    
                    
                    
                    
                        Text(teacherData.userName ?? "user1212")
                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, geoW * 0.04)
                            .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                            .cornerRadius(5)
                  
                    
                    
                    
                  
                    
                    
                        Spacer()
                      
                    
                    Image("Group 1")
                        .resizable()
                        .renderingMode(.template)  // Forces the image to be drawn as a template (grayscale)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.42 )
                        .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                        .padding(.bottom, 10)
                }
                .padding(.horizontal, 40)
                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
             
                    
            
            
        }
    }
}

//#Preview {
//    LogoIUserInfo()
//            .environmentObject(TeacherDataViewModel())
//}


#Preview {
    // استخدام نفس التهيئة مثلما تستخدمها في التطبيق الفعلي
    let teacherData = TeacherDataViewModel()   // نفس التهيئة كما في @StateObject
    let vmAttendaceStatus = AttendaceStatusViewModel()

    return LogoIUserInfo()
        .environmentObject(teacherData)   // تمرير الـ environmentObject في الـ Preview
        .environmentObject(vmAttendaceStatus)  // إذا كنت بحاجة إليه هنا
}

