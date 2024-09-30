//
//  LoginPageWelcom.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/09/2024.
//

import SwiftUI

struct LoginPageWelcom: View {
    
  
    
    @State  private var isNavigate: Bool = false
    
    
    var body: some View {
        
       
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
            let geoW = geometry.size.width
            
            VStack {
                Spacer()
            .frame(height: geoW * 0.05)
                        // Header text
                       
//                            .font(.headline)
//                            .foregroundColor(.blue)
//                            .multilineTextAlignment(.center)
//                            .padding(.bottom, 10)
                        
                        // Description text in bullet points
                VStack(alignment: .trailing, spacing: geoH * 0.1) {
              
                    Text("• اهلا وسهلا بكم في تطبيق نافذ البصيرة.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)
                    
                    
                    Text("• أعد هذا التطبيق لإدارة مشروع الدورات الصيفية.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)
                    
                    Text("• يرجى البدء بعملية تسجيل البيانات الشخصية لأستاذ الدورة.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)

                    Text("• للمتابعة، يرجى الضغط على زر التالي.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)
        
                }
                
                .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.05 : geoW * 0.03))
         
                .padding()  // Padding inside the VStack
                
                .background(Color.white)  // Background color for the VStack
//                .frame(width: geoW * 0.99)  // Adjust the width as per geoW
//                .frame(height: geoH * 0.99 )
                .cornerRadius(5)  // Rounded corners (optional)
                .shadow(radius: 5)  // Add shadow (optional for style)
                .multilineTextAlignment(.trailing)  // Aligns text from right to left
                .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? geoW * -0.11 : geoW * -0.15)
                //.bold()


                       
                        
                        Spacer()
                    .frame(height: geoW * 0.05)
                        
                        // Navigation buttons
                        HStack {
                            
                            Image("Group 9")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: geoW * 0.05)
                                .padding(.vertical, geoH * 0.01)
                                .padding(.leading, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.05: geoW * 0.025)
                            
                            
                            
                            Button(action: {
                                // Action for previous button
                            }) {
                                Text("السابق")
                                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
                                    .foregroundStyle(Color(UIColor(red: 90 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1.0))
)
                            }
                            .padding(.horizontal, geoW * 0.005)
                           // .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Image("Line 1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geoH * 0.01 ,height: geoH * 0.04)
                                .padding(.vertical, geoH * 0.01)
                            
                            Button(action: {
                                // Action for next button
                                
                                isNavigate = true
                            }) {
                                Text("التالي")
                                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
                            }
                            .padding(.horizontal, geoW * 0.005)
                           // .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .navigationDestination(isPresented: $isNavigate) {
                                registerPage()
                            }
                            
                            
                            Image("Group 16")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: geoW * 0.05)
                                .padding(.vertical, geoH * 0.01)
                                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.05: geoW * 0.025 )
                            
                            
                            
                        }
                        .background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
                        .cornerRadius(5)
                        .padding()
                       // .padding(.bottom, 20)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                   
        }
    }
}

#Preview {
    LoginPageWelcom()
}
