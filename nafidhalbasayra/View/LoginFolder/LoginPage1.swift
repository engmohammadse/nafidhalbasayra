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
//
                
            Spacer()
            
            //
            Text("تسجيل الدخول")
                .font(.custom("Amiri-Bold", size: 40))
                .foregroundStyle(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                .bold()
           
            Spacer()
            //
            
            
            HStack{
                Spacer()
                Text("اسم المستخدم      ")
                    .font(.footnote)
                    .bold()
            }
            //
            
            VStack {
                TextField("اسم المستخدم", text: $textFieldText)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(3)
                
            }
            //
            
            
            
            
            Color.clear
                .frame(height: 10)
            
            HStack{
                Spacer()
                Text("كلمة المرور      ")
                    .font(.footnote)
                    .bold()
            }
            
            VStack {
                TextField("كلمة المرور", text: $textFieldText)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(3)
                
            }
            
            
          
            Color.clear
                .frame(height: 10)
            
            Button(action: {}, label: {
                Text("تسجيل الدخول")
                    .foregroundStyle(Color.white)
            })
            .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                .cornerRadius(3)
               
            
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
