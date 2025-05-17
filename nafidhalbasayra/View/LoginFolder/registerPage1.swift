//
//  registerPage1.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/10/2024.
//

import SwiftUI




struct registerPage1: View {
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @StateObject private var dataFetcher = DataFetcherCity()

    @Environment(\.dismiss) var dismiss
    

    @State  var showAlertcityIdNotValid = false

    
    
    var body: some View {
        VStack {
            ScrollView {
                detailsRegisterPage1(teacherData: teacherData, showAlertcityIdNotValid: $showAlertcityIdNotValid)
                
               
                
                     
                   
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
        .onAppear {
       
            dataFetcher.fetchData()
        }
        
       
        
        .overlay {
            PreviousNextButtonRegisterPage1(geoW: screenWidth, geoH: screenHeight, destination: registerPage2().environmentObject(teacherData),  color: Color.white, imageName: "Group 9", shouldNavigate: teacherData.checkCityCodeRP1(), notEmptyFields: teacherData.checkFieldEmpty())

            .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)
            
        }
                
        .hideKeyboard()
       
    }

}


//#Preview {
//    registerPage1()
//        .environmentObject(TeacherDataViewModel())
//
//}




import SwiftUI
import Network

struct detailsRegisterPage1: View {
    @ObservedObject var teacherData: TeacherDataViewModel
    @StateObject  var dataFetcher = DataFetcherCity()
    @StateObject  var dataFetcherProvine = ProvinceSpecificGet()


   
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItem: String = ""
    @State private var showDropdown = false
    @State private var showDropdownLectured = false
    @State private var showDropdownCity = false
    @State private var showDropdownProvince = false
    @State private var showDropdownGender = false

    //@State  var showAlertcityIdNotValid = false
    @Binding var showAlertcityIdNotValid: Bool
    //@Binding var isGo: Bool
    @State private var showProgressLoding = false
    @State private var showProgressLodingProvince = false
    
    
    var body: some View {
        LazyVStack(spacing: screenHeight * 0.023) {
            
            Spacer()
                .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.05  : screenHeight * 0.10)
            
            DropdownField1(
                label: "المحافظة",
                text: $teacherData.city,
                onTap: {
                    showDropdownCity.toggle()
                    
                    dataFetcher.fetchData()
                    teacherData.province = ""
                    
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
                label: "القضاء (مكان إقامة الدورة)",
                text: $teacherData.province,
                onTap: {
                    
                   
                    dataFetcherProvine.fetchData()
                    
                    if globalCityIdFromApi == nil {
                        dataFetcherProvine.mustChooseCityAlertRP1 = true
                    }
                    
                    if  globalCityIdFromApi != nil {
                        dataFetcherProvine.fetchData()
                        showDropdownProvince.toggle()
                        
                        showProgressLodingProvince = true
                        
                        if dataFetcherProvine.province.isEmpty {
                           
                            dataFetcherProvine.fetchData()
                        }
                    }
                   
                },
                imageName: showDropdownProvince ? "Vector1" : "Vector"
            )
            
            if showProgressLodingProvince  {
                ProgressView("جاري تحميل البيانات...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                
                
                //&& !globalCityIdFromApi.isEmpty
            } else if showDropdownProvince && globalCityIdFromApi != nil {
             
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
            
            
            
//                Spacer().frame(maxHeight: screenHeight * 0.01)

            Text("اختر الجنس")
            
                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                            

                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            
            TextField("اختر", text: $teacherData.gender)
                                .frame(maxWidth: screenHeight * 0.4)
                                .frame(height: screenHeight * 0.05)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(5)
                                .disabled(true)
                                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                                .onTapGesture {
                                    
                                    showDropdownGender.toggle()
                                    hideKeyboardExplicitly()

                                }
                                .overlay {
                                    Image(showDropdownGender ? "Vector1" : "Vector")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)
                                        .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                                    
                                    
                                }
            
                            if showDropdownGender {
                                DropdownGenderView(teacherData: teacherData, showDropdownGender: $showDropdownGender)
                                    

                            }
            
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
                                    hideKeyboardExplicitly()

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
//        .onAppear {
//
//            dataFetcher.fetchData()
//        }
     
        
        .alert("رمز المحافظة المدخل بالصفحة السابقة لا يطابق المحافظة التي اخترتها، يجب ان يكونا متطابقان", isPresented: $teacherData.showAlertCityInRP1NOTEquall, actions: {
            Button("تم", role: .cancel) { }
        })
        .alert("يجب ان لاتبقى الحقول فارغة", isPresented: $teacherData.showEmptyAlertFieldRP1, actions: {
            Button("تم", role: .cancel) { }
        })
                        
            
            
            //Spacer()
        
        .onChange(of: dataFetcher.showProgress) { newValue in
            showProgressLoding = newValue
        }
        .onChange(of: dataFetcherProvine.showProgress) { newValue in
            showProgressLodingProvince = newValue
        }
//        .onChange(of: dataFetcher.governorates) { _ in
//            showProgressLoding = false
//        }
        .onChange(of: dataFetcherProvine.province) { _ in
            showProgressLodingProvince = false
        }
        .alert("رمز المحافظة المدخل بالصفحة السابقة لا يطابق المحافظة التي اخترتها، يجب ان يكونا متطابقان", isPresented: $showAlertcityIdNotValid, actions: {
            Button("تم", role: .cancel) { }
        })
        .alert("يجب اختيار المحافظة اولاً", isPresented: $dataFetcherProvine.mustChooseCityAlertRP1, actions: {
            Button("تم", role: .cancel) { }
        })
        
       

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
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.038 : screenWidth * 0.02))
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





struct DropdownCityView: View {
    @ObservedObject var dataFetcher: DataFetcherCity
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
        .alignmentGuide(.leading) { d in d[.trailing] } //add
        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.8 : screenWidth * 0.6)
        .background(Color.white)
        .cornerRadius(5)
    }
}




struct CityRowView: View {
    let governorate: Governorate
    @ObservedObject var teacherData: TeacherDataViewModel
    @StateObject private var dataFetcher = DataFetcherCity()

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
                        
                        teacherData.city = governorate.governorateName
                        teacherData.cityIdfromApi = governorate.id
                        globalCityIdFromApi = governorate.id
                        
                        
                    }
                }

            

            
            
            
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
    @StateObject private var dataFetcherProvine = ProvinceSpecificGet()


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
                  
                    showDropdownProvince = false
                    
                    dataFetcherProvine.fetchData()
                    
                    teacherData.province = province.regionName
                    teacherData.regionIdfromApi = province.id
                   
                } 
               
            
            
        }
        
        
        .padding(.horizontal)
    }
}





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


struct DropdownGenderView: View {
    @ObservedObject var teacherData: TeacherDataViewModel
    @Binding var showDropdownGender: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 8) { // Adjust spacing as needed
                ForEach(teacherData.itemsGender, id: \.self) { item in
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
//teacherData.selectedLecturedOption = item
                                showDropdownGender = false
                                teacherData.gender = item
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







