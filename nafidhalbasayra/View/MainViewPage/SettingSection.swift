//
//  SettingSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/10/2024.
//

import SwiftUI

struct SettingSection: View {
    @Environment(\.dismiss) var dismiss
    @Binding var province: String

    @State private var selectedLanguage = "اختر لغة التطبيق" // النص الافتراضي

   
    
    
    var body: some View {
        VStack {
            ScrollView {
                Spacer().frame(height: screenHeight * 0.13)

                HStack {
                    Spacer().frame(width: screenWidth * 0.5)
                    Text("تغيير لغة التطبيق")
                        .foregroundStyle(.black)
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                }

                VStack(spacing: 0) {
                    Weeks3(languageChoose: $selectedLanguage) // تمرير اللغة المختارة
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColorPage)
        }
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
        }
        .overlay {
            ZStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.09 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingSection_Previews: PreviewProvider {
    static var previews: some View {
        @State var province = ""
        SettingSection(province: $province)
    }
}

struct Weeks3: View {
    @State private var isWeek1Expanded = false
    @Binding var languageChoose: String // Binding لتحديث اللغة المختارة

    var body: some View {
        ZStack {
            DisclosureGroup(isExpanded: $isWeek1Expanded) {
                VStack {
                    Image("Line 2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth * 0.8)
                        .frame(height: screenHeight * 0.05)
                    VStack {
                        LanguageOption(language: "اللغة العربية", languageChoose: $languageChoose, isExpanded: $isWeek1Expanded)
                        LanguageOption(language: "اللغة الانكليزية", languageChoose: $languageChoose, isExpanded: $isWeek1Expanded)
                    }
                    .padding(.bottom)
                }
            } label: {
                HStack {
                    Image(systemName: isWeek1Expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(primaryColor)
                    Spacer()
                    Text(languageChoose)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .multilineTextAlignment(.trailing)
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .accentColor(.clear)
            .frame(width: screenWidth * 0.95)
        }
        .padding(.bottom, screenHeight * 0.03)
    }
}

struct LanguageOption: View {
    var language: String
    @Binding var languageChoose: String // Binding لتحديث اللغة المختارة
    @Binding var isExpanded: Bool       // Binding لغلق DisclosureGroup

    var body: some View {
        HStack {
            Button(action: {
                languageChoose = language // تحديث اللغة المختارة
                isExpanded = false       // غلق DisclosureGroup
            }) {
                Text(language)
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundColor(primaryColor)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .frame(minWidth: 80)
                    .background(buttonAccentColor)
                    .cornerRadius(10)
            }
        }
        .padding(8)
        .background(buttonAccentColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
