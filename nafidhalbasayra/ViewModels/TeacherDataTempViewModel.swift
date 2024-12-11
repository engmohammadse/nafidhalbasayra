//
//  TeacherDataViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 22/10/2024.
//

import Foundation
import Combine
import UIKit

class TeacherDataViewModel: ObservableObject {
   
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
    @Published var localIdCity: String = "672cc19964e07256213b02b0"

    @Published var cityCodefromApi: String?
    
    
    //
    @Published  var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
    @Published  var itemsLectured = ["لا","نعم"]
    @Published var selectedLecturedOption:  String = ""
    
    
    // تخزين الصورة الملتقطة
    @Published var profileimage: UIImage?
    @Published var frontfaceidentity: UIImage?
    @Published var backfaceidentity: UIImage?
    //
    
    @Published var isFetching = false

    
    
    // Model RegisterPage
    
    

    
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
        
        if phonenumber.isEmpty {
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
    
    
    // end RP
    
    
    
    
    
    
    
    
    
    
    
    
    
    // RP1
    //
    @Published var isGoRP1: Bool = false
    @Published var showProvinceEmpty: Bool = false
    @Published var showMosqunameEmpty: Bool = false
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
            print("localIdCity: \(localIdCity)")
            print("cityCodefromApi: \(String(describing: cityCodefromApi))")
            print("checkFieldEmpty: \(checkFieldEmpty())")
            print("checkFieldEmptyRP: \(checkFieldEmptyRP())")
            
            
            
            
        

        }
}



