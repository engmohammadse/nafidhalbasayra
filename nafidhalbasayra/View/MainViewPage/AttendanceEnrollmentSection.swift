//
//  AttendanceEnrollmentSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 19/10/2024.
//

import SwiftUI

struct AttendanceEnrollmentSection: View {
    
    
    
    var body: some View {
        
         VStack{
             HStack{
                 
                 Text("عدد مرات تسجيل الحضور: 25")
                     .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                     .padding(.all, screenWidth * 0.025)
             }
             .background(.white)
             .cornerRadius(5)
             .offset(x: screenWidth * 0.17 ,y: screenHeight * 0.05)
             
             Spacer()
                 .frame(height: screenHeight * 0.07)
             ScrollView {
         
                 studentEnrollment()
                 studentEnrollment()
                 studentEnrollment()
                 
                 
             }
             .frame(maxWidth: .infinity)
             
             
           
             
             
             
         }
         .padding()
         .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
         .overlay{
             LogoIUserInfo()
                 .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
              
         }
     
         
         
         
         .overlay{
             ZStack{
                 Button(action: {}) {
                     Image("Group 56")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
                 }
                 .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
             }
         }
         
             
         
     }
 }










 struct studentEnrollment :View {
     @State private var repeatSend : Bool = false
     
     
     
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
                               Text("مرسل")
                                   .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               
                               
                           }
                           Spacer()
                               .frame(width: screenWidth * 0.1)
                           
                           VStack{
                               Text("الطلبة الحاضرين")
                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               Spacer()
                                   .frame(height: screenHeight * 0.02)
                               Text("24")
                                   .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                           }
                           
                           
                           Spacer()
                               .frame(width: screenWidth * 0.1)
                           
                           VStack{
                               Text("التاريخ")
                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                               Spacer()
                                   .frame(height: screenHeight * 0.02)
                               Text("2024/10/3")
                                   .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                           }
    
                       }
                       
                   if repeatSend {
                       HStack(spacing: 0) {
                               
                                  
                                  // Second half with blue background
                                  ZStack {
                                      Color(red: 223/255, green: 239/255, blue: 242/255)
                                      
                                      Button(action: {}){
                                          Text("اعادة ارسال")
                                              .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                                              .foregroundColor(Color(red: 24/255, green: 82/255, blue: 100/255))
                                              .padding(.all, screenWidth * 0.02)
                                      }
                                      
                                  }
                                
                                  .frame(maxWidth: .infinity) // Takes up half of the HStack width
                              }
                   }
                   
                  
                              
                       
                       
                       
               }
               .frame(maxWidth: screenWidth * 0.85)
               .padding(.top, screenHeight * 0.025)
               .padding(.bottom, repeatSend == false ? screenHeight * 0.02 : 0 )
                   
                   
                      
                      
                       
                       
               
                   .background(Color.white)
               .cornerRadius(5)
               
               
               
                  

           } .overlay{
               Image("Group 124")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: screenWidth * 0.06)
               
               //screenHeight * -0.075
                   .offset(y: repeatSend == false ? screenHeight * -0.055 : screenHeight * -0.075 )
              
           }
         
         
     }
 }

#Preview {
    AttendanceEnrollmentSection()
}
