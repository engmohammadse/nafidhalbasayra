//
//  register.swift
//  nafidhalbasayra
//
//  Created by muhammad on 09/10/2024.
//

import SwiftUI

struct registerPage3: View {
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack {
            
            Image("Group 3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: uiDevicePhone ? screenHeight * 0.085 : screenHeight * 0.085)
            Spacer()
                .frame(height: screenHeight * 0.05)
            
            VStack{
                Text("تجري مراجعة بياناتك، يرجى الانتظار قد يستغرق الامر بضع ساعات سيصلك اشعار بمجرد انتهاء مراجعة بياناتك")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .multilineTextAlignment(.center)
                    
                   
            }
            .padding()
            .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
            .cornerRadius(5)
            
            
          
             
        }
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
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
    registerPage3()
        .environmentObject(TeacherDataViewModel())
}
