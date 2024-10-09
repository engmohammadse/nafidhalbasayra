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
    @State private var itemsLectured = ["لا","نعم"]
    @State private var selectedItem: String = ""
    @State private var showDropdown = false
    @State private var showDropdownLectured = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.07  : screenHeight * 0.10)

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
                            Image(showDropdown ? "Vector1" : "Vector")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: screenWidth * 0.03)
                                .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                        }
    // Dropdown List
                      if showDropdown {
                          List(itemsProvince, id: \.self) { item in
                              //Text(item)
                              
                              
                      HStack {
                                Spacer()
                                Text(item)
                                    .multilineTextAlignment(.trailing)
                                    .padding(6)
                            }
                               
                                  .padding(6) // Add padding for better touch area
                                  .onTapGesture {
                                      province = item
                                      showDropdown = false
                                  }
                          }
                          .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6, alignment: .center) // Center alignment
                          .frame(height: 200) // Set a height for the dropdown list
                          .listStyle(PlainListStyle()) // Optional: Use plain list style for dropdown
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
                    
                    
                    
                    VStack( spacing: 10) {
                        Text("هل قمت بالتدريس سابقاً في الدورات القرآنية الصيفية")
                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

                        TextField("", text: $isLectured)
                            .frame(maxWidth: screenHeight * 0.4)
                            .frame(height: screenHeight * 0.05)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(5)
                            .onTapGesture {
                                showDropdownLectured.toggle()
                            }
                            .overlay {
                                Image(showDropdownLectured ? "Vector1" : "Vector")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: screenWidth * 0.03)
                                    .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                            }

                        if showDropdownLectured {
                            List(itemsLectured, id: \.self) { item in
//                                Text(item)
                                
                            HStack {
                                      Spacer()
                                      Text(item)
                                          .multilineTextAlignment(.trailing)
                                          .padding(6)
                                  }
                                    .padding(6)
                                    .onTapGesture {
                                        isLectured = item
                                        showDropdownLectured = false
                                    }
                            }
                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6, alignment: .center)
                            .frame(height: 200)
                            .listStyle(PlainListStyle())
                           // .offset(x: screenWidth * -0.025)
                        }
                    }

                  
                  
                    
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
                PreviousNextButton(previousAction: {}, nextAction: {}, geoW: screenWidth, geoH: screenHeight, isNextNavigating: true, isPreviosNavigating: true, destination: AnyView(registerPage2()), destinationBack: AnyView(LoginPageWelcom()), color: Color.white, imageName: "Group 9")
                    .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.4)

            }

        }
    }
}


#Preview {
    registerPage1()
}



