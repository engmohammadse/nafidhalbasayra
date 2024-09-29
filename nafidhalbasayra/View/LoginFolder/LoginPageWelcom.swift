//
//  LoginPageWelcom.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/09/2024.
//

import SwiftUI

struct LoginPageWelcom: View {
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
                VStack(alignment: .trailing, spacing: geoH * 0.15) {
              
                    Text("• اهلا وسهلا بكم في تطبيق نافذ البصيرة.")
                    Text("• أعد هذا التطبيق لإدارة مشروع الدورات الصيفية.")
                    Text("• يرجى البدء بعملية تسجيل البيانات الشخصية لأستاذ الدورة.")
                    Text("• للمتابعة، يرجى الضغط على زر التالي.")
        
                }
                
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
                .padding()  // Padding inside the VStack
                .background(Color.white)  // Background color for the VStack
//                .frame(width: geoW * 0.99)  // Adjust the width as per geoW
//                .frame(height: geoH * 0.99 )
                .cornerRadius(10)  // Rounded corners (optional)
                .shadow(radius: 5)  // Add shadow (optional for style)
                .multilineTextAlignment(.trailing)  // Aligns text from right to left
                .offset(x: geoW * -0.1)
                .bold()


                       
                        
                        Spacer()
                    .frame(height: geoW * 0.05)
                        
                        // Navigation buttons
                        HStack {
                            Button(action: {
                                // Action for previous button
                            }) {
                                Text("السابق")
                            }
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            
                            
                            Button(action: {
                                // Action for next button
                            }) {
                                Text("التالي")
                            }
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
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
