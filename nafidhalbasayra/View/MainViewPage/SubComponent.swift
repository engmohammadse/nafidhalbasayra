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
                .foregroundStyle(primaryColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            TextField("", text: $text)
                .keyboardType(isPhoneNumber ? .phonePad : .default)
                .foregroundStyle(primaryColor)
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
        
        //alignment: .trailing,
        VStack(spacing: 5) {
            // عنوان الحقل
            Text(label)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .foregroundStyle(primaryColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            // الحقل النصي
            TextField(selectedOption, text: $selectedOption)
                .onTapGesture {
                    showDropdown.toggle()
                }
                .foregroundStyle(primaryColor)
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

            // قائمة الخيارات
            if showDropdown {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                                .multilineTextAlignment(.trailing)
                                .padding(8)
                                .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.03 : screenWidth * 0.023))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(primaryColor)
                                .background(buttonAccentColor)
                                .cornerRadius(5)
                                .onTapGesture {
                                    selectedOption = option
                                    showDropdown = false
                                }
                        }
                    }
                    .padding(.all)
                }
                .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.78 : screenWidth * 0.6)
                .frame(height: 200)
                .background(Color.white)
                .cornerRadius(5)
            }
        }
    }
}
















//#Preview {
//    FormField(label: "", text: $"")
//}







