//
//  CustemTextWithField.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//

import SwiftUI

    
    // Define the function outside the body
func textAndField(enterText: Binding<String>,name: String , geoW: CGFloat, geoH: CGFloat) -> some View {
    VStack(alignment: .trailing) {
        Text(name)
            .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
            .frame(maxWidth: .infinity, alignment: .trailing) // Push text to trailing
            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
        
        TextField("user1", text: enterText)
            .frame(maxWidth: geoH * 0.4)
            .frame(maxHeight: geoH * 0.05)
            .multilineTextAlignment(.trailing)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(5)
    }
}
