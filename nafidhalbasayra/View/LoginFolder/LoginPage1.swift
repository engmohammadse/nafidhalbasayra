//
//  LoginPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/09/2024.
//

import SwiftUI

struct LoginPage1: View {
    @State var textFieldText: String = ""

    var body: some View {
       
        VStack (spacing: 6){
            Spacer()
            Image("Group 3")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
//
                
            Color.clear
                .frame(height: 25)
            
            //
            Text("تسجيل الدخول")
                .font(.custom("BahijTheSansArabic-Bold", size: 36))
                .foregroundStyle(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                .bold()
            
            Color.clear
                .frame(height: 25)
            
            
            HStack{
                Spacer()
                Text("اسم المستخدم      ")
                    .font(.custom("BahijTheSansArabic-Bold", size: 15))
                    .font(.footnote)
                    .bold()
            }
            //
            
            VStack {
                TextField("", text: $textFieldText)
                    .frame(maxWidth: 400)
                    .frame(height: 55)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
            }
            //
            
            
            
            
            Color.clear
                .frame(height: 14)
            
            HStack{
                Spacer()
                Text("كلمة المرور      ")
                    .font(.custom("BahijTheSansArabic-Bold", size: 15))
                    .bold()
            }
            
            VStack {
                TextField("", text: $textFieldText)
                    .frame(maxWidth: 400)
                    .frame(height: 55)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
            }
            
            
          
            Color.clear
                .frame(height: 20)
            
            
            
            // button
            Button(action: {}, label: {
                Text("تسجيل الدخول")
                    
                    .font(.custom("BahijTheSansArabic-Bold", size: 16))
                    .frame(height: 55)
                    .frame(maxWidth: 400)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal)
            })
            
                .background(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                .cornerRadius(5)
            
               //
            
            Spacer()
            Spacer()
            
            
        }.padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236/255, green: 242/255, blue: 245/255))
    }
}

#Preview {
    LoginPage1()
}
