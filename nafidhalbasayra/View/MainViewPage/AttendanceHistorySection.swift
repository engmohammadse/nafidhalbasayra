//
//  AttendanceHistorySection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 16/10/2024.
//

import SwiftUI

struct AttendanceHistorySection: View {
    var body: some View {
       
        VStack{
            
            ScrollView{
                
              
                VStack {
                    Color.clear
                       
                    
                    VStack {
                            
                            HStack{
                                
                                VStack{
                                    Text("المرحلة")
                                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                    Spacer()
                                        
                                        .frame(height: screenHeight * 0.02)
                                    Text("الاولى")
                                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                    
                                    
                                }
                                Spacer()
                                    .frame(width: screenWidth * 0.2)
                                
                                VStack{
                                    Text("العمر")
                                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                    Spacer()
                                        .frame(height: screenHeight * 0.02)
                                    Text("١٢ سنة")
                                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                }
                                
                                
                                Spacer()
                                    .frame(width: screenWidth * 0.2)
                                
                                VStack{
                                    Text("اسم الطالب")
                                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                    Spacer()
                                        .frame(height: screenHeight * 0.02)
                                    Text("احمد")
                                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                }
         
                            }
                            
                            HStack(spacing: 0) {
                                       // First half with red background
                                       ZStack {
                                           Color(red: 228/255, green: 194/255, blue: 194/255)
                                           
                                           
                                           Button(action: {}){
                                               Text("حذف بيانات الطالب")
                                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                                   .foregroundColor(Color(red: 123/255, green: 42/255, blue: 42/255))
                                                   .padding(.all, screenWidth * 0.02)
                                           }
                                           
                                       }
                                       
                                       .frame(maxWidth: .infinity) // Takes up half of the HStack width
                                
                                       
                                       // Second half with blue background
                                       ZStack {
                                           Color(red: 223/255, green: 239/255, blue: 242/255)
                                           
                                           Button(action: {}){
                                               Text("تعديل البيانات")
                                                   .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                                                   .foregroundColor(Color(red: 24/255, green: 82/255, blue: 100/255))
                                                   .padding(.all, screenWidth * 0.02)
                                           }
                                           
                                       }
                                     
                                       .frame(maxWidth: .infinity) // Takes up half of the HStack width
                                   }
                                   
                            
                            
                            
                    }.padding(.top, screenHeight * 0.025)
                        
                        
                           
                           
                            
                            
                    
                        .background(Color.white)
                    .cornerRadius(5)
                    
                    
                    
                       

                } .overlay{
                    Image("Group 124")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth * 0.06)
                        .offset(y: screenHeight * -0.075)
                   
                }
            
                  
               
                 
                
            }
            
        }.padding()
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
            
        
    }
}

#Preview {
    AttendanceHistorySection()
}
