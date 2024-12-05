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
    @Published var birthDay: Date = Date() // استخدم Date بدلاً من Data للتمثيل الصحيح للتاريخ
    @Published var phonenumber: String = "" // يمكنك استخدام String لتجنب أي مشاكل مع الأرقام التي تبدأ بصفر
    
    // معلومات الموقع
    @Published var province: String = ""
    @Published var city: String = "اختر"
    @Published var citynumber: String = ""
    
    // معلومات التعليم
    @Published var didyoutaught: Bool = false
    @Published var mosquname: String = ""
    @Published var academiclevel: String = ""
    @Published var currentWork: String = ""
    @Published var cityIdfromApi: String = ""
    @Published var cityCodefromApi: String = ""
    
    
    //
    @Published  var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
    @Published  var itemsLectured = ["لا","نعم"]
    @Published var selectedLecturedOption:  String = ""
    
    
    // تخزين الصورة الملتقطة
    @Published var profileimage: UIImage?
    @Published var frontfaceidentity: UIImage?
    @Published var backfaceidentity: UIImage?
    
    

    
    
    
    
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
    
    func notEmptyFieldsRP1() -> Bool {
        if province.isEmpty {
             showProvinceEmpty = true
            return false
        } else if mosquname.isEmpty {
            showMosqunameEmpty = true
            return false
        } else if didyoutaught.description.isEmpty {
            showDidyoutaughtEmpty =  true
            return false
        }
        
        
        else {
            return true
        }
        
    }
    
    
//    func checkRP1 () -> Bool {
//        if notEmptyFieldsRP1() && checkCityCodeRP1() {
//            return true
//        } else {
//           return false
//        }
//    }
    
    
    
 // end RP1

    
    
    
    
    // دالة لطباعة البيانات
        func printData() {
            print("Name: \(name)")
            print("Birth Date: \(birthDay)")
            print("Phone Number: \(phonenumber)")
            print("Province: \(province)")
            print("City: \(city)")
            print("City Number: \(citynumber)")
            print("Did you taught: \(didyoutaught)")
            print("Mosque Name: \(mosquname)")
            print("Academic Level: \(academiclevel)")
            print("Current Work: \(currentWork)")
            print("cityIdfromApi: \(cityIdfromApi)")
        }
}



