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
                          
                          Spacer().frame(height: screenHeight * 0.45)
                          
                          
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
                Spacer().frame(height: screenHeight * 0.075)
                
                HadeethSection()
                  
                    .overlay(
                        LogoIUserInfo()
                            .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * -0.07 : screenHeight * 0.02)
                    )
            }
            
            
            
              }
   
//            
//        ZStack {
//            VStack{
//                    
//                    Spacer()
//                        .frame(height: screenHeight * 0.07)
//                    HadeethSection()
//                        .overlay {
//                            LogoIUserInfo()
//                                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * -0.06 : screenHeight * 0.02)
//                        }
//                    
//                   // (spacing: screenHeight * 0.02)
//                    VStack{
//                        
//                        HStack{
//                            
//                            VStack{
//                                
//                                Image("Group 19")
//                                    .padding(.top, screenHeight * 0.02)
//                                    
//                                Text("قناة التبليغات")
//                                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
//                                    .frame(height: screenHeight * 0.04)
//                                    .foregroundColor(.black)
//                                    
//                                    .padding(.horizontal, screenWidth * 0.04)
//                                    .padding(.bottom, screenHeight * 0.02)
//                                
//                                 
//                            }
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            
//                            Spacer()
//                                .frame(width: screenWidth * 0.04)
//                            
//                            VStack{
//                                
//                                Image("Group 19")
//                                    .padding(.top, screenHeight * 0.02)
//                                    
//                                Text("قناة التبليغات")
//                                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
//                                    .frame(height: screenHeight * 0.04)
//                                    .foregroundColor(.black)
//                                    .padding(.horizontal, screenWidth * 0.04)
//                                    .padding(.bottom, screenHeight * 0.02)
//                                 
//                            }
//                            .background(Color.white)
//                                .cornerRadius(10)
//                        }
//                        //.background(Color(red: 236/255, green: 242/255, blue: 245/255))
//                        
//                        Spacer()
//                            .frame(height: screenHeight * 0.02)
//                        
//                        HStack{
//                            
//                            VStack{
//                                
//                                Image("Group 19")
//                                    .padding(.top, screenHeight * 0.02)
//                                    
//                                Text("قناة التبليغات")
//                                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
//                                    .frame(height: screenHeight * 0.04)
//                                    .foregroundColor(.black)
//                                    
//                                    .padding(.horizontal, screenWidth * 0.04)
//                                    .padding(.bottom, screenHeight * 0.02)
//                                
//                                 
//                            }
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            
//                            Spacer()
//                                .frame(width: screenWidth * 0.04)
//                            
//                            VStack{
//                                
//                                Image("Group 19")
//                                    .padding(.top, screenHeight * 0.02)
//                                    
//                                Text("قناة التبليغات")
//                                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
//                                    .frame(height: screenHeight * 0.04)
//                                    .foregroundColor(.black)
//                                    .padding(.horizontal, screenWidth * 0.04)
//                                    .padding(.bottom, screenHeight * 0.02)
//                                 
//                            }
//                            .background(Color.white)
//                                .cornerRadius(10)
//                        }
//    //                    .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//                            
//                        
//                       
//                    }
//                    .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//                      
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//        }
//           
            
        
    
        
            
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
            Image(imageName)
                .padding(.top, screenHeight * 0.02)
            
            Text(text)
                .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
                .frame(height: screenHeight * 0.04)
                .foregroundColor(.black)
                .padding(.horizontal, screenWidth * 0.04)
                .padding(.bottom, screenHeight * 0.02)
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}
