//
//  TeacherDataViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 22/10/2024.
//

import Foundation
import Combine
import UIKit


//@MainActor

class TeacherDataViewModel: ObservableObject {
   
    
    @Published var userName: String?
    // معلومات المعلم الأساسية
    @Published var name: String = ""
   // @Published var birthDay: Date = Date() // استخدم Date بدلاً من Data للتمثيل الصحيح للتاريخ
    @Published var birthDay: Date? = nil // يسمح بالقيمة nil

    
    @Published var phonenumber: String = "" // يمكنك استخدام String لتجنب أي مشاكل مع الأرقام التي تبدأ بصفر
    
    // معلومات الموقع
    @Published var province: String = ""
    @Published var city: String = "اختر"
    @Published var citynumber: String = ""
    
    // معلومات التعليم
   // @Published var didyoutaught: Bool = false
    @Published var didyoutaught: Bool? = nil

    @Published var mosquname: String = ""
    @Published var academiclevel: String = ""
    @Published var currentWork: String = ""
    @Published var cityIdfromApi: String = ""
    @Published var regionIdfromApi: String = ""

    
    
    @Published var cityCodefromApi: String?
    @Published var gender: String = ""
    //
    @Published  var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
    @Published  var itemsLectured = ["لا","نعم"]
    @Published  var itemsGender = ["ذكر", "انثى"]
    @Published var selectedLecturedOption:  String = ""
    
    
    // تخزين الصورة الملتقطة
    @Published var profileimage: UIImage?
    @Published var frontfaceidentity: UIImage?
    @Published var backfaceidentity: UIImage?
    //
    
    @Published var isFetching = false

    
    
    // Model RegisterPage
    
       @Published var showAlertCheckNumber: Bool = false
      @Published var checkNumberRP: Bool = false

    
    
    func checkFieldEmptyRP() -> Bool {
        var isValid = true
        
       
        
        if name.isEmpty {
            DispatchQueue.main.async {
              //  self.showProvinceEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
               // self.showProvinceEmpty = false
                isValid = true
            }
        }
        
        if academiclevel.isEmpty {
            DispatchQueue.main.async {
              //  self.showMosqunameEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
                //self.showMosqunameEmpty = false
                isValid = true
            }
        }
        
        if currentWork.isEmpty {
            DispatchQueue.main.async {
               // self.showMosqunameEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
               // self.showMosqunameEmpty = false
                isValid = true
            }
        }
        
        
        if citynumber.isEmpty {
            DispatchQueue.main.async {
              //  self.showMosqunameEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
              //  self.showMosqunameEmpty = false
                isValid = true
            }
        }
        
        if phonenumber.count != 11 {
            DispatchQueue.main.async {
               // self.showMosqunameEmpty = true
                if self.checkNumberRP {
                    self.showAlertCheckNumber = true
                }
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
               // self.showMosqunameEmpty = false
                isValid = true
            }
        }
        
        if birthDay == nil {
            DispatchQueue.main.async {
               // self.showDidyoutaughtEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
               // self.showDidyoutaughtEmpty = false
                isValid = true
            }
        }
        
        
        return isValid
    }
    
    @Published var showRegisterPageFieldsEmpty: Bool = false
    
    @Published var validationAlert: ValidationAlertType? = nil

    enum ValidationAlertType: Identifiable {
        case phoneNumberError
        case emptyFields

        var id: Int {
            switch self {
            case .phoneNumberError: return 1
            case .emptyFields: return 2
            }
        }
    }
    
    
    // end RP
    
    @Published var sendTeacherDataToBackEndState: Int = 0
    
    
    
    
    
    
    
    
    
    
    
    // RP1
    //
    
//    func checkCityIdFromApi() -> Bool {
//        if !globalCityIdFromApi.isEmpty {
//            mustChooseCityAlertRP1 = false
//            return false
//        } else {
//            mustChooseCityAlertRP1 = true
//            return true
//        }
//    }
    

    @Published var isGoRP1: Bool = false
    @Published var showProvinceEmpty: Bool = false
    @Published var showMosqunameEmpty: Bool = false
    @Published var showGenderEmpty: Bool = false

    
    @Published var showDidyoutaughtEmpty: Bool = false
    @Published var showAlertCityInRP1NOTEquall: Bool = false

    
    
    // Method to check city numbers
    func checkCityCodeRP1() -> Bool {
        if citynumber == cityCodefromApi {
            return true
        } else {
            return false
        }
    }
    
  
    
    //@Published var showEmptyAlertRP1: Bool = false
    @Published var showEmptyAlertFieldRP1: Bool = false
    
    func checkFieldEmpty() -> Bool {
        var isValid = true

        if province.isEmpty {
            DispatchQueue.main.async {
                self.showProvinceEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
                self.showProvinceEmpty = false
            }
        }

        if mosquname.isEmpty {
            DispatchQueue.main.async {
                self.showMosqunameEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
                self.showMosqunameEmpty = false
            }
        }
        
        
        
        if gender.isEmpty {
            DispatchQueue.main.async {
                self.showGenderEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
                self.showGenderEmpty = false
            }
        }
        

        if didyoutaught == nil {
            DispatchQueue.main.async {
                self.showDidyoutaughtEmpty = true
            }
            isValid = false
        } else {
            DispatchQueue.main.async {
                self.showDidyoutaughtEmpty = false
            }
        }
        
        
        

        return isValid
    }

  
 // end RP1

    
        // RP2
    
    @Published var isLoadingRP2 = false

    
    
    
    
    
    
    
    
    
    
    // دالة لطباعة البيانات
        func printData() {
            print("Name: \(name)")
            print("Birth Date: \(String(describing: birthDay))")
            print("Phone Number: \(phonenumber)")
            print("Province: \(province)")
            print("City: \(city)")
            print("City Number: \(citynumber)")
            print("Did you taught: \(String(describing: didyoutaught))")
            print("Mosque Name: \(mosquname)")
            print("Academic Level: \(academiclevel)")
            print("Current Work: \(currentWork)")
            
            
            print("cityIdfromApi: \(cityIdfromApi)")
//            print("localIdCity: \(localIdCity)")
            print("cityCodefromApi: \(String(describing: cityCodefromApi))")
            print("checkFieldEmpty: \(checkFieldEmpty())")
            print("checkFieldEmptyRP: \(checkFieldEmptyRP())")
            
//            print("checkCityIdFromApi:\(String(describing: checkCityIdFromApi))")
           // print("mustChooseCityAlertRP1:\(mustChooseCityAlertRP1)")
            
            
            
        

        }
}



