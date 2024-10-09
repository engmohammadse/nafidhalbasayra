//
//  registerPage2.swift
//  nafidhalbasayra
//
//  Created by muhammad on 09/10/2024.
//

import SwiftUI

struct registerPage2: View {
    @State private var isPressed = false
    
    
    
    var body: some View {
        
        
        VStack{
            
            VStack{
                Image("Group 120")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth * 0.7)
                
                Button(action: {
//                    isPressed.toggle()
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        showError.toggle()
//                    }
//                    // Navigate to the next screen upon successful login
//                    isNavigate = true
                }) {
                    Text("تسجيل الدخول")
                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                        .frame(height: screenHeight * 0.05)
                        .foregroundColor(.white)
                        .frame(maxWidth: screenWidth * 0.7)
                }
                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .cornerRadius(5)
            }
            
            Spacer()
                .frame(height: screenHeight * 0.05)
            
            VStack{
                Image("Group 121")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth * 0.7)
                
                Button(action: {
//                    isPressed.toggle()
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        showError.toggle()
//                    }
//                    // Navigate to the next screen upon successful login
//                    isNavigate = true
                }) {
                    Text("تسجيل الدخول")
                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                        .frame(height: screenHeight * 0.05)
                        .foregroundColor(.white)
                        .frame(maxWidth: screenWidth * 0.7)
                }
                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .cornerRadius(5)
            }
            
            
            Spacer()
                .frame(height: screenHeight * 0.05)
            
            VStack{
                Image("Group 122")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth * 0.7)
                
                Button(action: {
//                    isPressed.toggle()
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        showError.toggle()
//                    }
//                    // Navigate to the next screen upon successful login
//                    isNavigate = true
                }) {
                    Text("تسجيل الدخول")
                        .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                        .frame(height: screenHeight * 0.05)
                        .foregroundColor(.white)
                        .frame(maxWidth: screenWidth * 0.7)
                }
                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .cornerRadius(5)
            }
            
            
       
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236/255, green: 242/255, blue: 245/255))
        
       
        
        
    }
}

#Preview {
    registerPage2()
}
