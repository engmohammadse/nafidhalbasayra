//
//  LoginPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//

import SwiftUI

struct LoginPage: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Group 2")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 200)
            
            Spacer()
            
            
            Spacer()
            Image("Group")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 200)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor(red: 0x1B / 255.0, green: 0x3E / 255.0, blue: 0x5D / 255.0, alpha: 1.0)))
       
    }
}

#Preview {
    LoginPage()
}
