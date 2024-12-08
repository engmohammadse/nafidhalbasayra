//
//  registerPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/10/2024.
//

import SwiftUI




struct registerPage1: View {
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @StateObject private var dataFetcher = DataFetcher()

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
    @State  var showAlertcityIdNotValid = false
    
    
//    @State private var isGo: Bool = teacherData.isGoRP1

    var body: some View {
        VStack {
            ScrollView {
                detailsRegisterPage1(teacherData: teacherData, showAlertcityIdNotValid: $showAlertcityIdNotValid)
                
               
                
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
           
         
        } 
//        .onAppear {
//            dataFetcher.fetchData()
//        }
        .hideKeyboard()
       
        
        .overlay {
            PreviousNextButtonRegisterPage1(geoW: screenWidth, geoH: screenHeight, destination: registerPage2().environmentObject(teacherData),  color: Color.white, imageName: "Group 9", shouldNavigate: teacherData.checkCityCodeRP1(), notEmptyFields: teacherData.checkFieldEmpty())

            .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)
            
        }
                

        .alert("رمز المحافظة المدخل بالصفحة السابقة لا يطابق المحافظة التي اخترتها، يجب ان يكونا متطابقان", isPresented: $teacherData.showAlertCityInRP1NOTEquall, actions: {
            Button("تم", role: .cancel) { }
        })
        .alert("يجب ان لاتبقى الحقول فارغة", isPresented: $teacherData.showEmptyAlertFieldRP1, actions: {
            Button("تم", role: .cancel) { }
        })
    }
    // Remove keyboard observers
    private func removeKeyboardObservers() {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }
}


#Preview {
    registerPage1()
        .environmentObject(TeacherDataViewModel())

}




import SwiftUI
import Network

struct detailsRegisterPage1: View {
    @ObservedObject var teacherData: TeacherDataViewModel
    @StateObject private var dataFetcher = DataFetcher()
    @StateObject private var dataFetcherProvine = ProvinceSpecificGet(teacherData: TeacherDataViewModel())

    
//    init(teacherData: TeacherDataViewModel) {
//        _dataFetcherProvince = StateObject(wrappedValue: ProvinceSpecificGet(teacherData: teacherData))
//    }


   
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItem: String = ""
    @State private var showDropdown = false
    @State private var showDropdownLectured = false
    @State private var showDropdownCity = false
    @State private var showDropdownProvince = false
    
    //@State  var showAlertcityIdNotValid = false
    @Binding var showAlertcityIdNotValid: Bool
    //@Binding var isGo: Bool
    @State private var showProgressLoding = false
    @State private var showProgressLodingProvince = false
    
    
    var body: some View {
        VStack(spacing: 10) {
            
            Spacer()
                .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.07  : screenHeight * 0.10)
            
            DropdownField1(
                label: "المحافظة",
                text: $teacherData.city,
                onTap: {
                    showDropdownCity.toggle()
                    if dataFetcher.governorates.isEmpty {
                        showProgressLoding = true
                        dataFetcher.fetchData()
                    }
                },
                imageName: showDropdownCity ? "Vector1" : "Vector"
            )
            
            if showProgressLoding {
                ProgressView("جاري تحميل البيانات...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if showDropdownCity {
                DropdownCityView(dataFetcher: dataFetcher, teacherData: teacherData, showDropdownCity: $showDropdownCity, showAlertcityIdNotValid: $showAlertcityIdNotValid)
            }

            DropdownField1(
                label: "القضاء",
                text: $teacherData.province,
                onTap: {
                    showDropdownProvince.toggle()
                    if dataFetcherProvine.province.isEmpty {
                        showProgressLodingProvince = true
                        dataFetcherProvine.fetchData()
                    }
                },
                imageName: showDropdownProvince ? "Vector1" : "Vector"
            )
            
            if showProgressLodingProvince {
                ProgressView("جاري تحميل البيانات...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                
            } else if showDropdownProvince {
             
                DropdownProvinceView(dataFetcherProvine: dataFetcherProvine,  teacherData: teacherData, showDropdownProvince: $showDropdownProvince)
            }
            
            
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
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.03 : screenWidth * 0.02))
            
            
            
                Spacer().frame(maxHeight: screenHeight * 0.01)

            
            
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
                                .disabled(true)
                                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                                .onTapGesture {
                                    showDropdownLectured.toggle()
                                }
                                .overlay {
                                    Image(showDropdownLectured ? "Vector1" : "Vector")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
                                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                                }
            
                            if showDropdownLectured {
                                DropdownLecturedView(teacherData: teacherData, showDropdownLectured: $showDropdownLectured)
                            }
                        }
           
                        
            
            
            //Spacer()
        
        .onChange(of: dataFetcher.showProgress) { newValue in
            showProgressLoding = newValue
        }
        .onChange(of: dataFetcherProvine.showProgress) { newValue in
            showProgressLodingProvince = newValue
        }
        .onChange(of: dataFetcher.governorates) { _ in
            showProgressLoding = false
        }
        .onChange(of: dataFetcherProvine.province) { _ in
            showProgressLoding = false
        }
        .alert("رمز المحافظة المدخل بالصفحة السابقة لا يطابق المحافظة التي اخترتها، يجب ان يكونا متطابقان", isPresented: $showAlertcityIdNotValid, actions: {
            Button("OK", role: .cancel) { }
        })
        .alert("\(String(describing: dataFetcherProvine.errorMessage))", isPresented: $dataFetcherProvine.showProgress, actions: {
            Button("OK", role: .cancel) { }
        })
        .onAppear {
//            if dataFetcher.governorates.isEmpty {
//                showProgressLoding = true
//                dataFetcher.fetchData()
//            }
             
//            if dataFetcherProvine.province.isEmpty {
//                if teacherData.cityIdfromApi.isEmpty { // تحقق من شرط معين
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { // 0.5 ثانية تأخير
//                        dataFetcherProvine.fetchData()
//                        showProgressLodingProvince = true
//                    }
//                } else {
//                    dataFetcherProvine.fetchData()
//                }
//            }

        }
        .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
    }

  
}


struct DropdownField1: View {
    var label: String
    @Binding var text: String
    var onTap: () -> Void
    var imageName: String
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(label)
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("اختر", text: $text)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .disabled(true)
                .onTapGesture(perform: onTap)
                .overlay {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                }
        }
    }
}






//    var body: some View {
//        VStack(spacing: 10) {
//            Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.07  : screenHeight * 0.10)
//            
//            Text("المحافظة")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
//                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//            
//            TextField("اختر", text: $teacherData.city)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                .frame(maxWidth: screenHeight * 0.4)
//                .frame(height: screenHeight * 0.05)
//                .multilineTextAlignment(.trailing)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(5)
//                .disabled(true)
//                .onTapGesture {
//                    showDropdownCity.toggle()
//                    if dataFetcher.governorates.isEmpty {
//                        showProgressLoding = true
//                        dataFetcher.fetchData()
//                    }
//                }
//                .overlay {
//                    Image(showDropdownCity ? "Vector1" : "Vector")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
//                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
//                }
//            
//            if showProgressLoding {
//                ProgressView("جاري تحميل البيانات...")
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .padding()
//            } else {
//                if showDropdownCity {
//                    DropdownCityView(dataFetcher: dataFetcher, teacherData: teacherData, showDropdownCity: $showDropdownCity, showAlertcityIdNotValid: $showAlertcityIdNotValid)
//                }
//            }
//            
//            Spacer().frame(maxHeight: screenHeight * 0.01)
//            
//            Text("القضاء")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
//                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//            
//            TextField("اختر", text: $teacherData.province)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                .frame(maxWidth: screenHeight * 0.4)
//                .frame(height: screenHeight * 0.05)
//                .multilineTextAlignment(.trailing)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(5)
//                .disabled(true)
//                .onTapGesture {
//                    showDropdown.toggle()
//                }
//                .overlay {
//                    Image(showDropdown ? "Vector1" : "Vector")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
//                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
//                }
//            
//            if showDropdown {
//                DropdownProvinceView(teacherData: teacherData, showDropdown: $showDropdown)
//            }
//            
//            Spacer().frame(maxHeight: screenHeight * 0.01)
//            
//            Text("اسم الجامع او الحسينية")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//            
//            TextField("", text: $teacherData.mosquname)
//                .frame(maxWidth: screenHeight * 0.4)
//                .frame(height: screenHeight * 0.05)
//                .multilineTextAlignment(.trailing)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(5)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//            
//            Spacer().frame(maxHeight: screenHeight * 0.01)
//            
//            VStack(spacing: 10) {
//                Text("هل قمت بالتدريس سابقاً في الدورات القرآنية الصيفية")
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//                
//                TextField("اختر", text: $teacherData.selectedLecturedOption)
//                    .frame(maxWidth: screenHeight * 0.4)
//                    .frame(height: screenHeight * 0.05)
//                    .multilineTextAlignment(.trailing)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .cornerRadius(5)
//                    .disabled(true)
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                    .onTapGesture {
//                        showDropdownLectured.toggle()
//                    }
//                    .overlay {
//                        Image(showDropdownLectured ? "Vector1" : "Vector")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
//                            .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
//                    }
//                
//                if showDropdownLectured {
//                    DropdownLecturedView(teacherData: teacherData, showDropdownLectured: $showDropdownLectured)
//                }
//            }
//            Spacer()
//        }
//        .onChange(of: dataFetcher.showProgress) { newValue in
//            showProgressLoding = newValue
//        }
//        .onChange(of: dataFetcher.governorates) { _ in
//            showProgressLoding = false
//        }
//        .alert("رمز المحافظة المدخل بالصفحة السابقة لا يطابق المحافظة التي اخترتها، يجب ان يكونا متطابقان", isPresented: $showAlertcityIdNotValid, actions: {
//            Button("OK", role: .cancel) { }
//        })
//        .onAppear {
//            if dataFetcher.governorates.isEmpty {
//                showProgressLoding = true
//                dataFetcher.fetchData()
//            }
//        }
//        .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
//    }
//}



struct DropdownCityView: View {
    @ObservedObject var dataFetcher: DataFetcher
    @ObservedObject var teacherData: TeacherDataViewModel
    @Binding var showDropdownCity: Bool
    @Binding var showAlertcityIdNotValid: Bool
//    @Binding var isGo: Bool



    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(dataFetcher.governorates, id: \.id) { governorate in
                    CityRowView(governorate: governorate, teacherData: teacherData, showDropdownCity: $showDropdownCity, showAlertcityIdNotValid: $showAlertcityIdNotValid)
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
        .background(Color.white)
        .cornerRadius(5)
    }
}




struct CityRowView: View {
    let governorate: Governorate
    @ObservedObject var teacherData: TeacherDataViewModel
    @StateObject private var dataFetcher = DataFetcher()

    @Binding var showDropdownCity: Bool
    @Binding var showAlertcityIdNotValid: Bool
    //@Binding var isGo: Bool

    var body: some View {
        HStack {
            Text(governorate.governorateName)
                .multilineTextAlignment(.trailing)
                .padding(8)
                .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                .frame(maxWidth: .infinity)
                .foregroundColor(primaryColor)
                .background(buttonAccentColor)
                .cornerRadius(5)
                .onTapGesture {
                    dataFetcher.fetchData()
                    
                    teacherData.city = governorate.governorateName
                    teacherData.cityIdfromApi = governorate.id
                    teacherData.cityCodefromApi = String(governorate.governorateCode)
                    showDropdownCity = false
                    // Check if city ID is valid
                    if let citynumber = Int(teacherData.citynumber), citynumber != governorate.governorateCode {
                        teacherData.city = "اختر"
                        showAlertcityIdNotValid = true
                        teacherData.isGoRP1 = false // Invalid city ID, so disable further action
                    } else {
                        teacherData.isGoRP1 = true // Valid city ID, allow further action
                        teacherData.isFetching = true
                    }
                }

            
//                .onTapGesture {
//                    teacherData.city = governorate.governorateName
//                    teacherData.cityIdfromApi = governorate.regionID
//                    showDropdownCity = false
//                    if let citynumber = Int(teacherData.citynumber), citynumber != governorate.governorateCode {
//                        showAlertcityIdNotValid = true
//                        isGo = false
//                    }
//                }
            
            
            
            
        }
        .padding(.horizontal)
    }
}



import SwiftUI

struct DropdownProvinceView: View {
    @ObservedObject var dataFetcherProvine: ProvinceSpecificGet
    @ObservedObject var teacherData: TeacherDataViewModel
    @Binding var showDropdownProvince: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(dataFetcherProvine.province, id: \.id) { provinces in
                    ProvinceRowView(province: provinces, teacherData: teacherData, showDropdownProvince: $showDropdownProvince)
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
        .background(Color.white)
        .cornerRadius(5)
    }
}

struct ProvinceRowView: View {
    
    
    
    
    let province: Province
    @ObservedObject var teacherData: TeacherDataViewModel
    @Binding var showDropdownProvince: Bool
    @StateObject private var dataFetcherProvine = ProvinceSpecificGet(teacherData: TeacherDataViewModel())

    var body: some View {
        HStack {
            Text(province.regionName)
                .multilineTextAlignment(.trailing)
                .padding(8)
                .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                .frame(maxWidth: .infinity)
                .foregroundColor(primaryColor)
                .background(buttonAccentColor)
                .cornerRadius(5)
                .onTapGesture {
                    dataFetcherProvine.fetchData()
                    
                    teacherData.province = province.regionName
                  
                    showDropdownProvince = false
                    
                   
                }
        }
        .padding(.horizontal)
    }
}


//
//import SwiftUI
//
//struct DropdownProvinceView: View {
//    let province : Province
//    @ObservedObject var teacherData: TeacherDataViewModel
//    @Binding var showDropdown: Bool
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 8) { // Adjust spacing as needed
//                ForEach(ProvinceSpecificGet.province, id: \.self) { item in
//                    HStack {
//                        Text(item)
//                            .multilineTextAlignment(.trailing)
//                            .padding(8) // Add padding around text
//                            .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
//                            .frame(maxWidth: .infinity)
//                            .foregroundColor(primaryColor) // Add a background color for each row
//                            .background(buttonAccentColor)
//                            .cornerRadius(5) // Optional: make rounded corners
//                            .onTapGesture {
//                                teacherData.province = item
//                                showDropdown = false
//                            }
//                    }
//                    .padding(.horizontal) // Horizontal padding for each row
//                }
//            }
//            .padding(.vertical) // Vertical padding for the entire list
//        }
//        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
//        .background(Color.white)
//        .cornerRadius(5)
//    }
//}




import SwiftUI

struct DropdownLecturedView: View {
    @ObservedObject var teacherData: TeacherDataViewModel
    @Binding var showDropdownLectured: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 8) { // Adjust spacing as needed
                ForEach(teacherData.itemsLectured, id: \.self) { item in
                    HStack {
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
        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
        .background(Color.white)
        .cornerRadius(5)
    }
}



















//
//struct detailsRegisterPage1: View {
//    @ObservedObject var teacherData: TeacherDataViewModel
//  
//    @StateObject private var dataFetcher = DataFetcher()
//
//    
//    
//    
//    @Environment(\.dismiss) var dismiss
//    
////    @Binding var city: String  // استخدام @Binding لتمرير القيم
////      @Binding var province: String
////      @Binding var mosque: String
////      @Binding var isLectured: String
//    
////    @State private var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
////    @State private var itemsLectured = ["لا","نعم"]
//    @State private var selectedItem: String = ""
//    @State private var showDropdown = false
//    @State private var showDropdownLectured = false
//    @State private var showDropdownCity = false
//    
//    @State private var showAlertcityIdNotValid = false
//    
//    var body: some View {
//        VStack(spacing: 10) {
//            Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.07  : screenHeight * 0.10)
//
//            // Field: Name
//            Text("المحافظة")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
//                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//            
//            
//            //
//            
//            TextField("اختر", text: $teacherData.city)
//               
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                .frame(maxWidth: screenHeight * 0.4)
//                .frame(height: screenHeight * 0.05)
//                .multilineTextAlignment(.trailing)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(5)
//                .disabled(true) // Disables keyboard input
//                .onTapGesture {
//                    // Toggle dropdown when tapping on the TextField
//                    showDropdownCity.toggle()
//                    dataFetcher.fetchData()
//                    
//                }
//                .overlay {
//                    Image(showDropdownCity ? "Vector1" : "Vector")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
//                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
//                }
//// Dropdown List
//              if showDropdownCity {
//            
//                  ScrollView {
//                      VStack(spacing: 8) { // Adjust spacing as needed
//                          ForEach(dataFetcher.governorates, id: \.id) { governorate in
//                              HStack {
//                                  //Spacer() // Pushes the text to the trailing edge for RTL layout
//
//                                  Text(governorate.governorateName)
//                                      .multilineTextAlignment(.trailing)
//                                      .padding(8) // Add padding around text
//                                   
//                                      .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
//                                      .frame(maxWidth: .infinity)
//                                  .foregroundColor(primaryColor) // Add a background color for each row
//                                  .background(buttonAccentColor)
//                                      .cornerRadius(5) // Optional: make rounded corners
//                                      .onTapGesture {
//                                          teacherData.city = governorate.governorateName
//                                          teacherData.cityIdfromApi = governorate.regionID
//                                          showDropdownCity = false
//                                          
//                                          
//                                          
//                                              
//                                          if String(teacherData.citynumber) != governorate.governorateCode {
//                                              showAlertcityIdNotValid = true
//                                              
//                                              }
//                                              
//                                        
//                                         
//                                      }
//                              }
//                              .padding(.horizontal) // Horizontal padding for each row
//                          }
//                      }
//                      .padding(.vertical) // Vertical padding for the entire list
//                  }
//                  .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
//                  .background(.white)
//                  .cornerRadius(5)
//                  
//                  
//              }
//            
//            //
//            
//
////            Picker(selection: $teacherData.city, label: Text("")) {
////                ForEach(dataFetcher.governorates, id: \.id) { governorate in
////                    Text(governorate.governorateName)
////                        .tag(governorate.governorateName)
////                }
////            }
////            .frame(maxWidth: screenHeight * 0.4)
////            .frame(height: screenHeight * 0.05)
////            .multilineTextAlignment(.trailing)
////            .padding(.horizontal)
////            .background(Color.white)
////            .cornerRadius(5)
////            .onChange(of: teacherData.city) { newValue in
////                teacherData.citynumber = newValue
////            }
////            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//
////            TextField("", text: $teacherData.city)
////                .frame(maxWidth: screenHeight * 0.4)
////                .frame(height: screenHeight * 0.05)
////                .multilineTextAlignment(.trailing)
////                .padding(.horizontal)
////                .background(Color.white)
////                .cornerRadius(5)
////                .onChange(of: teacherData.city) { newValue in
////                    teacherData.citynumber = newValue
////                }
////                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
////              
//
//            Spacer().frame(maxHeight: screenHeight * 0.01)
//
//            // Field: Phone Number
//            Text("القضاء")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
//                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//
//            TextField("اختر", text: $teacherData.province)
//               
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                .frame(maxWidth: screenHeight * 0.4)
//                .frame(height: screenHeight * 0.05)
//                .multilineTextAlignment(.trailing)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(5)
//                .disabled(true) // Disables keyboard input
//                .onTapGesture {
//                    // Toggle dropdown when tapping on the TextField
//                    showDropdown.toggle()
//                }
//                .overlay {
//                    Image(showDropdown ? "Vector1" : "Vector")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
//                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
//                }
//// Dropdown List
//              if showDropdown {
//            
//                  ScrollView {
//                      VStack(spacing: 8) { // Adjust spacing as needed
//                          ForEach(teacherData.itemsProvince, id: \.self) { item in
//                              HStack {
//                                  //Spacer() // Pushes the text to the trailing edge for RTL layout
//
//                                  Text(item)
//                                      .multilineTextAlignment(.trailing)
//                                      .padding(8) // Add padding around text
//                                   
//                                      .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
//                                      .frame(maxWidth: .infinity)
//                                  .foregroundColor(primaryColor) // Add a background color for each row
//                                  .background(buttonAccentColor)
//                                      .cornerRadius(5) // Optional: make rounded corners
//                                      .onTapGesture {
//                                          teacherData.province = item
//                                          showDropdown = false
//                                         
//                                      }
//                              }
//                              .padding(.horizontal) // Horizontal padding for each row
//                          }
//                      }
//                      .padding(.vertical) // Vertical padding for the entire list
//                  }
//                  .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
//                  .background(.white)
//                  .cornerRadius(5)
//                  
//                  
//              }
//
//            Spacer().frame(maxHeight: screenHeight * 0.01)
//
//            // Field: Academic Level
//            Text("اسم الجامع او الحسينية")
//                .alignmentGuide(.leading) { d in d[.trailing] }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//
//            TextField("", text: $teacherData.mosquname)
//                .frame(maxWidth: screenHeight * 0.4)
//                .frame(height: screenHeight * 0.05)
//                .multilineTextAlignment(.trailing)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(5)
//                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//
//            Spacer().frame(maxHeight: screenHeight * 0.01)
//
//            // Field: Current Work
//            
//            
//            
//            VStack( spacing: 10) {
//                Text("هل قمت بالتدريس سابقاً في الدورات القرآنية الصيفية")
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
//
//                TextField("اختر", text: $teacherData.selectedLecturedOption)
//                    .frame(maxWidth: screenHeight * 0.4)
//                    .frame(height: screenHeight * 0.05)
//                    .multilineTextAlignment(.trailing)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .cornerRadius(5)
//                    .disabled(true) // Disables keyboard input
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
//                    .onTapGesture {
//                        showDropdownLectured.toggle()
//                    }
//                    .overlay {
//                        Image(showDropdownLectured ? "Vector1" : "Vector")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
//                            .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
//                    }
//
//                if showDropdownLectured {
//                    ScrollView {
//                        VStack(spacing: 8) { // Adjust spacing as needed
//                            ForEach(teacherData.itemsLectured, id: \.self) { item in
//                                HStack {
//                                    //Spacer() // Pushes the text to the trailing edge for RTL layout
//
//                                    Text(item)
//                                        .multilineTextAlignment(.trailing)
//                                        .padding(8) // Add padding around text
//                                     
//                                        .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
//                                        .frame(maxWidth: .infinity)
//                                    .foregroundColor(primaryColor) // Add a background color for each row
//                                    .background(buttonAccentColor)
//                                        .cornerRadius(5) // Optional: make rounded corners
//                                        .onTapGesture {
//                                            teacherData.selectedLecturedOption = item
//                                            showDropdownLectured = false
//                                            if item == "لا" {
//                                                teacherData.didyoutaught = false
//                                            } else if item == "نعم" {
//                                                teacherData.didyoutaught = true
//                                            }
//                                        }
//                                }
//                                .padding(.horizontal) // Horizontal padding for each row
//                            }
//                        }
//                        .padding(.vertical) // Vertical padding for the entire list
//                    }
//                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)                    .background(.white)
//                    .cornerRadius(5)
//
//                }
//            }
//
//          
//          
//            
//        }
//        .onAppear {
//            dataFetcher.fetchData()
//        }
//        .alert("idCity not equall city", isPresented: showAlertcityIdNotValid)
//
//        .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
//        
//        
//    }
//    
//    
//    
//    
//    
//    
// 
//}



