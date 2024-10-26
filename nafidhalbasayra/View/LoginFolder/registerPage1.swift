//
//  registerPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/10/2024.
//

import SwiftUI

struct registerPage1: View {
    @ObservedObject var teacherData: TeacherDataViewModel
    
    @Environment(\.dismiss) var dismiss
    
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
                detailsRegisterPage1(teacherData: teacherData)
                
              
                
                Button("Print Data") {
                  teacherData.printData() // استدعاء دالة الطباعة
                    }

                     
                   
            }
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
          
            
            .overlay {
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
            }
            .ignoresSafeArea(edges: .bottom)

            .navigationBarBackButtonHidden(true)
           
         
        } .hideKeyboard()
       
        
        .overlay {
            PreviousNextButton(geoW: screenWidth, geoH: screenHeight,  destination: registerPage2(),  color: Color.white, imageName: "Group 9")
                .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)

        }
    }
    // Remove keyboard observers
    private func removeKeyboardObservers() {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }
}


#Preview {
    registerPage1(teacherData: TeacherDataViewModel())

}















struct detailsRegisterPage1: View {
    @ObservedObject var teacherData: TeacherDataViewModel
  
    @Environment(\.dismiss) var dismiss
    
//    @Binding var city: String  // استخدام @Binding لتمرير القيم
//      @Binding var province: String
//      @Binding var mosque: String
//      @Binding var isLectured: String
    
//    @State private var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
//    @State private var itemsLectured = ["لا","نعم"]
    @State private var selectedItem: String = ""
    @State private var showDropdown = false
    @State private var showDropdownLectured = false
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.07  : screenHeight * 0.10)

            // Field: Name
            Text("المحافظة")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            TextField("", text: $teacherData.city)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .onChange(of: teacherData.city) { newValue in
                    teacherData.citynumber = newValue
                }
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
              

            Spacer().frame(maxHeight: screenHeight * 0.01)

            // Field: Phone Number
            Text("القضاء")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            TextField("اختر", text: $teacherData.province)
               
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .disabled(true) // Disables keyboard input
                .onTapGesture {
                    // Toggle dropdown when tapping on the TextField
                    showDropdown.toggle()
                }
                .overlay {
                    Image(showDropdown ? "Vector1" : "Vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: screenWidth * 0.03)
                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                }
// Dropdown List
              if showDropdown {
            
                  ScrollView {
                      VStack(spacing: 8) { // Adjust spacing as needed
                          ForEach(teacherData.itemsProvince, id: \.self) { item in
                              HStack {
                                  //Spacer() // Pushes the text to the trailing edge for RTL layout

                                  Text(item)
                                      .multilineTextAlignment(.trailing)
                                      .padding(8) // Add padding around text
                                   
                                      .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                                      .frame(maxWidth: .infinity)
                                  .foregroundColor(primaryColor) // Add a background color for each row
                                  .background(buttonAccentColor)
                                      .cornerRadius(5) // Optional: make rounded corners
                                      .onTapGesture {
                                          teacherData.province = item
                                          showDropdown = false
                                         
                                      }
                              }
                              .padding(.horizontal) // Horizontal padding for each row
                          }
                      }
                      .padding(.vertical) // Vertical padding for the entire list
                  }
                  .frame(width: screenWidth * 0.84)
                  .background(.white)
                  .cornerRadius(5)
                  
                  
              }

            Spacer().frame(maxHeight: screenHeight * 0.01)

            // Field: Academic Level
            Text("اسم الجامع او الحسينية")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

            TextField("", text: $teacherData.mosquname)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))

            Spacer().frame(maxHeight: screenHeight * 0.01)

            // Field: Current Work
            
            
            
            VStack( spacing: 10) {
                Text("هل قمت بالتدريس سابقاً في الدورات القرآنية الصيفية")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

                TextField("اختر", text: $teacherData.selectedLecturedOption)
                    .frame(maxWidth: screenHeight * 0.4)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .disabled(true) // Disables keyboard input
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
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
                    ScrollView {
                        VStack(spacing: 8) { // Adjust spacing as needed
                            ForEach(teacherData.itemsLectured, id: \.self) { item in
                                HStack {
                                    //Spacer() // Pushes the text to the trailing edge for RTL layout

                                    Text(item)
                                        .multilineTextAlignment(.trailing)
                                        .padding(8) // Add padding around text
                                     
                                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                                        .frame(maxWidth: .infinity)
                                    .foregroundColor(primaryColor) // Add a background color for each row
                                    .background(buttonAccentColor)
                                        .cornerRadius(5) // Optional: make rounded corners
                                        .onTapGesture {
                                            teacherData.selectedLecturedOption = item
                                            showDropdownLectured = false
                                            if item == "لا" {
                                                teacherData.didyoutaught = false
                                            } else if item == "نعم" {
                                                teacherData.didyoutaught = true
                                            }
                                        }
                                }
                                .padding(.horizontal) // Horizontal padding for each row
                            }
                        }
                        .padding(.vertical) // Vertical padding for the entire list
                    }
                    .frame(width: screenWidth * 0.84)
                    .background(.white)
                    .cornerRadius(5)

                }
            }

          
          
            
        }
        .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
        
        
    }
    
 
}



