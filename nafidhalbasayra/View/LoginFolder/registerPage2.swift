//
//  registerPage2.swift
//  nafidhalbasayra
//
//  Created by muhammad on 09/10/2024.
//

import SwiftUI

struct registerPage2: View {
    @State private var isPressed = false
    @Environment(\.dismiss) var dismiss
    @StateObject var teacherData = TeacherDataViewModel()
    
    var body: some View {
        
        
        VStack (spacing: 0) {
            
            VStack  {
                HStack {
                
                    VStack{
                        Image("Group 123")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)

                        
                        Text("الصورة الشخصية")
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
                        
                        Text("يرجى رفع صورة سيلفي\n واضحة يظهر فيها الوجه\n كاملا")
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
                        
                        Text("يرجى تحميل صور الوجه \nالامامي للبطاقة الموحدة\n الخاصة بك")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                        .multilineTextAlignment(.trailing)
                    }
                    
                    Spacer()
                        .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
                
                    VStack{
                        Image("Group 126")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                        
                        Text("الوجه الامامي للهوية")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                            .offset(x: uiDevicePhone ? 0 : screenWidth * -0.02)
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
            
            
            Spacer()
                .frame(height: screenHeight * 0.035)
            
            VStack{
                HStack {
                
                    VStack{
                        Image("Group 128")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                        
                        Text("الوجه الخلفي للهوية")
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
                        
                        Text("يرجى رفع صورة سيلفي\n واضحة يظهر فيها الوجه\n كاملا")
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
            
            
            Spacer()
                .frame(height: screenHeight * 0.02)
            
            
            
            Button(action: {
//                    isPressed.toggle()
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        showError.toggle()
//                    }
//                    // Navigate to the next screen upon successful login
//                    isNavigate = true
            }) {
                Text("اسال البيانات")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                    .frame(height: screenHeight * 0.04)
                    .foregroundColor(.white)
                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
            }
            .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
            .cornerRadius(5)
            
            
            
            Spacer()
                .frame(height: screenHeight * 0.02)
            
            
       
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236/255, green: 242/255, blue: 245/255))
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            PreviousNextButton( geoW: screenWidth, geoH: screenHeight,  destination: registerPage3(), color: Color.white, imageName: "Group 9")
                .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)

        }
        
       
        
        
    }
}

#Preview {
    registerPage2()
}
