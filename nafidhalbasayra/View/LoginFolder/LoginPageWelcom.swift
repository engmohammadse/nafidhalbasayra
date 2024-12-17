//
//  LoginPageWelcom.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/09/2024.
//





import SwiftUI

struct LoginPageWelcom: View {
    
    @State  private var isNavigate: Bool = false
    @EnvironmentObject var teacherData: TeacherDataViewModel

    //@StateObject var teacherData = TeacherDataViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
       
       // GeometryReader { geometry in
            
//            let geoH = geometry.size.height
//            let geoW = geometry.size.width
            
            
           // ZStack{
                
                VStack {
                   
                 
                    Spacer()
                        .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.08  : screenHeight * 0.10)
                    Text(SyncTeacherDataPostApi.shared.isConnected ? "متصل" : "غير متصل")

                    
                    VStack(alignment: .trailing, spacing: screenHeight * 0.1) {
                  
                        Text("• اهلا وسهلا بكم في تطبيق نافذ البصيرة.")
                            .frame(maxWidth: screenWidth * 0.7)  // Adjust width for wrapping
                                 .lineLimit(nil)
                                 .multilineTextAlignment(.trailing)
                        
                        
                        Text("• أعد هذا التطبيق لإدارة مشروع الدورات الصيفية.")
                            .frame(maxWidth: screenWidth * 0.7)  // Adjust width for wrapping
                                 .lineLimit(nil)
                                 .multilineTextAlignment(.trailing)
                        
                        Text("• يرجى البدء بعملية تسجيل البيانات الشخصية لأستاذ الدورة.")
                            .frame(maxWidth: screenWidth * 0.7)  // Adjust width for wrapping
                                 .lineLimit(nil)
                                 .multilineTextAlignment(.trailing)

                        Text("• للمتابعة، يرجى الضغط على زر التالي.")
                            .frame(maxWidth: screenWidth * 0.7)  // Adjust width for wrapping
                                 .lineLimit(nil)
                                 .multilineTextAlignment(.trailing)
            
                    }
                    
                    .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.05 : screenWidth * 0.03))
             
                    .padding()  // Padding inside the VStack
                    
                    .background(Color.white)  // Background color for the VStack
    //                .frame(width: geoW * 0.99)  // Adjust the width as per geoW
    //                .frame(height: geoH * 0.99 )
                    .cornerRadius(5)  // Rounded corners (optional)
                    .shadow(radius: 0.5)  // Add shadow (optional for style)
                    .multilineTextAlignment(.trailing)  // Aligns text from right to left
    //                .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? geoW * -0.11 : geoW * -0.15)
                    //.bold()
                    
                    
                    
                    


                           
                            
                            Spacer()
                        .frame(height: screenHeight * 0.15)
//
                            // Navigation buttons
                   
                    
                           // .padding(.bottom, 20)
                    
                    //Color(UIColor(red: 90 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1.0))
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                
        
        
        
        
                        .overlay {
                            LogoIUserInfo()
                                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
                        }
                
                
                        .overlay {
                            
                            PreviousNextButton( geoW: screenWidth, geoH: screenHeight,  destination: registerPage().environmentObject(teacherData),  color: Color(UIColor(red: 90 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1.0)), imageName: "Group 9_5", shouldNavigate: true, notEmptyFields: true)
                            
                                .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.4)
                        }

                    
                
           // }
            
//                    ZStack {
//                        VStack {
//                            Spacer().frame(maxHeight: screenHeight * 0.015)
//                            LogoIUserInfo()
//                        }
//                    }
                   
       // }
        .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    LoginPageWelcom().environmentObject(TeacherDataViewModel())
}
