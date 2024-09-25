//
//  LoginPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//

import SwiftUI

struct LoginPage0: View {
    var body: some View {
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
           // let geoW = geometry.size.width
            
            VStack {
                Spacer()
                    .frame(height: geoH * 0.08)
                Image("Group 2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.4, // Adjust size based on available width
                       height: geometry.size.height * 0.4)
                Spacer()
                    .frame(height: geoH * 0.05)
                
                Image("Group")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.3, // Adjust size based on available width
                       height: geometry.size.height * 0.3)
                
                Spacer()
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
            
        }
       
    }
}

#Preview {
    LoginPage0()
}
