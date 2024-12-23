//
//  const.swift
//  nafidhalbasayra
//
//  Created by muhammad on 25/09/2024.
//

import Foundation
import UIKit









func dynamicFontSize1() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    if screenWidth > 1000 { // Large screens like iPads
        return 60
    } else if screenWidth > 600 { // Medium screens like large phones or small tablets
        return 40
        
    }else if screenWidth > 250  {
            return 30
        
    } else { // Small screens like phones
        return 25
    }
}



func dynamicFontSize2() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth > 1000 { // Large screens like iPads
            return 30
        } else if screenWidth > 600 { // Medium screens like large phones
            return 20
        } else { // Small screens like iPhones
            return 15
        }
    }



import SwiftUI

// Extension to create a custom modifier for hiding the keyboard
extension View {
    func hideKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


func hideKeyboardExplicitly() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}






//
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType // تحديد مصدر الصور بشكل ديناميكي
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        // استخدم الكاميرا إذا كانت متوفرة، وإلا استخدم مكتبة الصور
//        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.selectedImage = image
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}







import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var locationError: String?

    override init() {
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // التحقق من حالة الإذن عند بدء التطبيق
        checkAuthorizationStatus()
    }

    func requestLocation() {
        self.locationError = nil

        // التحقق من حالة خدمات الموقع وصلاحيات الإذن
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                // طلب الإذن فقط إذا لم يتم تحديده مسبقًا
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
                // فتح الإعدادات إذا تم رفض الإذن
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            @unknown default:
                self.locationError = "حالة غير معروفة."
            }
        } else {
            self.locationError = "خدمات الموقع معطلة. يرجى تفعيلها من إعدادات الجهاز."
        }
    }

    func checkAuthorizationStatus() {
        // التحقق من الإذن عند بدء التطبيق
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            self.locationError = "حالة غير معروفة."
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // التعامل مع التغير في حالة الإذن
        switch status {
        case .notDetermined:
            print("لم يتم تحديد الإذن.")
        case .restricted, .denied:
            self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            print("حالة غير معروفة.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            self.locationError = "لم يتم تحديث الموقع."
            return
        }
        self.location = firstLocation
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
            case .locationUnknown:
                self.locationError = "موقع غير معروف."
            default:
                self.locationError = "خطأ: \(error.localizedDescription)"
            }
        } else {
            self.locationError = "خطأ: \(error.localizedDescription)"
        }
    }
}







// يعمل
//import Foundation
//import CoreLocation
//import UIKit
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var location: CLLocation?
//    @Published var locationError: String? // متغير لتخزين رسالة الخطأ
//
//    override init() {
//        super.init()
//        configureLocationManager()
//    }
//
//    private func configureLocationManager() {
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization() // طلب إذن الوصول إلى الموقع
//    }
//
//    func requestLocation() {
//        self.locationError = nil // إعادة تعيين رسالة الخطأ
//        if CLLocationManager.locationServicesEnabled() {
//            self.locationManager.requestLocation()
//        } else {
//            self.locationError = "خدمة الموقع غير مفعلة. يرجى تفعيلها من إعدادات الجهاز."
//            print("Location services are disabled.")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let firstLocation = locations.first else {
//            self.locationError = "لم يتم تحديث الموقع"
//            print("No locations found.")
//            return
//        }
//        self.location = firstLocation
//        print("Location updated: \(firstLocation.coordinate.latitude), \(firstLocation.coordinate.longitude)")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if let clError = error as? CLError {
//            switch clError.code {
//            case .denied:
//                self.locationError = "تم رفض إذن الموقع. يرجى السماح للتطبيق بالوصول إلى الموقع من الإعدادات."
//                // فتح الإعدادات
//                if let url = URL(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url)
//                }
//            case .locationUnknown:
//                self.locationError = "موقع غير معروف. يرجى المحاولة مرة أخرى."
//            default:
//                self.locationError = "فشل في الحصول على الموقع: \(error.localizedDescription)"
//            }
//        } else {
//            self.locationError = "فشل في الحصول على الموقع: \(error.localizedDescription)"
//        }
//        print("Failed to get location: \(error.localizedDescription)")
//    }
//}



// new LocationManager
//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var location: CLLocation?
//    @Published var locationError: String? // متغير لتخزين رسالة الخطأ
//
//    override init() {
//        super.init()
//        configureLocationManager()
//    }
//
//    private func configureLocationManager() {
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization() // طلب إذن الوصول إلى الموقع
//    }
//
//    func requestLocation() {
//        self.locationError = nil // إعادة تعيين رسالة الخطأ
//        if CLLocationManager.locationServicesEnabled() {
//            self.locationManager.requestLocation()
//        } else {
//            self.locationError = "خدمة الموقع غير مفعلة. يرجى تفعيلها من إعدادات الجهاز."
//            print("Location services are disabled.")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let firstLocation = locations.first else {
//            self.locationError = "لم يتم تحديث الموقع"
//            print("No locations found.")
//            return
//        }
//        self.location = firstLocation
//        print("Location updated: \(firstLocation.coordinate.latitude), \(firstLocation.coordinate.longitude)")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if let clError = error as? CLError {
//            switch clError.code {
//            case .denied:
//                self.locationError = "تم رفض إذن الموقع. يرجى السماح للتطبيق بالوصول إلى الموقع من الإعدادات."
//            case .locationUnknown:
//                self.locationError = "موقع غير معروف. يرجى المحاولة مرة أخرى."
//            default:
//                self.locationError = "فشل في الحصول على الموقع: \(error.localizedDescription)"
//            }
//        } else {
//            self.locationError = "فشل في الحصول على الموقع: \(error.localizedDescription)"
//        }
//        print("Failed to get location: \(error.localizedDescription)")
//    }
//}





//old
//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var location: CLLocation?
//
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization() // طلب إذن الوصول إلى الموقع
//    }
//
//    func requestLocation() {
//        self.locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.location = locations.first
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get location: \(error.localizedDescription)")
//    }
//}





// image pi

import SwiftUI

struct ImagePicker2: UIViewControllerRepresentable {
    @Binding var imageData: Data?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker2

        init(parent: ImagePicker2) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 1.0)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


// end image pi
