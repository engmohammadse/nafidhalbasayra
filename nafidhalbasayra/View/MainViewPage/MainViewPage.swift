//
//  MainViewPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct MainViewPage: View {
    var body: some View {
        
        
  
        ZStack {
               
                      VStack(spacing: screenHeight * 0.02) {
                          
                          Spacer().frame(height: uiDevicePhone ? screenHeight * 0.45 :  screenHeight * 0.3 )
                          
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                          }
                          
                        //  Spacer().frame(height: screenHeight * 0.0)
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                          }
                          
                         // Spacer().frame(height: screenHeight * 0.02)
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                          }
                      }
                      .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                      .offset(y: screenHeight * -0.17)
                
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            
            
            VStack{
                Spacer().frame(height: uiDevicePhone ? screenHeight * 0.075 : screenHeight * 0.1)
                
                HadeethSection()
                  
                    .overlay(
                        LogoIUserInfo()
                            .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * -0.07 : screenHeight * -0.08)
                    )
            }
            
            
            
              }
   

    
        
            
    }
}

#Preview {
    MainViewPage()
}

//
//.frame(maxWidth: .infinity, maxHeight: .infinity)
//.background(Color(red: 236/255, green: 242/255, blue: 245/255))


//.background(Color(red: 236/255, green: 242/255, blue: 245/255))



struct VStackSection: View {
    let imageName: String
    let text: String
    
    var body: some View {
        VStack {
            
            
            Button(action: {
                
                
            }){
                
                VStack{
                    
                    Image(imageName)
                        .padding(.top, screenHeight * 0.02)
                    
                    Text(text)
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.04 : screenWidth * 0.025))
                       
                        .foregroundColor(.black)
                        .padding(.horizontal, screenWidth * 0.04)
                        .padding(.bottom, screenHeight * 0.02)
                        .frame(height: screenHeight * 0.04)
                        .frame(width: uiDevicePhone ? screenWidth * 0.3 : screenWidth * 0.26)
                    
                }
                
            }
            
            
            
           
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}
