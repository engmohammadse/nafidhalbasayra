//
//  registerPage5.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct registerPage5: View {
    
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
                Text("عذرا بيناتك غير دقيقة")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .multilineTextAlignment(.center)

                    .foregroundStyle(Color(red: 160 / 255, green: 70 / 255, blue: 70 / 255))
                   
            }
            .padding()
            .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8 )
            .background(Color(red: 234 / 255, green: 225 / 255, blue: 225 / 255))
            .cornerRadius(5)
            
            Spacer()
                .frame(height: screenHeight * 0.03)
            
            Button(action: {
                
            }){
                Text("اعادة ادخال البيانات")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.02))
                    .frame(height: screenHeight * 0.04)
                    .foregroundColor(.white)
                    .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.8 )
            }
            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
            .cornerRadius(5)
            
             
        }
        .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
        }
}

#Preview {
    registerPage5()
        .environmentObject(TeacherDataViewModel())
}
