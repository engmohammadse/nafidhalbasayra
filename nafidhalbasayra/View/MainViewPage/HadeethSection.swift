//
//  HadeethSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct HadeethSection: View {
    var body: some View {
        ZStack {
            
           GeometryReader { geometry in
               VStack {
                   Text("إني تارك فيكم الثقلين ، ما إن تمسكتم بهما لن تضلوا : كتاب الله وعترتي أهل بيتي ، وإنهما لن يفترقا حتى يردا علي الحوض فانظروا كيف تخلفوني فيهما" )
                       .padding(.horizontal, geometry.size.width * 0.025)
                       .padding(.bottom, geometry.size.height * 0.05)
                       .padding(.top, geometry.size.height * 0.03)
                       .frame(width: screenWidth * 0.85)
                      // .frame(maxHeight: screenHeight * 0.2)
                       .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.035 : geometry.size.width * 0.02))
                       .multilineTextAlignment(.trailing)
                       .background(Color.white)
                       .cornerRadius(5)
                       .overlay(
                           // Overlay for the second text
                           Text("روي عن رسول الله (ص)")
                               .padding(.horizontal, 12)
                               .font(.custom("BahijTheSansArabic-Bold", size: geometry.size.width * 0.032))
                               .foregroundColor(Color.white)
                               .background(Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255, opacity: 1.0))
                               .cornerRadius(5)
                               .position(x: geometry.size.width * 0.85 / 1.4, y: geometry.size.height * 0.0) // Adjust the y value as needed
                          
                       )
                   
                   ZStack{
                      
                       
                       Text("روي عن رسول الله (ص)")
                           .padding(.horizontal, 12)
                           .font(.custom("BahijTheSansArabic-Plain", size: geometry.size.width * 0.032))
                           .position(x: geometry.size.width * 0.25, y: geometry.size.height * -0.04) // Adjust the y value as needed
                       
                   }
                    
        
               }
               
               
//               .frame(maxWidth: .infinity, maxHeight: .infinity)
              // .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                
               
                   }
            
            
           
            
               }
    }
}

#Preview {
    HadeethSection()
}
