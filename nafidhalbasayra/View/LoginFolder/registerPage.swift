//
//  registerPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//

import SwiftUI

struct registerPage: View {
    
    @State private var name : String = ""
    @State private var birthDay : String = ""
    @State private var phoneNumber : String = ""
    
    
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
              let geoW = geometry.size.width
            
         
            
            VStack(spacing: 2) {
                
          
                
                    Text("الأسم الرباعي واللقب")
                        .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                        .frame(maxWidth: .infinity, alignment: .trailing) // Push
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)

                  
                        TextField("user1          ", text: $name)
                            .frame(maxWidth: geoH * 0.4)
                            .frame(maxHeight: geoH * 0.05)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(5)
                
                //
                
                Text("تاريخ الولادة")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)

              
                    TextField("user1          ", text: $birthDay)
                        .frame(maxWidth: geoH * 0.4)
                        .frame(maxHeight: geoH * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                
                //
                
                Text("رقم الهاتف الخاص بالأستاذ")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)

              
                    TextField("user1          ", text: $phoneNumber)
                        .frame(maxWidth: geoH * 0.4)
                        .frame(maxHeight: geoH * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
            
                
                
               
             

                    
                
            } .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
           
            ZStack {
                LogoIUserInfo()
                    
            }
            
              
           
        }
         
    
    }
}




#Preview {
    registerPage()
}
