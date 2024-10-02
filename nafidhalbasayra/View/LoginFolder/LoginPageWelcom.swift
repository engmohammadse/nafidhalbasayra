//
//  LoginPageWelcom.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/09/2024.
//

import SwiftUI

struct LoginPageWelcom: View {
    
    @State  private var isNavigate: Bool = false
    
    var body: some View {
        
       
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
            let geoW = geometry.size.width
            
         
                
           
            
            VStack {
               
             
                Spacer().frame(maxHeight: geoH * 0.02)
      
                VStack(alignment: .trailing, spacing: geoH * 0.1) {
              
                    Text("• اهلا وسهلا بكم في تطبيق نافذ البصيرة.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)
                    
                    
                    Text("• أعد هذا التطبيق لإدارة مشروع الدورات الصيفية.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)
                    
                    Text("• يرجى البدء بعملية تسجيل البيانات الشخصية لأستاذ الدورة.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)

                    Text("• للمتابعة، يرجى الضغط على زر التالي.")
                        .frame(maxWidth: geoW * 0.7)  // Adjust width for wrapping
                             .lineLimit(nil)
                             .multilineTextAlignment(.trailing)
        
                }
                
                .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.05 : geoW * 0.03))
         
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
                    .frame(height: geoW * 0.05)
                        
                        // Navigation buttons
                PreviousNextButton(previousAction: {}, nextAction: {}, geoW: geoW, geoH: geoH, isNextNavigating: true, destination: AnyView(registerPage()), color: Color(UIColor(red: 90 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1.0)))
                       // .padding(.bottom, 20)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            
                    ZStack {
                        VStack {
                            Spacer().frame(maxHeight: geoH * 0.015)
                            LogoIUserInfo()
                        }
                    }
                   
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginPageWelcom()
}
