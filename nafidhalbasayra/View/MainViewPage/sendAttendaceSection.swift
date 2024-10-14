//
//  sendAttendaceSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 14/10/2024.
//

import SwiftUI

struct sendAttendaceSection: View {
    @State private var isPressed :Bool = false
    @State private var name: String = ""

    
    var body: some View {
     
    
    
        VStack {
            ScrollView {
            VStack  {
                Spacer()
                    .frame(height: screenHeight * 0.07)
                HStack {
                
                    VStack{
                        Image("Group 46")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)

                        
                        Text("تثبيت الموقع الحالي")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                    }
                    
                    Spacer()
                        .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
                    
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: screenWidth * 0.2)
                            Image("Group 124")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                        }
                        
                        Text("يرجى الذهاب لمكان مفتوح\n قبل الضغط على زر تثبيت\n الموقع .")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                        .multilineTextAlignment(.trailing)
                    }
                }
                
                Button(action: {
    //                    isPressed.toggle()
    //                    withAnimation(.easeInOut(duration: 0.5)) {
    //                        showError.toggle()
    //                    }
    //                    // Navigate to the next screen upon successful login
    //                    isNavigate = true
                }) {
                    Text("تثبيت")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                        .frame(height: screenHeight * 0.04)
                        .foregroundColor(.white)
                        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                }
                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .cornerRadius(5)
            }
            
            // 
            
            
            Spacer()
                .frame(height: screenHeight * 0.035)
            
            VStack{
                HStack {
                    
                    
                    VStack {
                        HStack {
                           
                            Image("Group 125")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                                .offset(x: uiDevicePhone ? 0 : screenWidth * 0.04)
                            Spacer()
                                .frame(width: screenWidth * 0.28)
                        }
                        
                        Text("يرجى ادخال عدد الطلبة\n الحاضرين بدقة، وقبل ذلك\n تأكد من تسجيل بيانات\n جميع طلبة الدورة في\n خانة بيانات الطلبة .")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                        .multilineTextAlignment(.trailing)
                        .frame(width: screenWidth * 0.4)
                    }
                    
                    Spacer()
                        .frame(width: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.04 )
                
                    VStack{
                        Image("Group 129")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                        
                        Text("عدد الطلبة الحاضرين")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                            .offset(x: uiDevicePhone ? 0 : screenWidth * -0.02)
                    }
                    
                    
                    
                   
                }
                
                // Field:
             
                
                TextField("مثال: 20", text: $name)
                    .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
                    .frame(height: screenHeight * 0.04)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
                // Field: End
                
                Spacer()
                    .frame(height: screenHeight * 0.035)
                
                VStack  {
                   
                    HStack {
                    
                        VStack{
                            Image("Group 130")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)

                            
                            Text("صورة جماعية للحضور")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                        }
                        
                        Spacer()
                            .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
                        
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: screenWidth * 0.2)
                                Image("Group 127")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                            }
                            
                            Text("يرجى اخذ صورة واحدة بشكل\n واضح يظهر فيها جميع\n الطلبة .")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                            .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Button(action: {
        //                    isPressed.toggle()
        //                    withAnimation(.easeInOut(duration: 0.5)) {
        //                        showError.toggle()
        //                    }
        //                    // Navigate to the next screen upon successful login
        //                    isNavigate = true
                    }) {
                        Text("تحميل الصورة")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                            .frame(height: screenHeight * 0.04)
                            .foregroundColor(.white)
                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                    }
                    .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                    .cornerRadius(5)
                }
                
                
        
            }
            
            // note section
            Spacer()
                .frame(height: screenHeight * 0.035)

            VStack{
               
                
                Text("في حال كانت هنالك ملاحظات يرجى كتابتها هنا")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                    .frame(height: screenHeight * 0.04)
                    .foregroundColor(.black)
                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                
                TextEditor(text: $name)
                           .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
                           .frame(height: screenHeight * 0.15)
                           .padding(.horizontal)
                           .background(Color.white)
                           .cornerRadius(5)
                           .overlay(
                               RoundedRectangle(cornerRadius: 5)
                                   .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                           )
                           .multilineTextAlignment(.trailing) // Ensures text is aligned to the right (Arabic)
                Spacer()
                    .frame(height: screenHeight * 0.035)
                
                Button(action: {
    //                    isPressed.toggle()
    //                    withAnimation(.easeInOut(duration: 0.5)) {
    //                        showError.toggle()
    //                    }
    //                    // Navigate to the next screen upon successful login
    //                    isNavigate = true
                }) {
                    Text("ارسال موقف الحضور")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                        .frame(height: screenHeight * 0.04)
                        .foregroundColor(.white)
                        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                }
                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                .cornerRadius(5)
                
                
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
              
        }  .overlay(
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * -0.08)
    )
        
        
    }
}

#Preview {
    sendAttendaceSection()
}
