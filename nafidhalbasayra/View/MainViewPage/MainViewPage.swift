//
//  MainViewPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct MainViewPage: View {
    var body: some View {
        ZStack{
            
            HadeethSection()
            
            VStack (spacing: screenHeight * 0.02){
                
                Image("Group 19")
                    .padding(.top, screenHeight * 0.02)
                    
                Text("قناة التبليغات")
                    .font(.custom("BahijTheSansArabic-Bold", size: screenWidth * 0.04))
                    .frame(height: screenHeight * 0.04)
                    .foregroundColor(.black)
                    .padding(.horizontal, screenWidth * 0.04)
                    .padding(.bottom, screenHeight * 0.02)
                    
                
                
            }.background(.white)
                .cornerRadius(5)
            
        
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
