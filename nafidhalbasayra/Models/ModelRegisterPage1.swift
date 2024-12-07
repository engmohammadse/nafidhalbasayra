//
//  ModelRegisterPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 07/12/2024.
//

import Foundation

import SwiftUI

struct PreviousNextButtonRegisterPage1<Destination: View>: View {
    var geoW: CGFloat
    var geoH: CGFloat
    var destination: Destination // الوجهة التي ننتقل إليها
    var color: Color
    var imageName: String
    var shouldNavigate: Bool // شرط الانتقال
    var notEmptyFields: Bool
    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    @Environment(\.dismiss) var dismiss // العودة للصفحة السابقة
    
    var body: some View {
        NavigationStack {
            HStack {
                // Previous button icon
            

                // Previous button (Button to dismiss and go back)
                Button(action: {
                    dismiss() // العودة إلى الصفحة السابقة
                }) {
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.04)
                        .padding(.vertical, geoH * 0.01)
                        .padding(.leading, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                        .foregroundColor(color)
                    
                    Text("السابق")
                        .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                        .foregroundColor(color)
                }
                .padding(.horizontal, geoW * 0.001)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Divider line
                Image("Line 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geoH * 0.01, height: geoH * 0.03)
                    .padding(.vertical, geoH * 0.008)
                
                
             

                // Next button with conditional navigation
                if shouldNavigate && notEmptyFields { // شرط الانتقال
                    NavigationLink(destination: destination) {
                        Text("التالي")
                            .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                            .padding(.horizontal, geoW * 0.001)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        
                        
                        Image("Group 16")
                                      .resizable()
                                      .aspectRatio(contentMode: .fit)
                                      .frame(maxWidth: geoW * 0.04)
                                      .padding(.vertical, geoH * 0.01)
                                      .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                        
                    }
                } else {
                    // حالة غير مفعلّة عند عدم تحقق الشرط
                    
                       
                    
                    Button(action: {
                        
                        if teacherData.checkCityCodeRP1() == false {
                            teacherData.showAlertCityInRP1NOTEquall = true
                        }
                        
                        if teacherData.showAlertCityInRP1NOTEquall == false {
                            
                            if teacherData.checkFieldEmpty() == false {
                                teacherData.showEmptyAlertFieldRP1 = true
                            }
                        }
                        
                       
                        
                     
                        
                        
                    }) {
                        Text("التالي")
                            .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                            .foregroundColor(color)
                            .padding(.horizontal, geoW * 0.001)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .padding(.vertical, geoH * 0.01)
                    }
                    .padding(.horizontal, geoW * 0.001)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    
                    Image("Group 16")
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .frame(maxWidth: geoW * 0.04)
                                  .padding(.vertical, geoH * 0.01)
                                  .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                    
                    
                    
                }
                
                
                
                
                
            }
         
            .background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
            .cornerRadius(5)
            .padding()
        }
    }
}
