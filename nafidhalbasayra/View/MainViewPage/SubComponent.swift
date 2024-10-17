//
//  SubComponent.swift
//  nafidhalbasayra
//
//  Created by muhammad on 17/10/2024.
//

import SwiftUI

import SwiftUI

struct FormField: View {
    var label: String
    @Binding var text: String
    var isPhoneNumber: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(label)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            TextField("", text: $text)
                .keyboardType(isPhoneNumber ? .phonePad : .default)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
        }
    }
}


import SwiftUI

struct DropdownField: View {
    var label: String
    @Binding var selectedOption: String
    var options: [String]
    @State private var showDropdown: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(label)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            TextField(selectedOption, text: $selectedOption)
                .onTapGesture {
                    showDropdown.toggle()
                }
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .overlay {
                    Image(showDropdown ? "Vector1" : "Vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: screenWidth * 0.03)
                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                }

            if showDropdown {
                List(options, id: \.self) { option in
                    HStack {
                        Spacer()
                        Text(option)
                            .multilineTextAlignment(.trailing)
                            .padding(6)
                    }
                    .padding(6)
                    .onTapGesture {
                        selectedOption = option
                        showDropdown = false
                    }
                }
                .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.8 : screenWidth * 0.6)
                .frame(height: 200)
                .listStyle(PlainListStyle())
            }
        }
    }
}







//#Preview {
//    FormField(label: "", text: $"")
//}
