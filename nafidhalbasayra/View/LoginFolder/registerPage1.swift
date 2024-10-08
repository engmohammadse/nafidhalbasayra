//
//  registerPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/10/2024.
//

import SwiftUI

struct registerPage1: View {
    
    @State var city: String = "النجف الأشرف"
    @State var province: String = "اختر"
    @State var mosque: String = ""
    @State var isLectured: String = "اختر"
    @State private var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
    @State private var selectedItem: String = ""
    @State private var showDropdown = false

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

                    TextField(province, text: $province)
                        .onTapGesture {
                            // Toggle dropdown when tapping on the TextField
                            showDropdown.toggle()
                        }
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay {
                            Image(showDropdown ? "Vector" : "Vector1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: screenWidth * 0.03)
                                .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                        }

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
                }
                .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
            }
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            .overlay {
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
            }
            .ignoresSafeArea(edges: .bottom)

            .navigationBarBackButtonHidden(true)
            .overlay {
                PreviousNextButton(previousAction: {}, nextAction: {}, geoW: screenWidth, geoH: screenHeight, isNextNavigating: true, isPreviosNavigating: true, destination: AnyView(ContentView1()), destinationBack: AnyView(LoginPageWelcom()), color: Color.white, imageName: "Group 9")
                    .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.6 : screenHeight * 0.4)
            }

            // Dropdown List
            if showDropdown {
                List(itemsProvince, id: \.self) { item in
                    Text(item)
                        .onTapGesture {
                            // Store the selected item in the province variable
                            province = item
                            showDropdown = false // Hide the dropdown after selection
                        }
                }
                .frame(height: 400) // Set a height for the dropdown list
            }
        }
    }
}

#Preview {
    registerPage1()
}






#Preview {
    registerPage1( isLectured: "")
}
