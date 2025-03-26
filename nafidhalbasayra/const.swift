//
//  const.swift
//  nafidhalbasayra
//
//  Created by muhammad on 25/09/2024.
//

import Foundation
import UIKit


var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height


var uiDevicePhone = UIDevice.current.userInterfaceIdiom == .phone



extension Date {
    /// 🔹 دالة تقوم بتحويل `Date` إلى نص بتنسيق MM/dd/yyyy hh:mm a
    func formattedDateTimeUs() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm a" // ✅ تنسيق الوقت 12 ساعة مع AM/PM
        formatter.locale = Locale(identifier: "en_US_POSIX") // ✅ التأكد من استخدام تنسيق 12 ساعة
        return formatter.string(from: self)
    }
}






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


    



import SwiftUI
import UIKit
import AVFoundation
import Vision

struct SelfieCameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CameraViewControllerDelegate {
        let parent: SelfieCameraPicker

        init(_ parent: SelfieCameraPicker) {
            self.parent = parent
        }

        func didCapture(image: UIImage) {
            DispatchQueue.main.async {
                self.parent.selectedImage = image
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - Camera ViewController
class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession?
    var cameraOutput = AVCapturePhotoOutput()
    let faceDetectionRequest = VNDetectFaceRectanglesRequest()
    var delegate: CameraViewControllerDelegate?
    var isCapturing = false // متغير لمنع التقاط صور متكررة

    // عناصر واجهة المستخدم
    let overlayView = UIView()
    let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupCamera()
        }
    }

    // إعداد واجهة المستخدم وإضافة التنبية الأخضر
    func setupUI() {
        overlayView.frame = view.bounds
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayView.isHidden = true
        view.addSubview(overlayView)

        // تعديل موضع التنبيه ليكون في الأعلى
        let safeAreaTop = view.safeAreaInsets.top + 20
        messageLabel.frame = CGRect(x: 20, y: safeAreaTop, width: view.bounds.width - 40, height: 60)
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 2
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.masksToBounds = true
        messageLabel.backgroundColor = UIColor.green
        messageLabel.isHidden = true
        view.addSubview(messageLabel)
    }

    func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ لا يمكن العثور على الكاميرا الأمامية")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if session.canAddInput(input) {
                session.addInput(input)
            }

            if session.canAddOutput(cameraOutput) {
                session.addOutput(cameraOutput)
            }

            let videoOutput = AVCaptureVideoDataOutput()
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
            }

            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = self.view.bounds
                self.view.layer.insertSublayer(previewLayer, at: 0)
            }

            session.startRunning()
            self.captureSession = session

        } catch {
            print("❌ خطأ في إعداد الكاميرا: \(error.localizedDescription)")
        }
    }

    func capturePhoto() {
        guard !isCapturing else { return }  // منع التقاط صور متكررة
        isCapturing = true

        DispatchQueue.main.async {
            self.messageLabel.text = "تم التعرف على الوجه، سيتم التقاط الصورة، لا تتحرك"
            self.messageLabel.isHidden = false
            self.overlayView.isHidden = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {  // تأخير لمدة 3 ثوانٍ قبل الالتقاط
            let settings = AVCapturePhotoSettings()
            self.cameraOutput.capturePhoto(with: settings, delegate: self)

            DispatchQueue.main.async {
                self.messageLabel.isHidden = true
                self.overlayView.isHidden = true
            }
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try requestHandler.perform([faceDetectionRequest])
            if let results = faceDetectionRequest.results as? [VNFaceObservation], !results.isEmpty {
                capturePhoto()
            }
        } catch {
            print("❌ خطأ في تحليل الصورة: \(error.localizedDescription)")
        }
    }
}

// MARK: - Photo Capture Delegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
        delegate?.didCapture(image: image)
        dismiss(animated: true)
    }
}

// MARK: - Delegate Protocol
protocol CameraViewControllerDelegate {
    func didCapture(image: UIImage)
}





























// work with just border green
//
//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .camera
//    var uploadType: String
//    var showToast: ((String?, Color?, Bool) -> Void)?
//    var onUploadComplete: ((Bool, UIImage?) -> Void)?
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType
//        picker.modalPresentationStyle = .fullScreen
//        
//        if sourceType == .camera {
//            // لإنجاح أزرار النظام، اجعلها ظاهرة
//            picker.showsCameraControls = true
//            
//            // أنشئ الـOverlay
//            let overlayView = UIView(frame: UIScreen.main.bounds)
//            overlayView.backgroundColor = .clear
//            
//            // اجعل الـOverlay لا يلتقط اللمسات
//            overlayView.isUserInteractionEnabled = false
//            
//            // إطار بنفس نسبة 8.5:5.5. مثلاً 310×200
//            let width: CGFloat = 310
//            let height: CGFloat = 200
//            let greenFrame = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//            greenFrame.center = overlayView.center
//            greenFrame.layer.borderWidth = 4
//            greenFrame.layer.borderColor = UIColor.green.cgColor
//            greenFrame.backgroundColor = .clear
//            
//            // كذلك نجعل الإطار نفسه لا يلتقط اللمسات
//            greenFrame.isUserInteractionEnabled = false
//            
//            overlayView.addSubview(greenFrame)
//            picker.cameraOverlayView = overlayView
//        }
//        
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//        // لا شيء
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // MARK: - Coordinator
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//            if let image = info[.originalImage] as? UIImage {
//                DispatchQueue.main.async {
//                    let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//                    self.parent.selectedImage = image
//                    self.parent.showToast?(
//                        "📤 جاري رفع \(imageType)...",
//                        Color(red: 27/255, green: 62/255, blue: 93/255),
//                        false
//                    )
//                    self.uploadImageToServer(image: image)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("❌ لم يتم التقاط صورة، تم إغلاق الكاميرا بدون تحديد صورة.")
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            DispatchQueue.main.async {
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//        
//        private func uploadImageToServer(image: UIImage) {
//            let uploader = IDUploader()
//            
//            uploader.uploadIDImage(image: image, for: parent.uploadType) { success, imageURL, responseType in
//                DispatchQueue.main.async {
//                    let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//                    
//                    if success, let imageURL = imageURL, let url = URL(string: imageURL), responseType != nil {
//                        if responseType != self.parent.uploadType {
//                            self.parent.showToast?(
//                                " خطأ في التعرف على \(imageType)!\nيرجى المحاولة مجددًا.",
//                                Color.orange.opacity(0.9),
//                                true
//                            )
//                            return
//                        }
//                        
//                        self.downloadImage(from: url)
//                        
//                    } else {
//                        self.parent.showToast?(
//                            "❌ فشل التعرف على \(imageType).\nيرجى المحاولة مجددًا.",
//                            Color.orange.opacity(0.9),
//                            true
//                        )
//                    }
//                }
//            }
//        }
//        
//        private func downloadImage(from url: URL) {
//            let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let downloadedImage = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.parent.onUploadComplete?(true, downloadedImage)
//                        self.parent.showToast?("✅ تم رفع \(imageType) بنجاح!", Color.green, true)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        print(" فشل تحميل \(imageType) من السيرفر.")
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}




import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera
    var uploadType: String
    var showToast: ((String?, Color?, Bool) -> Void)?
    var onUploadComplete: ((Bool, UIImage?) -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .fullScreen
        
        if sourceType == .camera {
            picker.showsCameraControls = true
            
            // إنشاء Overlay
            let overlayView = UIView(frame: UIScreen.main.bounds)
            overlayView.backgroundColor = .clear
            overlayView.isUserInteractionEnabled = false
            
            // 1) حساب الأبعاد نسبيًا
            let screenBounds = UIScreen.main.bounds
            let minSide = min(screenBounds.width, screenBounds.height)
            let scaleFactor: CGFloat = 0.7
            let frameWidth = minSide * scaleFactor
            let ratio: CGFloat = 5.5 / 8.5  // الارتفاع/العرض
            let frameHeight = frameWidth * ratio
            
            let greenFrame = UIView(frame: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
            greenFrame.center = overlayView.center
            greenFrame.layer.borderWidth = 4
            greenFrame.layer.borderColor = UIColor.green.cgColor
            greenFrame.backgroundColor = .clear
            greenFrame.isUserInteractionEnabled = false
            overlayView.addSubview(greenFrame)
            
            // 2) التسمية فوق الإطار
            let label = UILabel()
            label.text = "ضع الهوية داخل الإطار والتقط الصورة"
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .white
            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            label.textAlignment = .center
            label.numberOfLines = 2
            label.isUserInteractionEnabled = false
            
            let labelHeight = frameHeight * 0.15
            let labelY = greenFrame.frame.minY - labelHeight - 10
            label.frame = CGRect(x: greenFrame.frame.minX,
                                 y: labelY,
                                 width: greenFrame.frame.width,
                                 height: labelHeight)
            
            overlayView.addSubview(label)
            
            picker.cameraOverlayView = overlayView
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // لا شيء
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
                    self.parent.selectedImage = image
                    self.parent.showToast?(
                        "📤 جاري رفع \(imageType)...",
                        Color(red: 27/255, green: 62/255, blue: 93/255),
                        false
                    )
                    self.uploadImageToServer(image: image)
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            } else {
                DispatchQueue.main.async {
                    print("❌ لم يتم التقاط صورة.")
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        private func uploadImageToServer(image: UIImage) {
            let uploader = IDUploader()
            
            uploader.uploadIDImage(image: image, for: parent.uploadType) { success, imageURL, responseType in
                DispatchQueue.main.async {
                    let imageType = (self.parent.uploadType == "Face_id") ? "الوجه الأمامي" : "الوجه الخلفي"
                    
                    if success, let imageURL = imageURL, let url = URL(string: imageURL), responseType != nil {
                        if responseType != self.parent.uploadType {
                            self.parent.showToast?(
                                " خطأ في التعرف على \(imageType)!\nيرجى المحاولة مجددًا.",
                                Color.orange.opacity(0.9),
                                true
                            )
                            return
                        }
                        self.downloadImage(from: url)
                    } else {
                        self.parent.showToast?(
                            "❌ فشل التعرف على \(imageType).\nيرجى المحاولة مجددًا.",
                            Color.orange.opacity(0.9),
                            true
                        )
                    }
                }
            }
        }
        
        private func downloadImage(from url: URL) {
            let imageType = (self.parent.uploadType == "Face_id") ? "الوجه الأمامي" : "الوجه الخلفي"
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.parent.onUploadComplete?(true, downloadedImage)
                        self.parent.showToast?("✅ تم رفع \(imageType) بنجاح!", Color.green, true)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("فشل تحميل \(imageType) من السيرفر.")
                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
                        self.parent.onUploadComplete?(false, nil)
                    }
                }
            }.resume()
        }
    }
}











// work with border with text
//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .camera
//    var uploadType: String
//    var showToast: ((String?, Color?, Bool) -> Void)?
//    var onUploadComplete: ((Bool, UIImage?) -> Void)?
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType
//        picker.modalPresentationStyle = .fullScreen
//        
//        if sourceType == .camera {
//            picker.showsCameraControls = true
//            
//            // Overlay رئيسي بشفافية 0% (لا يلتقط اللمسات)
//            let overlayView = UIView(frame: UIScreen.main.bounds)
//            overlayView.backgroundColor = .clear
//            overlayView.isUserInteractionEnabled = false
//            
//            // *** 1) أنشئ إطارًا أخضر بنسبة 8.5 : 5.5 ***
//            let width: CGFloat = 310
//            let height: CGFloat = 200
//            let greenFrame = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//            greenFrame.center = overlayView.center
//            greenFrame.layer.borderWidth = 4
//            greenFrame.layer.borderColor = UIColor.green.cgColor
//            greenFrame.backgroundColor = .clear
//            greenFrame.isUserInteractionEnabled = false
//            overlayView.addSubview(greenFrame)
//            
//            // *** 2) أضف تسمية (UILabel) فوق الإطار الأخضر ***
//            let label = UILabel()
//            label.text = "ضع الهوية داخل الإطار والتقط الصورة"
//            label.font = UIFont.boldSystemFont(ofSize: 16)
//            label.textColor = .white
//            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            label.textAlignment = .center
//            label.numberOfLines = 2
//            label.isUserInteractionEnabled = false // لكي لا يعطل أزرار النظام
//            
//            // حجم التسمية مثلًا: بعرض الإطار الأخضر، وارتفاع 40 نقطة
//            let labelHeight: CGFloat = 40
//            let labelY = greenFrame.frame.minY - labelHeight - 10 // اجعله أعلى الإطار بـ 10 نقاط
//            label.frame = CGRect(x: greenFrame.frame.minX,
//                                 y: labelY,
//                                 width: greenFrame.frame.width,
//                                 height: labelHeight)
//            
//            overlayView.addSubview(label)
//            
//            // *** 3) ربط الـoverlay بالكاميرا ***
//            picker.cameraOverlayView = overlayView
//        }
//        
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//        // لا شيء
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // MARK: - Coordinator
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//            if let image = info[.originalImage] as? UIImage {
//                DispatchQueue.main.async {
//                    let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//                    self.parent.selectedImage = image
//                    self.parent.showToast?(
//                        "📤 جاري رفع \(imageType)...",
//                        Color(red: 27/255, green: 62/255, blue: 93/255),
//                        false
//                    )
//                    self.uploadImageToServer(image: image)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("❌ لم يتم التقاط صورة، تم إغلاق الكاميرا بدون تحديد صورة.")
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            DispatchQueue.main.async {
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//        
//        private func uploadImageToServer(image: UIImage) {
//            let uploader = IDUploader()
//            
//            uploader.uploadIDImage(image: image, for: parent.uploadType) { success, imageURL, responseType in
//                DispatchQueue.main.async {
//                    let imageType = (self.parent.uploadType == "Face_id") ? "الوجه الأمامي" : "الوجه الخلفي"
//                    
//                    if success, let imageURL = imageURL, let url = URL(string: imageURL), responseType != nil {
//                        if responseType != self.parent.uploadType {
//                            self.parent.showToast?(
//                                " خطأ في التعرف على \(imageType)!\nيرجى المحاولة مجددًا.",
//                                Color.orange.opacity(0.9),
//                                true
//                            )
//                            return
//                        }
//                        self.downloadImage(from: url)
//                    } else {
//                        self.parent.showToast?(
//                            "❌ فشل التعرف على \(imageType).\nيرجى المحاولة مجددًا.",
//                            Color.orange.opacity(0.9),
//                            true
//                        )
//                    }
//                }
//            }
//        }
//        
//        private func downloadImage(from url: URL) {
//            let imageType = (self.parent.uploadType == "Face_id") ? "الوجه الأمامي" : "الوجه الخلفي"
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let downloadedImage = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.parent.onUploadComplete?(true, downloadedImage)
//                        self.parent.showToast?("✅ تم رفع \(imageType) بنجاح!", Color.green, true)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        print(" فشل تحميل \(imageType) من السيرفر.")
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}











// work without green border
//
//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .camera
//    var uploadType: String // "Face_id" أو "back_id"
//    var showToast: ((String?, Color?, Bool) -> Void)? //  تحديث `ToastView`
//    var onUploadComplete: ((Bool, UIImage?) -> Void)? //  استكمال الرفع
//
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType
//        picker.modalPresentationStyle = .fullScreen
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
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                DispatchQueue.main.async {
//                    let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//                    self.parent.selectedImage = image
//                    self.parent.showToast?(
//                        "📤 جاري رفع \(imageType)...",
//                        Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255), // ✅ لون مخصص أثناء الرفع
//                        false
//                    )
//                    self.uploadImageToServer(image: image)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("❌ لم يتم التقاط صورة، تم إغلاق الكاميرا بدون تحديد صورة.")
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//
//
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            DispatchQueue.main.async {
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//
//        private func uploadImageToServer(image: UIImage) {
//            let uploader = IDUploader()
//
//            uploader.uploadIDImage(image: image, for: parent.uploadType) { success, imageURL, responseType in
//                DispatchQueue.main.async {
//                    let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//
//                    if success, let imageURL = imageURL, let url = URL(string: imageURL), responseType != nil {
//                        if responseType != self.parent.uploadType {
//                            
//                            self.parent.showToast?(" خطأ في التعرف على \(imageType)!\nيرجى المحاولة مجددًا.", Color.orange.opacity(0.9), true) // ✅ النص يظهر على سطرين
//
//                           // print("⚠️ خطأ: تم إرجاع نوع غير صحيح. المتوقع \(self.parent.uploadType)، ولكن تم استقبال \(responseType ?? "null")")
////                            self.parent.showToast?("⚠️ خطأ في التعرف على \(imageType)!", Color.red, true) // ✅ رسالة مخصصة مع زر "تم"
//                            return
//                        }
//                        
//                        
//         
//
//                        self.downloadImage(from: url)
//
//                    } else {
//                      //  print("⚠️ فشل التعرف على الصورة، تم إرجاع `null`.")
//                        self.parent.showToast?("❌ فشل التعرف على \(imageType).\nيرجى المحاولة مجددًا.", Color.orange.opacity(0.9), true) // ✅ رسالة مخصصة من سطرين
//
////                        self.parent.showToast?("❌ فشل التعرف على \(imageType). يرجى المحاولة مجددًا.", Color.red, true) // ✅ رسالة مخصصة مع زر "تم"
//                    }
//                }
//            }
//        }
//
//        private func downloadImage(from url: URL) {
//            let imageType = self.parent.uploadType == "Face_id" ? "الوجه الأمامي" : "الوجه الخلفي"
//
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let downloadedImage = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.parent.onUploadComplete?(true, downloadedImage)
//                        self.parent.showToast?("✅ تم رفع \(imageType) بنجاح!", Color.green, true) // ✅ رسالة مخصصة مع زر "تم"
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        print(" فشل تحميل \(imageType) من السيرفر.")
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true) // ✅ رسالة مخصصة مع زر "تم"
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}





//work
//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .camera
//    var uploadType: String // "Face_id" أو "back_id"
//    var showToast: ((String?, Color?, Bool) -> Void)? // ✅ دالة لتحديث `ToastView`
//    var onUploadComplete: ((Bool, UIImage?) -> Void)? // ✅ دالة لاستكمال الرفع
//
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType
//        picker.modalPresentationStyle = .fullScreen
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
//                DispatchQueue.main.async {
//                    self.parent.selectedImage = image
//                    self.parent.showToast?("📤 جاري رفع الصورة...", Color.blue, false) // ✅ بدون زر "تم"
//                    self.uploadImageToServer(image: image)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("❌ لم يتم التقاط صورة، تم إغلاق الكاميرا بدون تحديد صورة.")
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            DispatchQueue.main.async {
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//
//        private func uploadImageToServer(image: UIImage) {
//            let uploader = IDUploader()
//
//            uploader.uploadIDImage(image: image, for: parent.uploadType) { success, imageURL, responseType in
//                DispatchQueue.main.async {
//                    if success, let imageURL = imageURL, let url = URL(string: imageURL), responseType != nil {
//
//                        if responseType != self.parent.uploadType {
//                            print("⚠️ خطأ: تم إرجاع نوع غير صحيح. المتوقع \(self.parent.uploadType)، ولكن تم استقبال \(responseType ?? "null")")
//                            self.parent.showToast?("⚠️ خطأ في التعرف على الصورة!", Color.red, true) // ✅ يظهر زر "تم"
//                            return
//                        }
//
//                        self.downloadImage(from: url)
//
//                    } else {
//                        print("⚠️ فشل التعرف على الصورة، تم إرجاع `null`.")
//                        self.parent.showToast?("❌ فشل التعرف على الصورة. يرجى المحاولة مجددًا.", Color.red, true) // ✅ يظهر زر "تم"
//                    }
//                }
//            }
//        }
//
//        private func downloadImage(from url: URL) {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let downloadedImage = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.parent.onUploadComplete?(true, downloadedImage)
//                        self.parent.showToast?("✅ تم رفع الصورة بنجاح!", Color.green, true) // ✅ يظهر زر "تم"
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        print("⚠️ فشل تحميل الصورة من السيرفر.")
//                        self.parent.showToast?("❌ فشل تحميل الصورة من السيرفر.", Color.red, true) // ✅ يظهر زر "تم"
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}






// work without progress

//import SwiftUI
//import UIKit


//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .camera
//    var uploadType: String // "Face_id" أو "back_id"
//    var onUploadComplete: ((Bool, UIImage?) -> Void)? // لمعالجة النتيجة بعد الرفع
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType
//        picker.modalPresentationStyle = .fullScreen
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
//                DispatchQueue.main.async {
//                    self.parent.selectedImage = image
//                    self.uploadImageToServer(image: image)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            DispatchQueue.main.async {
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//
//        private func uploadImageToServer(image: UIImage) {
//            let uploader = IDUploader()
//            
//            let config = URLSessionConfiguration.default
//            config.timeoutIntervalForRequest = 10  // ⏳ تحديد مهلة 10 ثوانٍ فقط
//            let session = URLSession(configuration: config)
//
//            uploader.uploadIDImage(image: image, for: parent.uploadType) { success, imageURL, responseType in
//                DispatchQueue.main.async {
//                    if success, let imageURL = imageURL, let url = URL(string: imageURL), responseType != nil {
//                        
//                        // ✅ التأكد من أن الصورة تتطابق مع نوعها
//                        if responseType != self.parent.uploadType {
//                            print("⚠️ خطأ: تم إرجاع نوع غير صحيح. المتوقع \(self.parent.uploadType)، ولكن تم استقبال \(responseType ?? "null")")
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                self.parent.onUploadComplete?(false, nil)
//                            }
//                            return
//                        }
//
//                        // ✅ تحميل الصورة عند النجاح فقط
//                        self.downloadImage(from: url)
//
//                    } else {
//                        print("⚠️ فشل التعرف على الصورة، تم إرجاع `null`.")
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            self.parent.onUploadComplete?(false, nil)
//                        }
//                    }
//                }
//            }
//        }
//
//
//
//
//
//
//
//        private func downloadImage(from url: URL) {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let downloadedImage = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.parent.onUploadComplete?(true, downloadedImage)
//                        print("✅ تم تحميل الصورة وإرسال النجاح للمستخدم.")
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        print("⚠️ فشل تحميل الصورة من السيرفر.")
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//
//
//    }
//}






//old work without cut
import SwiftUI
import UIKit

struct ImagePicker3: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType // تحديد مصدر الصور بشكل ديناميكي

        // تشغيل الكاميرا في خيط الخلفية لتجنب تجمد التطبيق
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                // تشغيل `UIImagePickerController` على `Main Thread` بعد تحميله في الخلفية
                picker.modalPresentationStyle = .fullScreen
            }
        }
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker3

        init(_ parent: ImagePicker3) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = info[.originalImage] as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}





//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType // تحديد مصدر الصور بشكل ديناميكي
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
        checkAuthorizationStatus() // التحقق من الإذن عند بدء التطبيق
    }

    func requestLocation() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async { // تأكد من تحديث الواجهة الرئيسية عند الحاجة
                self.locationError = nil
            }

            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus {
                case .notDetermined:
                    DispatchQueue.main.async {
                        self.locationManager.requestWhenInUseAuthorization()
                    }
                case .restricted, .denied:
                    DispatchQueue.main.async {
                        self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
                        self.openAppSettings()
                    }
                case .authorizedWhenInUse, .authorizedAlways:
                    self.locationManager.requestLocation()
                @unknown default:
                    DispatchQueue.main.async {
                        self.locationError = "حالة غير معروفة."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.locationError = "خدمات الموقع معطلة. يرجى تفعيلها من إعدادات الجهاز."
                }
            }
        }
    }

    private func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global(qos: .background).async {
                self.locationManager.requestLocation()
            }
        @unknown default:
            DispatchQueue.main.async {
                self.locationError = "حالة غير معروفة."
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.global(qos: .background).async {
            switch status {
            case .notDetermined:
                print("🔹 لم يتم تحديد الإذن.")
            case .restricted, .denied:
                DispatchQueue.main.async {
                    self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
                }
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            @unknown default:
                DispatchQueue.main.async {
                    self.locationError = "🔸 حالة غير معروفة."
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            DispatchQueue.main.async {
                self.locationError = "⚠️ لم يتم تحديث الموقع."
            }
            return
        }
        
        DispatchQueue.main.async {
            self.location = firstLocation
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            if let clError = error as? CLError {
                switch clError.code {
                case .denied:
                    self.locationError = "⚠️ تم رفض الإذن. يرجى تمكينه من الإعدادات."
                case .locationUnknown:
                    self.locationError = "⚠️ موقع غير معروف."
                default:
                    self.locationError = "⚠️ خطأ: \(error.localizedDescription)"
                }
            } else {
                self.locationError = "⚠️ خطأ: \(error.localizedDescription)"
            }
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}





// 2025-2-18 work with alert
//import Foundation
//import CoreLocation
//import UIKit
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var location: CLLocation?
//    @Published var locationError: String?
//
//    override init() {
//        super.init()
//        configureLocationManager()
//    }
//
//    private func configureLocationManager() {
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        // التحقق من حالة الإذن عند بدء التطبيق
//        checkAuthorizationStatus()
//    }
//
//    func requestLocation() {
//        self.locationError = nil
//
//        // التحقق من حالة خدمات الموقع وصلاحيات الإذن
//        if CLLocationManager.locationServicesEnabled() {
//            switch locationManager.authorizationStatus {
//            case .notDetermined:
//                // طلب الإذن فقط إذا لم يتم تحديده مسبقًا
//                locationManager.requestWhenInUseAuthorization()
//            case .restricted, .denied:
//                self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
//                // فتح الإعدادات إذا تم رفض الإذن
//                if let url = URL(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url)
//                }
//            case .authorizedWhenInUse, .authorizedAlways:
//                locationManager.requestLocation()
//            @unknown default:
//                self.locationError = "حالة غير معروفة."
//            }
//        } else {
//            self.locationError = "خدمات الموقع معطلة. يرجى تفعيلها من إعدادات الجهاز."
//        }
//    }
//
//    func checkAuthorizationStatus() {
//        // التحقق من الإذن عند بدء التطبيق
//        let status = locationManager.authorizationStatus
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted, .denied:
//            self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.requestLocation()
//        @unknown default:
//            self.locationError = "حالة غير معروفة."
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        // التعامل مع التغير في حالة الإذن
//        switch status {
//        case .notDetermined:
//            print("لم يتم تحديد الإذن.")
//        case .restricted, .denied:
//            self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.requestLocation()
//        @unknown default:
//            print("حالة غير معروفة.")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let firstLocation = locations.first else {
//            self.locationError = "لم يتم تحديث الموقع."
//            return
//        }
//        self.location = firstLocation
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if let clError = error as? CLError {
//            switch clError.code {
//            case .denied:
//                self.locationError = "تم رفض الإذن. يرجى تمكينه من الإعدادات."
//            case .locationUnknown:
//                self.locationError = "موقع غير معروف."
//            default:
//                self.locationError = "خطأ: \(error.localizedDescription)"
//            }
//        } else {
//            self.locationError = "خطأ: \(error.localizedDescription)"
//        }
//    }
//}







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

//import SwiftUI
//
//struct ImagePicker2: UIViewControllerRepresentable {
//    @Binding var imageData: Data?
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker2
//
//        init(parent: ImagePicker2) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.imageData = image.jpegData(compressionQuality: 1.0)
//            }
//            picker.dismiss(animated: true)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//}


// end image pi



import UIKit

func getDeviceModel() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.compactMap { $0.value as? Int8 }
        .map { String(UnicodeScalar(UInt8($0))) }
        .joined()
        .trimmingCharacters(in: .controlCharacters) // إزالة الرموز غير المرغوب فيها

    // قائمة الأجهزة منذ 2015 حتى 2024
    let deviceMap: [String: String] = [
        // iPhone
        "iPhone8,1": "iPhone 6s",
        "iPhone8,2": "iPhone 6s Plus",
        "iPhone8,4": "iPhone SE (1st Generation)",
        "iPhone9,1": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone10,1": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X",
        "iPhone11,8": "iPhone XR",
        "iPhone11,2": "iPhone XS",
        "iPhone11,4": "iPhone XS Max",
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone13,1": "iPhone 12 Mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,4": "iPhone 13 Mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,6": "iPhone SE (3rd Generation)",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone16,1": "iPhone 15",
        "iPhone16,2": "iPhone 15 Plus",
        "iPhone16,3": "iPhone 15 Pro",
        "iPhone16,4": "iPhone 15 Pro Max",
        "iPhone16,5": "iPhone SE (4th Generation)",
        "iPhone17,1": "iPhone 16",
        "iPhone17,2": "iPhone 16 Plus",
        "iPhone17,3": "iPhone 16 Pro",
        "iPhone17,4": "iPhone 16 Pro Max",

        // iPad
        "iPad6,7": "iPad Pro (12.9-inch) (1st Generation)",
        "iPad6,8": "iPad Pro (12.9-inch) (1st Generation)",
        "iPad6,3": "iPad Pro (9.7-inch)",
        "iPad6,4": "iPad Pro (9.7-inch)",
        "iPad7,1": "iPad Pro (12.9-inch) (2nd Generation)",
        "iPad7,2": "iPad Pro (12.9-inch) (2nd Generation)",
        "iPad7,3": "iPad Pro (10.5-inch)",
        "iPad7,4": "iPad Pro (10.5-inch)",
        "iPad11,1": "iPad Mini (5th Generation)",
        "iPad11,2": "iPad Mini (5th Generation)",
        "iPad11,3": "iPad Air (3rd Generation)",
        "iPad11,4": "iPad Air (3rd Generation)",
        "iPad8,1": "iPad Pro (11-inch) (1st Generation)",
        "iPad8,2": "iPad Pro (11-inch) (1st Generation)",
        "iPad8,3": "iPad Pro (11-inch) (1st Generation)",
        "iPad8,4": "iPad Pro (11-inch) (1st Generation)",
        "iPad8,5": "iPad Pro (12.9-inch) (3rd Generation)",
        "iPad8,6": "iPad Pro (12.9-inch) (3rd Generation)",
        "iPad8,7": "iPad Pro (12.9-inch) (3rd Generation)",
        "iPad8,8": "iPad Pro (12.9-inch) (3rd Generation)",
        "iPad13,1": "iPad Air (4th Generation)",
        "iPad13,2": "iPad Air (4th Generation)",
        "iPad14,1": "iPad Mini (6th Generation)",
        "iPad14,2": "iPad Mini (6th Generation)",
        "iPad13,16": "iPad Air (5th Generation)",
        "iPad13,17": "iPad Air (5th Generation)",
        "iPad13,18": "iPad (10th Generation)",
        "iPad13,19": "iPad (10th Generation)",
        "iPad14,3": "iPad Pro (11-inch) (4th Generation)",
        "iPad14,4": "iPad Pro (11-inch) (4th Generation)",
        "iPad14,5": "iPad Pro (12.9-inch) (6th Generation)",
        "iPad14,6": "iPad Pro (12.9-inch) (6th Generation)",
        "iPad15,1": "iPad Pro (11-inch) (5th Generation)",
        "iPad15,2": "iPad Pro (12.9-inch) (7th Generation)",
        "iPad15,3": "iPad (11th Generation)",
        "iPad15,4": "iPad (11th Generation)",
        "iPad16,1": "iPad Air (6th Generation)",
        "iPad16,2": "iPad Mini (7th Generation)"
    ]

    return deviceMap[identifier] ?? "Unknown Device (\(identifier))" // معالجتنا الافتراضية
}
