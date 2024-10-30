//
//  UserManual.swift
//  nafidhalbasayra
//
//  Created by muhammad on 19/10/2024.
//

import SwiftUI

struct UserManual: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        VStack{
            
            ScrollView{
                
                Spacer()
                    .frame(height: screenHeight * 0.1)
                
                
                guidInfo()
                guidInfo()
                guidInfo()
                
            }
            .padding(.all, screenWidth * 0.1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          
            
        }
        .background(backgroundColorPage)
        
        .overlay{
            ZStack{
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        
        .navigationBarBackButtonHidden(true)
        
        
        
        
        
    }
}

#Preview {
    UserManual()
}




struct guidInfo: View {
    var body: some View {
        VStack {
            Color.clear
            VStack{
                
                Text("كيفية رفع موقف حضور الطلبة")
                    .multilineTextAlignment(.trailing)
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.033 : screenWidth * 0.023 ))
                    .foregroundStyle(primaryColor)
                    
                
                Spacer()
                    .frame(height: screenHeight * 0.01)
                
                
                Text("فيديو تعليمي عن كيفية رفع الحضور اليومي للطلبة في الدورة")
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.028 : screenWidth * 0.023 ))
                    .foregroundStyle(primaryColor)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, screenWidth * 0.02)
                Spacer()
                    .frame(height: screenHeight * 0.01)
                
                HStack{
                    Button(action: {}){
                        Text("مشاهدة الفيديو على يوتيوب")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                            .foregroundStyle(primaryColor)
                            .frame(maxWidth: .infinity)
                    }
                }
                //.frame(width: screenWidth * 0.8)
               
                .padding(.all, screenWidth * 0.015)
                .background(buttonAccentColor)
            }
            .padding(.top, screenHeight * 0.02)
            .background(Color.white)
            .cornerRadius(5)
            .overlay{
                Image("Group 124")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth * 0.06)
                    .offset(y: screenHeight * -0.065)
               
        }
        }
        
        
    }
}
