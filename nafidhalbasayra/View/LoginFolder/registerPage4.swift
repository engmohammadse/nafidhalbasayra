//
//  registerPage4.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct registerPage4: View {
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack {
            
            Image("Group 3")
            Spacer()
                .frame(height: screenHeight * 0.05)
            
            VStack{
                Text("تمت قبول طلب التسجيل، يمكنك استخدام التطبيق")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                    .multilineTextAlignment(.center)
                   
            }
            .padding()
            .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
            .cornerRadius(5)
            
            Spacer()
                .frame(height: screenHeight * 0.03)
            
            Button(action: {
                
            }){
                Text("بدء استخدام التطبيق")
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.03))
                    .frame(height: screenHeight * 0.04)
                    .foregroundColor(.white)
                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.62 : screenWidth * 0.5)
            }
            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
            .cornerRadius(5)
            
             
        }
        .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236/255, green: 242/255, blue: 245/255))
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
        }
}

#Preview {
    registerPage4()
}

