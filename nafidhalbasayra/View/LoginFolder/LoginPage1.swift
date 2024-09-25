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
       
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
           //   let geoW = geometry.size.width
            
            VStack (spacing: 6){
                Spacer()
                    .frame(height: geoH * 0.02)
                    .onAppear {
                                    // Print the screen width to the console
                                    print("UIScreen.main.bounds.width: \(UIScreen.main.bounds.width)")
                                }
                
                //
                Image("Group 3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.15, // Adjust size based on available width
                       height: geometry.size.height * 0.15)
               
    //
                    
//                Color.clear
//                    .frame(height: 25)
                Spacer()
                    .frame(height: geoH * 0.02)
                
                //
                Text("تسجيل الدخول")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5) // Allows text to shrink down to 50% of its original size if needed
                    .font(.custom("BahijTheSansArabic-Bold", size: dynamicFontSize1()))
                
                    .foregroundStyle(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                    .bold()
                  
                

                
    //            Color.clear
    //                .frame(height: 25)
                Spacer()
                    .frame(height: geoH * 0.05)
                
                HStack{
                    Spacer()
                        .frame(minWidth: 20, maxWidth: UIScreen.main.bounds.width * 0.4)
                    Text("اسم المستخدم")
                        .font(.custom("BahijTheSansArabic-Bold", size: dynamicFontSize2()))
                        //.font(.custom("BahijTheSansArabic-Bold", size: 15))
                        .font(.footnote)
                        .bold()
                }
                //
                
                VStack {
                    TextField("user1      ", text: $textFieldText1)
                        
                        .frame(maxWidth: geoH * 0.4)
                        .frame(maxHeight: geoH * 0.055)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .focused($isTextFieldFocused1) // Bind focus state to the TextField
                        .border(isTextFieldFocused1 ? Color(red: 113/255, green: 138/255, blue: 161/255)
     : .clear)
                        .overlay(
                        RoundedRectangle(cornerRadius: 5)
                          .stroke(isTextFieldFocused1 ? Color(red: 113/255, green: 138/255, blue: 161/255)
                                  : .clear, lineWidth: 4) // Border color and thickness
                                    )
    //                    .cornerRadius(5)
                    
                }
                //
                
    //            Color.clear
    //                .frame(height: 14)
                Spacer()
                    .frame(height: geoH * 0.02)
                //
                
                
                HStack{
                    Spacer()
                        .frame(minWidth: 20, maxWidth: UIScreen.main.bounds.width * 0.44)
                    Text("كلمة المرور")
                        .font(.custom("BahijTheSansArabic-Bold", size: dynamicFontSize2()))
                       // .font(.custom("BahijTheSansArabic-Bold", size: 15))
                        .bold()
                }
                //
                VStack {
                    TextField("1233", text: $textFieldText2)
                        .keyboardType(.numberPad) // Set keyboard to number pad
                        .frame(maxWidth: geoH * 0.4)
                        .frame(maxHeight: geoH * 0.055)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .focused($isTextFieldFocused2) // Bind focus state to the TextField
                        .border(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255)
     : .clear)
                        .overlay(
                        RoundedRectangle(cornerRadius: 5)
                          .stroke(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255)
                                  : .clear, lineWidth: 4) // Border color and thickness
                                    )
                       //.cornerRadius(5)
                    
                }
                //
                
//                Color.clear
//                    .frame(height: 20)
                Spacer()
                    .frame(height: geoH * 0.01)
                
                // button
                Button(action: {
                    
                    // Toggle the pressed state
                    isPressed.toggle()

                    // Try to convert password input to Int (if needed)
                    if let passwordNumber = Int(textFieldText2) {
                        print("Password as Int: \(passwordNumber)")
                    } else {
                        print("Invalid number input.")
                    }
                    
                  
                }, label: {
                    Text("تسجيل الدخول")
                        
                        .font(.custom("BahijTheSansArabic-Bold", size: 16))
                        .frame(maxWidth: geoH * 0.4)
                        .frame(maxHeight: geoH * 0.055)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal)
                }
                )
                
                .background( isPressed ? Color.black : Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                    .cornerRadius(5)
                
                   //
                
                Spacer()
                    .frame(maxHeight: geoH * 0.3)
                
            }.padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            
        }
    }
}

#Preview {
    LoginPage1()
}

//
//import SwiftUI
//
//struct LoginPage1: View {
//    @State var textFieldText1: String = ""
//    @State var textFieldText2: String = "" // Change to String
//    @State private var isPressed = false
//    @FocusState private var isTextFieldFocused1: Bool
//    @FocusState private var isTextFieldFocused2: Bool
//
//    var body: some View {
//        GeometryReader { geometry in
//            let geoH = geometry.size.height
//
//            VStack (spacing: 6) {
//                Spacer()
//                    .frame(height: geoH * 0.02)
//                    .onAppear {
//                        // Print the screen width to the console
//                        print("UIScreen.main.bounds.width: \(UIScreen.main.bounds.width)")
//                    }
//
//                Image("Group 3")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
//
//                Spacer()
//                    .frame(height: geoH * 0.02)
//
//                Text("تسجيل الدخول")
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.5)
//                    .font(.custom("BahijTheSansArabic-Bold", size: dynamicFontSize1()))
//                    .foregroundStyle(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
//                    .bold()
//
//                Spacer()
//                    .frame(height: geoH * 0.05)
//
//                HStack {
//                    Spacer()
//                        .frame(minWidth: 20, maxWidth: UIScreen.main.bounds.width * 0.4)
//                    Text("اسم المستخدم")
//                        .font(.custom("BahijTheSansArabic-Bold", size: dynamicFontSize2()))
//                        .font(.footnote)
//                        .bold()
//                }
//
//                VStack {
//                    TextField("user1", text: $textFieldText1)
//                        .frame(maxWidth: geoH * 0.4, maxHeight: geoH * 0.055)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .focused($isTextFieldFocused1)
//                        .border(isTextFieldFocused1 ? Color(red: 113/255, green: 138/255, blue: 161/255) : .clear)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(isTextFieldFocused1 ? Color(red: 113/255, green: 138/255, blue: 161/255) : .clear, lineWidth: 4)
//                        )
//                }
//
//                Spacer()
//                    .frame(height: geoH * 0.02)
//
//                HStack {
//                    Spacer()
//                        .frame(minWidth: 20, maxWidth: UIScreen.main.bounds.width * 0.44)
//                    Text("كلمة المرور")
//                        .font(.custom("BahijTheSansArabic-Bold", size: dynamicFontSize2()))
//                        .bold()
//                }
//
//                VStack {
//                    TextField("1233", text: $textFieldText2) // Now it's a String
//                        .keyboardType(.numberPad) // Set keyboard to number pad
//                        .frame(maxWidth: geoH * 0.4, maxHeight: geoH * 0.055)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .focused($isTextFieldFocused2)
//                        .border(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255) : .clear)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255) : .clear, lineWidth: 4)
//                        )
//                }
//
//                Spacer()
//                    .frame(height: geoH * 0.01)
//
//                Button(action: {
//                    // Toggle the pressed state
//                    isPressed.toggle()
//
//                    // Try to convert password input to Int (if needed)
//                    if let passwordNumber = Int(textFieldText2) {
//                        print("Password as Int: \(passwordNumber)")
//                    } else {
//                        print("Invalid number input.")
//                    }
//                }, label: {
//                    Text("تسجيل الدخول")
//                        .font(.custom("BahijTheSansArabic-Bold", size: 16))
//                        .frame(maxWidth: geoH * 0.4, maxHeight: geoH * 0.055)
//                        .foregroundStyle(Color.white)
//                        .padding(.horizontal)
//                })
//                .background(isPressed ? Color.black : Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
//                .cornerRadius(5)
//
//                Spacer()
//                    .frame(maxHeight: geoH * 0.3)
//            }
//            .padding(.horizontal, 40)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//        }
//    }
//
//    // Dummy dynamic font size functions for the preview
//    func dynamicFontSize1() -> CGFloat {
//        return 24
//    }
//    
//    func dynamicFontSize2() -> CGFloat {
//        return 16
//    }
//}
//
//#Preview {
//    LoginPage1()
//}
