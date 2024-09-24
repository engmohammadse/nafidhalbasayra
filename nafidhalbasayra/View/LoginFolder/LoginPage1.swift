//
//  LoginPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/09/2024.
//

import SwiftUI

struct LoginPage1: View {
    @State var textFieldText1: String = ""
    @State var textFieldText2: String = ""
    @State private var isPressed = false
    @FocusState private var isTextFieldFocused1: Bool // State to track focus
    @FocusState private var isTextFieldFocused2: Bool



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
                TextField("", text: $textFieldText1)
                    
                    .frame(maxWidth: 400)
                    .frame(height: 55)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(isTextFieldFocused1 ? Color.gray.opacity(0.8) :Color.white)
                    .cornerRadius(5)
                    .focused($isTextFieldFocused1) // Bind focus state to the TextField
                    .border(isTextFieldFocused1 ? .blue : .clear)

                
            }
            //
            
            Color.clear
                .frame(height: 14)
            //
            
            
            HStack{
                Spacer()
                Text("كلمة المرور      ")
                    .font(.custom("BahijTheSansArabic-Bold", size: 15))
                    .bold()
            }
            //
            VStack {
                TextField("", text: $textFieldText2)
                    .frame(maxWidth: 400)
                    .frame(height: 55)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(isTextFieldFocused2 ? Color.gray.opacity(0.8) :Color.white)
                    .cornerRadius(5)
                    .focused($isTextFieldFocused2) // Bind focus state to the TextField
                    .border(isTextFieldFocused2 ? .blue : .clear)

                
            }
            //
            
            Color.clear
                .frame(height: 20)
            
            // button
            Button(action: {
                
                // Toggle the pressed state
                isPressed.toggle()
            }, label: {
                Text("تسجيل الدخول")
                    
                    .font(.custom("BahijTheSansArabic-Bold", size: 16))
                    .frame(height: 55)
                    .frame(maxWidth: 400)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal)
            }
            )
            
            .background( isPressed ? Color.black : Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
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
