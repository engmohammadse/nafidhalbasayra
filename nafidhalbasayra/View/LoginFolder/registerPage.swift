//
//  registerPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//

import SwiftUI

struct registerPage: View {
    
    @State private var textFieldText1 : String = ""
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
              let geoW = geometry.size.width
            
         
            
            VStack(spacing: 2) {
                
                HStack{
                    
                    Image("Group 63")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.07)
                  
                    
                    Text("user1212")
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, geoW * 0.04)
                        .background(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                        .cornerRadius(5)
                    
                    
                        Spacer()
                    
                    Image("Group 1")
                        .resizable()
                        .renderingMode(.template)  // Forces the image to be drawn as a template (grayscale)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.4 )
                        .foregroundColor(Color(UIColor(red: 27 / 255, green: 62 / 255, blue: 93 / 255, alpha: 1.0)))
                        

                }
                
               Spacer()
                
                
                VStack{
                    
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
                }

                    
                
            } .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
           
            
        }
        //.background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
    }
}

#Preview {
    registerPage()
}
