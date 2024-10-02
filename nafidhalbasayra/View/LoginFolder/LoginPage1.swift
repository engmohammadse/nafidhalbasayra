//
//  LoginPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/09/2024.
//

import SwiftUI

struct LoginPage1: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var showError: Bool = true
    
    @State var textFieldText1: String = ""
    @State var textFieldText2: String = ""
    @State private var isPressed = false
    @FocusState private var isTextFieldFocused1: Bool // State to track focus
    @FocusState private var isTextFieldFocused2: Bool
    @State private var isPasswordVisible: Bool = false
    @State private var isNavigate: Bool = false
    




    var body: some View {
   
       
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
              let geoW = geometry.size.width
            
            VStack (spacing: 2){
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
               

                Spacer()
                    .frame(height: geoH * 0.02)
                
                //
                Text("تسجيل الدخول")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5) // Allows text to shrink down to 50% of its original size if needed
                    .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.08))
                
                    .foregroundStyle(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                    .bold()
                  
                
                if showError {
               
                        Text("هنالك مشكلة في تسجيل الدخول")
                        .frame(maxWidth: geoH * 0.4, maxHeight: geoH * 0.05) // Use maxWidth and idealHeight to set desired dimensions
                        .padding(.horizontal)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5) // Allows text to shrink down to 50% of its original size if needed
                            .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                            .foregroundStyle(Color(red: 160 / 255.0, green: 70 / 255.0, blue: 70 / 255.0))
                            .bold()
                            //.padding() // Add some padding for better spacing
                            .background(Color(red: 160 / 255.0, green: 70 / 255.0, blue: 70 / 255.0).opacity(0.1))
                           
                        .cornerRadius(5)
                       
                }

                

                
                Spacer()
                    .frame(height: geoH * 0.04)
                

                
                VStack(spacing: 2) {
                    
                    Text("اسم المستخدم")
                        .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                        .frame(maxWidth: .infinity, alignment: .trailing) // Push
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.03 : geoW * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                       
                    
                  
                        TextField("user1          ", text: $textFieldText1)
                            .frame(maxWidth: geoH * 0.4)
                            .frame(maxHeight: geoH * 0.05)
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
                                      : .clear, lineWidth: geoW * 0.004) // Border color and thickness
                                        )

                        
                    
                }
                //
                
    //            Color.clear
    //                .frame(height: 14)
                Spacer()
                    .frame(height: geoH * 0.02)
                //
 
                //
                
                
               
                
                VStack(spacing: 2) {
                    
                    Text("كلمة المرور")
                        .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                        .frame(maxWidth: .infinity, alignment: .trailing) // Push
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.03 : geoW * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                    
                    
                    ZStack{
                        
                        if isPasswordVisible {
                            
                            TextField("1233       ", text: $textFieldText2)
                                .keyboardType(.numberPad) // Set keyboard to number pad
                                .frame(maxWidth: geoH * 0.4)
                                .frame(maxHeight: geoH * 0.05)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                                .padding(.vertical, 0)
                                .background(Color.white)
                                .cornerRadius(5)
                                .focused($isTextFieldFocused2) // Bind focus state to the TextField
                                .border(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255)
             : .clear)
                                .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                  .stroke(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255)
                                          : .clear, lineWidth: geoW * 0.004) // Border color and thickness
                                            )
                        } else {
                            
                            SecureField("1233", text: $textFieldText2)
                                .keyboardType(.numberPad) // Set keyboard to number pad
                                .frame(maxWidth: geoH * 0.4)
                                .frame(maxHeight: geoH * 0.05)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                                .padding(.vertical, 0)
                                .background(Color.white)
                                .cornerRadius(5)
                                .focused($isTextFieldFocused2) // Bind focus state to the TextField
                                .border(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255)
             : .clear)
                                .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                  .stroke(isTextFieldFocused2 ? Color(red: 113/255, green: 138/255, blue: 161/255)
                                          : .clear, lineWidth: geoW * 0.004) // Border color and thickness
                                            )
                            
                            
                            
                        }
                        
                        Button(action: {
                                          isPasswordVisible.toggle()
                                      }) {
                                          
                                         // "eye.slash.fill" : "eye.fill"
                                          Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                              .resizable()
                                              .aspectRatio(contentMode: .fit)
                                              .foregroundColor(.gray)
                                              .padding(.trailing, 10)
                                              .frame(maxHeight: geoH * 0.017)
                                      }
                                      .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .phone ? geoW * -0.38 : geoW * -0.25)
                                     // .offset(x: -10)
                        
                        
                    }
                    
                    
                    }
                
                //
                
//                Color.clear
//                    .frame(height: 20)
                Spacer()
                    .frame(height: geoH * 0.015)
                
                // button
                Button(action: {
                    
                    isNavigate = true
                   
                    // Toggle the pressed state
                    isPressed.toggle()
                    withAnimation(.easeInOut(duration: 0.5)) { // Control the duration here
                           showError.toggle()
                       }

                    // Try to convert password input to Int (if needed)
                    if let passwordNumber = Int(textFieldText2) {
                        print("Password as Int: \(passwordNumber)")
                    } else {
                        print("Invalid number input.")
                    }
                    
                  
                }, label: {
                    Text("تسجيل الدخول")
                        
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.03 : geoW * 0.02))
                        .frame(maxWidth: geoH * 0.4)
                        .frame(maxHeight: geoH * 0.05)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal)
                }
                )
                
                .background( isPressed ? Color.black : Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
                    .cornerRadius(5)
                    .navigationDestination(isPresented: $isNavigate){
                   
                            LoginPageWelcom()
                      
                    }
                
                   //
                
                Spacer()
                    .frame(maxHeight: geoH * 0.3)
                
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
           
           
            
        }.ignoresSafeArea(.keyboard, edges: .bottom)
        
        
        
       
    }
    
    
    // Helper function to adjust the font size based on device type
    func getFontSize(for size: CGSize) -> CGFloat {
        if horizontalSizeClass == .regular {
            // Regular size class (iPads)
            return size.width * 0.05 // Scaled for iPads
        } else {
            // Compact size class (iPhones)
            return size.width * 0.04 // Scaled for iPhones
        }
    }
     
}




struct LoginPage1_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage1()
    }
}


