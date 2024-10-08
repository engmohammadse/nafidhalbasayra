//
//  registerPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/10/2024.
//

import SwiftUI

struct registerPage1: View {
    
    
    @State var city : String = "النجف الأشرف"
    @State var province : String = "اختر"
    @State var mosque : String = ""
    @State var isLectured : String = "اختر"


    
    var body: some View {
        
        
        VStack {
            
            
            ScrollView {
                VStack(spacing: 10) {
                    
                    Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.03 : screenHeight * 0.10)
                    
                    // Field: Name
                    Text("المحافظة")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $city)
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                    
                   
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                    
                    // Field: Phone Number
                    Text("القضاء")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $province)
                  
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                    
                    // Field: Academic Level
                    Text("اسم الجامع او الحسينية")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $mosque)
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        //.focused($activeField, equals: .academicLevel)
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                    
                    // Field: Current Work
                    Text("هل قمت بالتدريس سابقاً في الدورات القرآنية الصيفية")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $isLectured)
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        //.focused($activeField, equals: .currentWork)""
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                  
                }
                
                .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
                //.offset(y: calculateOffset()) // Apply offset only for the bottom fields
               
                
                
            }
            
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            .overlay{
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
            }
            .ignoresSafeArea(edges: .bottom)
            
         

            
        }.navigationBarBackButtonHidden(true)
            .overlay{
                
                
                PreviousNextButton(previousAction: {}, nextAction: {}, geoW: screenWidth, geoH: screenHeight, isNextNavigating: true, isPreviosNavigating: true, destination: AnyView(ContentView1()), destinationBack: AnyView(LoginPageWelcom()) , color: Color.white, imageName: "Group 9")
             
                    .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.6 : screenHeight * 0.4)
                                    
            }
        
        
    }
}

#Preview {
    registerPage1( isLectured: "")
}
