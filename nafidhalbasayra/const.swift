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


 // سلفي


// last update change btn to be camera btn
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
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // عناصر واجهة المستخدم
    let blackOverlayView = UIView()
    let transparentOvalPath = CAShapeLayer()
    let ovalBorderView = UIView()
    let captureButton = UIButton()
    let messageLabel = UILabel()
    
    // متغير لحفظ حالة اكتشاف الوجه
    var isFaceDetected = false
    
    // إطار البيضاوي للتحقق
    var ovalFrame: CGRect = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupCamera()
        }
    }

    // إعداد واجهة المستخدم
    func setupUI() {
        view.backgroundColor = .black
        
        // تحديد إطار البيضاوي
        ovalFrame = CGRect(
            x: (view.bounds.width - 250) / 2,
            y: (view.bounds.height - 350) / 2,
            width: 250,
            height: 350
        )
        
        // إضافة الخلفية السوداء شبه الشفافة
        blackOverlayView.frame = view.bounds
        blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.addSubview(blackOverlayView)
        
        // إنشاء مساحة شفافة بيضاوية في الوسط
        let path = UIBezierPath(rect: view.bounds)
        let ovalPath = UIBezierPath(ovalIn: ovalFrame)
        path.append(ovalPath)
        path.usesEvenOddFillRule = true
        
        transparentOvalPath.path = path.cgPath
        transparentOvalPath.fillRule = .evenOdd
        transparentOvalPath.fillColor = UIColor.black.withAlphaComponent(0.9).cgColor
        blackOverlayView.layer.mask = transparentOvalPath
        
        // إضافة إطار بيضاوي
        ovalBorderView.frame = ovalFrame
        ovalBorderView.backgroundColor = .clear
        ovalBorderView.layer.borderWidth = 3
        ovalBorderView.layer.borderColor = UIColor.red.cgColor
        ovalBorderView.layer.cornerRadius = ovalFrame.width / 2
        
        // رسم شكل بيضاوي للإطار
        let borderPath = UIBezierPath(ovalIn: ovalBorderView.bounds)
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.red.cgColor
        borderLayer.lineWidth = 3
        ovalBorderView.layer.addSublayer(borderLayer)
        view.addSubview(ovalBorderView)
        
        // إعداد زر الالتقاط
        let buttonSize: CGFloat = 80
        captureButton.frame = CGRect(
            x: (view.bounds.width - buttonSize) / 2,
            y: view.bounds.height - 200,
            width: buttonSize,
            height: buttonSize
        )
        
        // الدائرة الخارجية البيضاء الكبيرة
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = buttonSize / 2
        captureButton.layer.shadowColor = UIColor.black.cgColor
        captureButton.layer.shadowOpacity = 0.3
        captureButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        captureButton.layer.shadowRadius = 4
        
        // إضافة أيقونة الكاميرا
        let cameraIcon = UIImageView()
        cameraIcon.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        cameraIcon.contentMode = .scaleAspectFit
        cameraIcon.tintColor = .black
        
        // رسم أيقونة الكاميرا باستخدام SF Symbols
        if let cameraImage = UIImage(systemName: "camera.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)) {
            cameraIcon.image = cameraImage
        } else {
            // بديل: رسم أيقونة كاميرا بسيطة
            cameraIcon.backgroundColor = .black
            cameraIcon.layer.cornerRadius = 10
            cameraIcon.layer.borderWidth = 2
            cameraIcon.layer.borderColor = UIColor.black.cgColor
        }
        
        cameraIcon.isUserInteractionEnabled = false
        captureButton.addSubview(cameraIcon)
        
        // إضافة حلقة خارجية للزيادة في الوضوح
        let ringLayer = CAShapeLayer()
        let ringPath = UIBezierPath(ovalIn: CGRect(x: 2, y: 2, width: buttonSize - 4, height: buttonSize - 4))
        ringLayer.path = ringPath.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.black.withAlphaComponent(0.1).cgColor
        ringLayer.lineWidth = 2
        captureButton.layer.addSublayer(ringLayer)
        
        captureButton.isEnabled = false
        captureButton.alpha = 0.5
        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        
        view.addSubview(captureButton)
        
        // إعداد نص التنبيه
        messageLabel.frame = CGRect(
            x: 20,
            y: 100,
            width: view.bounds.width - 40,
            height: 60
        )
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 2
        messageLabel.backgroundColor = .clear
        messageLabel.text = "جاري البحث عن وجه..."
        view.addSubview(messageLabel)
    }

    func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
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
                self.videoPreviewLayer = previewLayer
                self.view.layer.insertSublayer(previewLayer, at: 0)
            }

            session.startRunning()
            self.captureSession = session

        } catch {
            print("❌ خطأ في إعداد الكاميرا: \(error.localizedDescription)")
        }
    }

    // دالة للتحقق من أن الوجه داخل الإطار البيضاوي
    func isFaceInsideOval(face: VNFaceObservation) -> Bool {
        guard let previewLayer = videoPreviewLayer else { return false }
        
        // تحويل إحداثيات الوجه من نظام Vision إلى نظام الواجهة
        let faceRect = VNImageRectForNormalizedRect(
            face.boundingBox,
            Int(previewLayer.frame.width),
            Int(previewLayer.frame.height)
        )
        
        // تعديل إحداثيات الوجه لتتوافق مع نظام iOS
        let convertedRect = CGRect(
            x: faceRect.minX,
            y: previewLayer.frame.height - faceRect.maxY,
            width: faceRect.width,
            height: faceRect.height
        )
        
        // حساب مركز الوجه
        let faceCenterX = convertedRect.midX
        let faceCenterY = convertedRect.midY
        
        // حساب مركز وأبعاد البيضاوي
        let ovalCenterX = ovalFrame.midX
        let ovalCenterY = ovalFrame.midY
        let ovalRadiusX = ovalFrame.width / 2
        let ovalRadiusY = ovalFrame.height / 2
        
        // معادلة البيضاوي لفحص إذا كان مركز الوجه داخل البيضاوي
        let normalizedX = (faceCenterX - ovalCenterX) / ovalRadiusX
        let normalizedY = (faceCenterY - ovalCenterY) / ovalRadiusY
        let result = (normalizedX * normalizedX) + (normalizedY * normalizedY)
        
        // التحقق من أن معظم الوجه داخل البيضاوي
        let faceInOval = result <= 0.8 // استخدام 0.8 بدلاً من 1.0 للتسامح مع الحواف
        
        return faceInOval
    }

    // تحديث حالة اكتشاف الوجه
    func updateFaceDetectionState(faceDetected: Bool) {
        DispatchQueue.main.async {
            self.isFaceDetected = faceDetected
            
            // تحديث لون الإطار
            if faceDetected {
                self.ovalBorderView.layer.borderColor = UIColor.green.cgColor
                if let borderLayer = self.ovalBorderView.layer.sublayers?.first as? CAShapeLayer {
                    borderLayer.strokeColor = UIColor.green.cgColor
                }
                self.messageLabel.text = "ضع وجهك داخل الإطار ثم اضغط زر الالتقاط"
                self.captureButton.isEnabled = true
                self.captureButton.alpha = 1.0
            } else {
                self.ovalBorderView.layer.borderColor = UIColor.red.cgColor
                if let borderLayer = self.ovalBorderView.layer.sublayers?.first as? CAShapeLayer {
                    borderLayer.strokeColor = UIColor.red.cgColor
                }
                self.messageLabel.text = "جاري البحث عن وجه..."
                self.captureButton.isEnabled = false
                self.captureButton.alpha = 0.5
            }
        }
    }

    @objc func captureButtonTapped() {
        guard isFaceDetected else { return }
        
        // تأثير الضغط على الزر
        UIView.animate(withDuration: 0.1, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.captureButton.transform = .identity
            }
        }
        
        let settings = AVCapturePhotoSettings()
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try requestHandler.perform([faceDetectionRequest])
            
            if let results = faceDetectionRequest.results as? [VNFaceObservation], !results.isEmpty {
                // فحص إذا كان أي وجه داخل الإطار البيضاوي
                var faceFoundInOval = false
                for face in results {
                    if isFaceInsideOval(face: face) {
                        faceFoundInOval = true
                        break
                    }
                }
                updateFaceDetectionState(faceDetected: faceFoundInOval)
            } else {
                // لا يوجد وجه
                updateFaceDetectionState(faceDetected: false)
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



// work with frame & increase black out
//import SwiftUI
//import UIKit
//import AVFoundation
//import Vision
//
//struct SelfieCameraPicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let viewController = CameraViewController()
//        viewController.delegate = context.coordinator
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, CameraViewControllerDelegate {
//        let parent: SelfieCameraPicker
//
//        init(_ parent: SelfieCameraPicker) {
//            self.parent = parent
//        }
//
//        func didCapture(image: UIImage) {
//            DispatchQueue.main.async {
//                self.parent.selectedImage = image
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//    }
//}
//
//// MARK: - Camera ViewController
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    var captureSession: AVCaptureSession?
//    var cameraOutput = AVCapturePhotoOutput()
//    let faceDetectionRequest = VNDetectFaceRectanglesRequest()
//    var delegate: CameraViewControllerDelegate?
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    
//    // عناصر واجهة المستخدم
//    let blackOverlayView = UIView()
//    let transparentOvalPath = CAShapeLayer()
//    let ovalBorderView = UIView()
//    let captureButton = UIButton()
//    let messageLabel = UILabel()
//    
//    // متغير لحفظ حالة اكتشاف الوجه
//    var isFaceDetected = false
//    
//    // إطار البيضاوي للتحقق
//    var ovalFrame: CGRect = .zero
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.setupCamera()
//        }
//    }
//
//    // إعداد واجهة المستخدم
//    func setupUI() {
//        view.backgroundColor = .black
//        
//        // تحديد إطار البيضاوي
//        ovalFrame = CGRect(
//            x: (view.bounds.width - 250) / 2,
//            y: (view.bounds.height - 350) / 2,
//            width: 250,
//            height: 350
//        )
//        
//        // إضافة الخلفية السوداء شبه الشفافة
//        blackOverlayView.frame = view.bounds
//        blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//        view.addSubview(blackOverlayView)
//        
//        // إنشاء مساحة شفافة بيضاوية في الوسط
//        let path = UIBezierPath(rect: view.bounds)
//        let ovalPath = UIBezierPath(ovalIn: ovalFrame)
//        path.append(ovalPath)
//        path.usesEvenOddFillRule = true
//        
//        transparentOvalPath.path = path.cgPath
//        transparentOvalPath.fillRule = .evenOdd
//        transparentOvalPath.fillColor = UIColor.black.withAlphaComponent(0.9).cgColor
//        blackOverlayView.layer.mask = transparentOvalPath
//        
//        // إضافة إطار بيضاوي
//        ovalBorderView.frame = ovalFrame
//        ovalBorderView.backgroundColor = .clear
//        ovalBorderView.layer.borderWidth = 3
//        ovalBorderView.layer.borderColor = UIColor.red.cgColor
//        ovalBorderView.layer.cornerRadius = ovalFrame.width / 2
//        
//        // رسم شكل بيضاوي للإطار
//        let borderPath = UIBezierPath(ovalIn: ovalBorderView.bounds)
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = borderPath.cgPath
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.strokeColor = UIColor.red.cgColor
//        borderLayer.lineWidth = 3
//        ovalBorderView.layer.addSublayer(borderLayer)
//        view.addSubview(ovalBorderView)
//        
//        // إعداد زر الالتقاط
//        let buttonSize: CGFloat = 80
//        captureButton.frame = CGRect(
//            x: (view.bounds.width - buttonSize) / 2,
//            y: view.bounds.height - 200,
//            width: buttonSize,
//            height: buttonSize
//        )
//        
//        // الدائرة الخارجية البيضاء الكبيرة
//        captureButton.backgroundColor = .white
//        captureButton.layer.cornerRadius = buttonSize / 2
//        captureButton.layer.shadowColor = UIColor.black.cgColor
//        captureButton.layer.shadowOpacity = 0.3
//        captureButton.layer.shadowOffset = CGSize(width: 0, height: 2)
//        captureButton.layer.shadowRadius = 4
//        
//        // الحلقة الخارجية البيضاء الرفيعة
//        let outerRing = UIView(frame: CGRect(x: 4, y: 4, width: buttonSize - 8, height: buttonSize - 8))
//        outerRing.backgroundColor = .clear
//        outerRing.layer.cornerRadius = (buttonSize - 8) / 2
//        outerRing.layer.borderWidth = 3
//        outerRing.layer.borderColor = UIColor.white.cgColor
//        outerRing.isUserInteractionEnabled = false
//        captureButton.addSubview(outerRing)
//        
//        // الدائرة الداخلية البيضاء
//        let innerCircle = UIView(frame: CGRect(x: 12, y: 12, width: buttonSize - 24, height: buttonSize - 24))
//        innerCircle.backgroundColor = .white
//        innerCircle.layer.cornerRadius = (buttonSize - 24) / 2
//        innerCircle.isUserInteractionEnabled = false
//        captureButton.addSubview(innerCircle)
//        
//        captureButton.isEnabled = false
//        captureButton.alpha = 0.5
//        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
//        
//        view.addSubview(captureButton)
//        
//        // إعداد نص التنبيه
//        messageLabel.frame = CGRect(
//            x: 20,
//            y: 100,
//            width: view.bounds.width - 40,
//            height: 60
//        )
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        messageLabel.textColor = .white
//        messageLabel.numberOfLines = 2
//        messageLabel.backgroundColor = .clear
//        messageLabel.text = "جاري البحث عن وجه..."
//        view.addSubview(messageLabel)
//    }
//
//    func setupCamera() {
//        let session = AVCaptureSession()
//        session.sessionPreset = .photo
//
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            return
//        }
//
//        do {
//            let input = try AVCaptureDeviceInput(device: frontCamera)
//            if session.canAddInput(input) {
//                session.addInput(input)
//            }
//
//            if session.canAddOutput(cameraOutput) {
//                session.addOutput(cameraOutput)
//            }
//
//            let videoOutput = AVCaptureVideoDataOutput()
//            if session.canAddOutput(videoOutput) {
//                session.addOutput(videoOutput)
//                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
//            }
//
//            DispatchQueue.main.async {
//                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//                previewLayer.videoGravity = .resizeAspectFill
//                previewLayer.frame = self.view.bounds
//                self.videoPreviewLayer = previewLayer
//                self.view.layer.insertSublayer(previewLayer, at: 0)
//            }
//
//            session.startRunning()
//            self.captureSession = session
//
//        } catch {
//            print("❌ خطأ في إعداد الكاميرا: \(error.localizedDescription)")
//        }
//    }
//
//    // دالة للتحقق من أن الوجه داخل الإطار البيضاوي
//    func isFaceInsideOval(face: VNFaceObservation) -> Bool {
//        guard let previewLayer = videoPreviewLayer else { return false }
//        
//        // تحويل إحداثيات الوجه من نظام Vision إلى نظام الواجهة
//        let faceRect = VNImageRectForNormalizedRect(
//            face.boundingBox,
//            Int(previewLayer.frame.width),
//            Int(previewLayer.frame.height)
//        )
//        
//        // تعديل إحداثيات الوجه لتتوافق مع نظام iOS
//        let convertedRect = CGRect(
//            x: faceRect.minX,
//            y: previewLayer.frame.height - faceRect.maxY,
//            width: faceRect.width,
//            height: faceRect.height
//        )
//        
//        // حساب مركز الوجه
//        let faceCenterX = convertedRect.midX
//        let faceCenterY = convertedRect.midY
//        
//        // حساب مركز وأبعاد البيضاوي
//        let ovalCenterX = ovalFrame.midX
//        let ovalCenterY = ovalFrame.midY
//        let ovalRadiusX = ovalFrame.width / 2
//        let ovalRadiusY = ovalFrame.height / 2
//        
//        // معادلة البيضاوي لفحص إذا كان مركز الوجه داخل البيضاوي
//        let normalizedX = (faceCenterX - ovalCenterX) / ovalRadiusX
//        let normalizedY = (faceCenterY - ovalCenterY) / ovalRadiusY
//        let result = (normalizedX * normalizedX) + (normalizedY * normalizedY)
//        
//        // التحقق من أن معظم الوجه داخل البيضاوي
//        let faceInOval = result <= 0.8 // استخدام 0.8 بدلاً من 1.0 للتسامح مع الحواف
//        
//        return faceInOval
//    }
//
//    // تحديث حالة اكتشاف الوجه
//    func updateFaceDetectionState(faceDetected: Bool) {
//        DispatchQueue.main.async {
//            self.isFaceDetected = faceDetected
//            
//            // تحديث لون الإطار
//            if faceDetected {
//                self.ovalBorderView.layer.borderColor = UIColor.green.cgColor
//                if let borderLayer = self.ovalBorderView.layer.sublayers?.first as? CAShapeLayer {
//                    borderLayer.strokeColor = UIColor.green.cgColor
//                }
//                self.messageLabel.text = "ضع وجهك داخل الإطار ثم اضغط زر الالتقاط"
//                self.captureButton.isEnabled = true
//                self.captureButton.alpha = 1.0
//            } else {
//                self.ovalBorderView.layer.borderColor = UIColor.red.cgColor
//                if let borderLayer = self.ovalBorderView.layer.sublayers?.first as? CAShapeLayer {
//                    borderLayer.strokeColor = UIColor.red.cgColor
//                }
//                self.messageLabel.text = "جاري البحث عن وجه..."
//                self.captureButton.isEnabled = false
//                self.captureButton.alpha = 0.5
//            }
//        }
//    }
//
//    @objc func captureButtonTapped() {
//        guard isFaceDetected else { return }
//        
//        let settings = AVCapturePhotoSettings()
//        self.cameraOutput.capturePhoto(with: settings, delegate: self)
//    }
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try requestHandler.perform([faceDetectionRequest])
//            
//            if let results = faceDetectionRequest.results as? [VNFaceObservation], !results.isEmpty {
//                // فحص إذا كان أي وجه داخل الإطار البيضاوي
//                var faceFoundInOval = false
//                for face in results {
//                    if isFaceInsideOval(face: face) {
//                        faceFoundInOval = true
//                        break
//                    }
//                }
//                updateFaceDetectionState(faceDetected: faceFoundInOval)
//            } else {
//                // لا يوجد وجه
//                updateFaceDetectionState(faceDetected: false)
//            }
//        } catch {
//            print("❌ خطأ في تحليل الصورة: \(error.localizedDescription)")
//        }
//    }
//}
//
//// MARK: - Photo Capture Delegate
//extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
//        delegate?.didCapture(image: image)
//        dismiss(animated: true)
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol CameraViewControllerDelegate {
//    func didCapture(image: UIImage)
//}







// work with frame
//import SwiftUI
//import UIKit
//import AVFoundation
//import Vision
//
//struct SelfieCameraPicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let viewController = CameraViewController()
//        viewController.delegate = context.coordinator
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, CameraViewControllerDelegate {
//        let parent: SelfieCameraPicker
//
//        init(_ parent: SelfieCameraPicker) {
//            self.parent = parent
//        }
//
//        func didCapture(image: UIImage) {
//            DispatchQueue.main.async {
//                self.parent.selectedImage = image
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//    }
//}
//
//// MARK: - Camera ViewController
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    var captureSession: AVCaptureSession?
//    var cameraOutput = AVCapturePhotoOutput()
//    let faceDetectionRequest = VNDetectFaceRectanglesRequest()
//    var delegate: CameraViewControllerDelegate?
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    
//    // عناصر واجهة المستخدم
//    let blackOverlayView = UIView()
//    let transparentOvalPath = CAShapeLayer()
//    let ovalBorderView = UIView()
//    let captureButton = UIButton()
//    let messageLabel = UILabel()
//    
//    // متغير لحفظ حالة اكتشاف الوجه
//    var isFaceDetected = false
//    
//    // إطار البيضاوي للتحقق
//    var ovalFrame: CGRect = .zero
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.setupCamera()
//        }
//    }
//
//    // إعداد واجهة المستخدم
//    func setupUI() {
//        view.backgroundColor = .black
//        
//        // تحديد إطار البيضاوي
//        ovalFrame = CGRect(
//            x: (view.bounds.width - 250) / 2,
//            y: (view.bounds.height - 350) / 2,
//            width: 250,
//            height: 350
//        )
//        
//        // إضافة الخلفية السوداء شبه الشفافة
//        blackOverlayView.frame = view.bounds
//        blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        view.addSubview(blackOverlayView)
//        
//        // إنشاء مساحة شفافة بيضاوية في الوسط
//        let path = UIBezierPath(rect: view.bounds)
//        let ovalPath = UIBezierPath(ovalIn: ovalFrame)
//        path.append(ovalPath)
//        path.usesEvenOddFillRule = true
//        
//        transparentOvalPath.path = path.cgPath
//        transparentOvalPath.fillRule = .evenOdd
//        transparentOvalPath.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
//        blackOverlayView.layer.mask = transparentOvalPath
//        
//        // إضافة إطار بيضاوي
//        ovalBorderView.frame = ovalFrame
//        ovalBorderView.backgroundColor = .clear
//        ovalBorderView.layer.borderWidth = 3
//        ovalBorderView.layer.borderColor = UIColor.red.cgColor
//        ovalBorderView.layer.cornerRadius = ovalFrame.width / 2
//        
//        // رسم شكل بيضاوي للإطار
//        let borderPath = UIBezierPath(ovalIn: ovalBorderView.bounds)
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = borderPath.cgPath
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.strokeColor = UIColor.red.cgColor
//        borderLayer.lineWidth = 3
//        ovalBorderView.layer.addSublayer(borderLayer)
//        view.addSubview(ovalBorderView)
//        
//        // إعداد زر الالتقاط
//        let buttonSize: CGFloat = 80
//        captureButton.frame = CGRect(
//            x: (view.bounds.width - buttonSize) / 2,
//            y: view.bounds.height - 150,
//            width: buttonSize,
//            height: buttonSize
//        )
//        
//        // الدائرة الخارجية البيضاء الكبيرة
//        captureButton.backgroundColor = .white
//        captureButton.layer.cornerRadius = buttonSize / 2
//        captureButton.layer.shadowColor = UIColor.black.cgColor
//        captureButton.layer.shadowOpacity = 0.3
//        captureButton.layer.shadowOffset = CGSize(width: 0, height: 2)
//        captureButton.layer.shadowRadius = 4
//        
//        // الحلقة الخارجية البيضاء الرفيعة
//        let outerRing = UIView(frame: CGRect(x: 4, y: 4, width: buttonSize - 8, height: buttonSize - 8))
//        outerRing.backgroundColor = .clear
//        outerRing.layer.cornerRadius = (buttonSize - 8) / 2
//        outerRing.layer.borderWidth = 3
//        outerRing.layer.borderColor = UIColor.white.cgColor
//        outerRing.isUserInteractionEnabled = false
//        captureButton.addSubview(outerRing)
//        
//        // الدائرة الداخلية البيضاء
//        let innerCircle = UIView(frame: CGRect(x: 12, y: 12, width: buttonSize - 24, height: buttonSize - 24))
//        innerCircle.backgroundColor = .white
//        innerCircle.layer.cornerRadius = (buttonSize - 24) / 2
//        innerCircle.isUserInteractionEnabled = false
//        captureButton.addSubview(innerCircle)
//        
//        captureButton.isEnabled = false
//        captureButton.alpha = 0.5
//        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
//        
//        view.addSubview(captureButton)
//        
//        // إعداد نص التنبيه
//        messageLabel.frame = CGRect(
//            x: 20,
//            y: 100,
//            width: view.bounds.width - 40,
//            height: 60
//        )
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        messageLabel.textColor = .white
//        messageLabel.numberOfLines = 2
//        messageLabel.backgroundColor = .clear
//        messageLabel.text = "جاري البحث عن وجه..."
//        view.addSubview(messageLabel)
//    }
//
//    func setupCamera() {
//        let session = AVCaptureSession()
//        session.sessionPreset = .photo
//
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            return
//        }
//
//        do {
//            let input = try AVCaptureDeviceInput(device: frontCamera)
//            if session.canAddInput(input) {
//                session.addInput(input)
//            }
//
//            if session.canAddOutput(cameraOutput) {
//                session.addOutput(cameraOutput)
//            }
//
//            let videoOutput = AVCaptureVideoDataOutput()
//            if session.canAddOutput(videoOutput) {
//                session.addOutput(videoOutput)
//                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
//            }
//
//            DispatchQueue.main.async {
//                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//                previewLayer.videoGravity = .resizeAspectFill
//                previewLayer.frame = self.view.bounds
//                self.videoPreviewLayer = previewLayer
//                self.view.layer.insertSublayer(previewLayer, at: 0)
//            }
//
//            session.startRunning()
//            self.captureSession = session
//
//        } catch {
//            print("❌ خطأ في إعداد الكاميرا: \(error.localizedDescription)")
//        }
//    }
//
//    // دالة للتحقق من أن الوجه داخل الإطار البيضاوي
//    func isFaceInsideOval(face: VNFaceObservation) -> Bool {
//        guard let previewLayer = videoPreviewLayer else { return false }
//        
//        // تحويل إحداثيات الوجه من نظام Vision إلى نظام الواجهة
//        let faceRect = VNImageRectForNormalizedRect(
//            face.boundingBox,
//            Int(previewLayer.frame.width),
//            Int(previewLayer.frame.height)
//        )
//        
//        // تعديل إحداثيات الوجه لتتوافق مع نظام iOS
//        let convertedRect = CGRect(
//            x: faceRect.minX,
//            y: previewLayer.frame.height - faceRect.maxY,
//            width: faceRect.width,
//            height: faceRect.height
//        )
//        
//        // حساب مركز الوجه
//        let faceCenterX = convertedRect.midX
//        let faceCenterY = convertedRect.midY
//        
//        // حساب مركز وأبعاد البيضاوي
//        let ovalCenterX = ovalFrame.midX
//        let ovalCenterY = ovalFrame.midY
//        let ovalRadiusX = ovalFrame.width / 2
//        let ovalRadiusY = ovalFrame.height / 2
//        
//        // معادلة البيضاوي لفحص إذا كان مركز الوجه داخل البيضاوي
//        let normalizedX = (faceCenterX - ovalCenterX) / ovalRadiusX
//        let normalizedY = (faceCenterY - ovalCenterY) / ovalRadiusY
//        let result = (normalizedX * normalizedX) + (normalizedY * normalizedY)
//        
//        // التحقق من أن معظم الوجه داخل البيضاوي
//        let faceInOval = result <= 0.8 // استخدام 0.8 بدلاً من 1.0 للتسامح مع الحواف
//        
//        return faceInOval
//    }
//
//    // تحديث حالة اكتشاف الوجه
//    func updateFaceDetectionState(faceDetected: Bool) {
//        DispatchQueue.main.async {
//            self.isFaceDetected = faceDetected
//            
//            // تحديث لون الإطار
//            if faceDetected {
//                self.ovalBorderView.layer.borderColor = UIColor.green.cgColor
//                if let borderLayer = self.ovalBorderView.layer.sublayers?.first as? CAShapeLayer {
//                    borderLayer.strokeColor = UIColor.green.cgColor
//                }
//                self.messageLabel.text = "ضع وجهك داخل الإطار ثم اضغط زر الالتقاط"
//                self.captureButton.isEnabled = true
//                self.captureButton.alpha = 1.0
//            } else {
//                self.ovalBorderView.layer.borderColor = UIColor.red.cgColor
//                if let borderLayer = self.ovalBorderView.layer.sublayers?.first as? CAShapeLayer {
//                    borderLayer.strokeColor = UIColor.red.cgColor
//                }
//                self.messageLabel.text = "جاري البحث عن وجه..."
//                self.captureButton.isEnabled = false
//                self.captureButton.alpha = 0.5
//            }
//        }
//    }
//
//    @objc func captureButtonTapped() {
//        guard isFaceDetected else { return }
//        
//        let settings = AVCapturePhotoSettings()
//        self.cameraOutput.capturePhoto(with: settings, delegate: self)
//    }
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try requestHandler.perform([faceDetectionRequest])
//            
//            if let results = faceDetectionRequest.results as? [VNFaceObservation], !results.isEmpty {
//                // فحص إذا كان أي وجه داخل الإطار البيضاوي
//                var faceFoundInOval = false
//                for face in results {
//                    if isFaceInsideOval(face: face) {
//                        faceFoundInOval = true
//                        break
//                    }
//                }
//                updateFaceDetectionState(faceDetected: faceFoundInOval)
//            } else {
//                // لا يوجد وجه
//                updateFaceDetectionState(faceDetected: false)
//            }
//        } catch {
//            print("❌ خطأ في تحليل الصورة: \(error.localizedDescription)")
//        }
//    }
//}
//
//// MARK: - Photo Capture Delegate
//extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
//        delegate?.didCapture(image: image)
//        dismiss(animated: true)
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol CameraViewControllerDelegate {
//    func didCapture(image: UIImage)
//}




// old
//import SwiftUI
//import UIKit
//import AVFoundation
//import Vision
//
//struct SelfieCameraPicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let viewController = CameraViewController()
//        viewController.delegate = context.coordinator
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, CameraViewControllerDelegate {
//        let parent: SelfieCameraPicker
//
//        init(_ parent: SelfieCameraPicker) {
//            self.parent = parent
//        }
//
//        func didCapture(image: UIImage) {
//            DispatchQueue.main.async {
//                self.parent.selectedImage = image
//                self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//    }
//}
//
//// MARK: - Camera ViewController
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    var captureSession: AVCaptureSession?
//    var cameraOutput = AVCapturePhotoOutput()
//    let faceDetectionRequest = VNDetectFaceRectanglesRequest()
//    var delegate: CameraViewControllerDelegate?
//    var isCapturing = false // متغير لمنع التقاط صور متكررة
//
//    // عناصر واجهة المستخدم
//    let overlayView = UIView()
//    let messageLabel = UILabel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.setupCamera()
//        }
//    }
//
//    // إعداد واجهة المستخدم وإضافة التنبية الأخضر
//    func setupUI() {
//        overlayView.frame = view.bounds
//        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        overlayView.isHidden = true
//        view.addSubview(overlayView)
//
//        // تعديل موضع التنبيه ليكون في الأعلى
//        let safeAreaTop = view.safeAreaInsets.top + 20
//        messageLabel.frame = CGRect(x: 20, y: safeAreaTop, width: view.bounds.width - 40, height: 60)
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        messageLabel.textColor = .white
//        messageLabel.numberOfLines = 2
//        messageLabel.layer.cornerRadius = 10
//        messageLabel.layer.masksToBounds = true
//        messageLabel.backgroundColor = UIColor.green
//        messageLabel.isHidden = true
//        view.addSubview(messageLabel)
//    }
//
//    func setupCamera() {
//        let session = AVCaptureSession()
//        session.sessionPreset = .photo
//
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//          //  print("❌ لا يمكن العثور على الكاميرا الأمامية")
//            return
//        }
//
//        do {
//            let input = try AVCaptureDeviceInput(device: frontCamera)
//            if session.canAddInput(input) {
//                session.addInput(input)
//            }
//
//            if session.canAddOutput(cameraOutput) {
//                session.addOutput(cameraOutput)
//            }
//
//            let videoOutput = AVCaptureVideoDataOutput()
//            if session.canAddOutput(videoOutput) {
//                session.addOutput(videoOutput)
//                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
//            }
//
//            DispatchQueue.main.async {
//                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//                previewLayer.videoGravity = .resizeAspectFill
//                previewLayer.frame = self.view.bounds
//                self.view.layer.insertSublayer(previewLayer, at: 0)
//            }
//
//            session.startRunning()
//            self.captureSession = session
//
//        } catch {
//           // print("❌ خطأ في إعداد الكاميرا: \(error.localizedDescription)")
//        }
//    }
//
//    func capturePhoto() {
//        guard !isCapturing else { return }  // منع التقاط صور متكررة
//        isCapturing = true
//
//        DispatchQueue.main.async {
//            self.messageLabel.text = "تم التعرف على الوجه، سيتم التقاط الصورة، لا تتحرك"
//            self.messageLabel.isHidden = false
//            self.overlayView.isHidden = false
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {  // تأخير لمدة 3 ثوانٍ قبل الالتقاط
//            let settings = AVCapturePhotoSettings()
//            self.cameraOutput.capturePhoto(with: settings, delegate: self)
//
//            DispatchQueue.main.async {
//                self.messageLabel.isHidden = true
//                self.overlayView.isHidden = true
//            }
//        }
//    }
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try requestHandler.perform([faceDetectionRequest])
//           
//            if let results = faceDetectionRequest.results, !results.isEmpty {
//             //   if let results = faceDetectionRequest.results as? [VNFaceObservation], !results.isEmpty {
//
//                capturePhoto()
//            }
//        } catch {
//           // print("❌ خطأ في تحليل الصورة: \(error.localizedDescription)")
//        }
//    }
//}
//
//// MARK: - Photo Capture Delegate
//extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
//        delegate?.didCapture(image: image)
//        dismiss(animated: true)
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol CameraViewControllerDelegate {
//    func didCapture(image: UIImage)
//}


//




















//
// الهوية




import SwiftUI
import UIKit

// إضافة امتداد للحصول على نوع الجهاز
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone10,1", "iPhone10,4":                 return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                 return "iPhone 8 Plus"
        case "iPhone9,1", "iPhone9,3":                   return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                   return "iPhone 7 Plus"
        case "iPhone8,1":                                return "iPhone 6s"
        case "iPhone8,2":                                return "iPhone 6s Plus"
        case "iPhone8,4":                                return "iPhone SE"
        case "iPhone7,2":                                return "iPhone 6"
        case "iPhone7,1":                                return "iPhone 6 Plus"
        default:                                         return identifier
        }
    }
}

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
            overlayView.backgroundColor = UIColor.clear
            overlayView.isUserInteractionEnabled = false
            
            // حساب الأبعاد نسبيًا
            let screenBounds = UIScreen.main.bounds
            let minSide = min(screenBounds.width, screenBounds.height)
            let scaleFactor: CGFloat = 0.7
            let frameWidth = minSide * scaleFactor
            let ratio: CGFloat = 5.5 / 8.5  // الارتفاع/العرض
            let frameHeight = frameWidth * ratio
            
            // حساب الارتفاع المناسب للتعتيم - يترك مساحة كبيرة للأزرار
            let totalBottomSpace: CGFloat = 220 // مساحة كافية لجميع الأزرار
            
            // التحقق من نوع الجهاز بدقة
            let deviceType = UIDevice.current.modelName
            let isIPhone8 = deviceType.contains("iPhone 8") || deviceType.contains("iPhone 7") || deviceType.contains("iPhone 6") || UIScreen.main.bounds.height <= 667
            
            // إنشاء طبقة التعتيم فقط إذا لم يكن الجهاز آيفون 8
            if !isIPhone8 {
                // إنشاء طبقة التعتيم - تتوقف قبل منطقة الأزرار
                let darkOverlay = UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: screenBounds.width,
                    height: screenBounds.height - totalBottomSpace
                ))
                darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.9)
                overlayView.addSubview(darkOverlay)
                
                // إنشاء مساحة شفافة في المنتصف
                let transparentRect = CGRect(
                    x: (screenBounds.width - frameWidth) / 2,
                    y: (darkOverlay.frame.height - frameHeight) / 2,
                    width: frameWidth,
                    height: frameHeight
                )
                
                let path = UIBezierPath(rect: darkOverlay.bounds)
                let transparentPath = UIBezierPath(roundedRect: transparentRect, cornerRadius: 15)
                path.append(transparentPath)
                path.usesEvenOddFillRule = true
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                maskLayer.fillRule = .evenOdd
                darkOverlay.layer.mask = maskLayer
            }
            
            // حساب موضع الإطار الأخضر - نفسه للشاشات الكبيرة والصغيرة
            let greenFrameRect = CGRect(
                x: (screenBounds.width - frameWidth) / 2,
                y: ((screenBounds.height - totalBottomSpace) - frameHeight) / 2,
                width: frameWidth,
                height: frameHeight
            )
            
            // الإطار الأخضر مع الزوايا المقوسة
            let greenFrame = UIView(frame: greenFrameRect)
            greenFrame.layer.borderWidth = 4
            greenFrame.layer.borderColor = UIColor.green.cgColor
            greenFrame.layer.cornerRadius = 15
            greenFrame.backgroundColor = UIColor.clear
            greenFrame.isUserInteractionEnabled = false
            overlayView.addSubview(greenFrame)
            
            // التسمية فوق الإطار
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
            
            // تغيير الاتجاه للعربية
            picker.view.semanticContentAttribute = .forceRightToLeft
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
        private var buttonTextTimer: Timer?
        
        init(_ parent: ImagePicker) {
            self.parent = parent
            super.init()
            
            // بدء مؤقت لتغيير نصوص الأزرار - مع تكرار أكثر
            buttonTextTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                self?.updateButtonTexts()
            }
            
            // محاولة إضافية بعد تأخير للتأكد من تحميل الواجهة
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.forceUpdateButtonTexts()
            }
        }
        
        // دالة إضافية لتحديث النصوص بقوة
        private func forceUpdateButtonTexts() {
            for _ in 0...10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1...1.0)) { [weak self] in
                    self?.updateButtonTexts()
                    // محاولة إضافية لضبط المحاذاة
                    self?.alignButtonsHorizontally()
                }
            }
        }
        
        // دالة لضبط المحاذاة الأفقية للأزرار
        private func alignButtonsHorizontally() {
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    var usePhotoButton: UIButton?
                    var retakeButton: UIButton?
                    
                    // البحث عن كلا الزرين
                    self.findButtons(in: window, usePhotoButton: &usePhotoButton, retakeButton: &retakeButton)
                    
                    // إذا وجدنا كلا الزرين، نضبط محاذاتهما
                    if let useButton = usePhotoButton, let retButton = retakeButton {
                        // التأكد من أن لهما نفس الارتفاع والمحاذاة
                        let sameY = min(useButton.frame.origin.y, retButton.frame.origin.y)
                        useButton.frame.origin.y = sameY
                        retButton.frame.origin.y = sameY
                    }
                }
            }
        }
        
        // دالة مساعدة للبحث عن الأزرار
        private func findButtons(in view: UIView, usePhotoButton: inout UIButton?, retakeButton: inout UIButton?) {
            if let button = view as? UIButton {
                if let title = button.titleLabel?.text {
                    if title.contains("استخدم") || title.contains("Use") {
                        usePhotoButton = button
                    } else if title.contains("أعد") || title.contains("Retake") {
                        retakeButton = button
                    }
                }
            }
            
            for subview in view.subviews {
                findButtons(in: subview, usePhotoButton: &usePhotoButton, retakeButton: &retakeButton)
            }
        }
        
        deinit {
            buttonTextTimer?.invalidate()
        }
        
        private func updateButtonTexts() {
            DispatchQueue.main.async {
                // استخدام الطريقة الحديثة للحصول على النافذة
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    self.findAndReplaceButtonTexts(in: window)
                }
            }
        }
        
        private func findAndReplaceButtonTexts(in view: UIView) {
            // دالة بسيطة للبحث عن الأزرار وتغيير نصوصها
            if let button = view as? UIButton {
                // فحص جميع حالات الزر
                let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
                
                // حفظ حجم الخط الأصلي
                let originalFontSize = button.titleLabel?.font.pointSize ?? 17
                // حساب الحجم الجديد كنسبة مئوية (80% من الحجم الأصلي)
                let newFontSize = originalFontSize * 0.8
                
                // الآن نقوم بتغيير النص
                for state in states {
                    if let title = button.title(for: state) {
                        if title == "Use Photo" || title.contains("Use Photo") || title.contains("Use") {
                            // تغيير النص والخصائص
                            button.setTitle("استخدم الصورة", for: state)
                            
                            // ضبط خصائص النص لضمان ظهوره كاملاً
                            if let titleLabel = button.titleLabel {
                                // استخدام نسبة من الحجم الأصلي
                                titleLabel.font = titleLabel.font.withSize(newFontSize)
                                // السماح بتصغير الخط إذا لزم الأمر
                                titleLabel.adjustsFontSizeToFitWidth = true
                                titleLabel.minimumScaleFactor = 0.7
                                // محاذاة في المنتصف
                                titleLabel.textAlignment = .center
                                // سطر واحد فقط
                                titleLabel.numberOfLines = 1
                                // إزالة أي محاذاة رأسية إضافية
                                titleLabel.baselineAdjustment = .alignCenters
                            }
                            
                            // تقليل الحشو الداخلي للزر (نسبي أيضاً)
                            let buttonWidth = button.frame.width
                            let horizontalInset = buttonWidth * 0.05 // 5% من عرض الزر
                            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                            
                            // ضبط المحاذاة الرأسية
                            button.contentVerticalAlignment = .center
                            button.contentHorizontalAlignment = .center
                            
                            // إجبار إعادة التخطيط
                            button.setNeedsLayout()
                            button.layoutIfNeeded()
                            
                        } else if title == "Retake" || title.contains("Retake") {
                            button.setTitle("أعد الالتقاط", for: state)
                            
                            // نفس خصائص زر "استخدم الصورة" للحصول على نفس المستوى
                            if let titleLabel = button.titleLabel {
                                titleLabel.font = titleLabel.font.withSize(newFontSize)  // نفس النسبة
                                titleLabel.adjustsFontSizeToFitWidth = true
                                titleLabel.minimumScaleFactor = 0.7
                                titleLabel.textAlignment = .center
                                titleLabel.numberOfLines = 1
                                titleLabel.baselineAdjustment = .alignCenters
                            }
                            
                            // نفس الحشو والمحاذاة (نسبي)
                            let buttonWidth = button.frame.width
                            let horizontalInset = buttonWidth * 0.05 // 5% من عرض الزر
                            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                            button.contentVerticalAlignment = .center
                            button.contentHorizontalAlignment = .center
                            
                            // إجبار إعادة التخطيط
                            button.setNeedsLayout()
                            button.layoutIfNeeded()
                            
                        } else if title == "Cancel" || title.contains("Cancel") {
                            button.setTitle("إلغاء", for: state)
                        }
                    }
                }
            }
            
            // البحث في العناصر الفرعية
            for subview in view.subviews {
                findAndReplaceButtonTexts(in: subview)
            }
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            buttonTextTimer?.invalidate()
            
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
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            buttonTextTimer?.invalidate()
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
                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
                        self.parent.onUploadComplete?(false, nil)
                    }
                }
            }.resume()
        }
    }
}



//
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
//            picker.showsCameraControls = true
//            
//            // إنشاء Overlay
//            let overlayView = UIView(frame: UIScreen.main.bounds)
//            overlayView.backgroundColor = UIColor.clear
//            overlayView.isUserInteractionEnabled = false
//            
//            // حساب الأبعاد نسبيًا
//            let screenBounds = UIScreen.main.bounds
//            let minSide = min(screenBounds.width, screenBounds.height)
//            let scaleFactor: CGFloat = 0.7
//            let frameWidth = minSide * scaleFactor
//            let ratio: CGFloat = 5.5 / 8.5  // الارتفاع/العرض
//            let frameHeight = frameWidth * ratio
//            
//            // حساب الارتفاع المناسب للتعتيم - يترك مساحة كبيرة للأزرار
//            let totalBottomSpace: CGFloat = 220 // مساحة كافية لجميع الأزرار
//            
//            // إنشاء طبقة التعتيم - تتوقف قبل منطقة الأزرار
//            let darkOverlay = UIView(frame: CGRect(
//                x: 0,
//                y: 0,
//                width: screenBounds.width,
//                height: screenBounds.height - totalBottomSpace
//            ))
//            darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//            overlayView.addSubview(darkOverlay)
//            
//            // إنشاء مساحة شفافة في المنتصف
//            let transparentRect = CGRect(
//                x: (screenBounds.width - frameWidth) / 2,
//                y: (darkOverlay.frame.height - frameHeight) / 2,
//                width: frameWidth,
//                height: frameHeight
//            )
//            
//            let path = UIBezierPath(rect: darkOverlay.bounds)
//            let transparentPath = UIBezierPath(roundedRect: transparentRect, cornerRadius: 15)
//            path.append(transparentPath)
//            path.usesEvenOddFillRule = true
//            
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = path.cgPath
//            maskLayer.fillRule = .evenOdd
//            darkOverlay.layer.mask = maskLayer
//            
//            // الإطار الأخضر مع الزوايا المقوسة
//            let greenFrame = UIView(frame: transparentRect)
//            greenFrame.layer.borderWidth = 4
//            greenFrame.layer.borderColor = UIColor.green.cgColor
//            greenFrame.layer.cornerRadius = 15
//            greenFrame.backgroundColor = UIColor.clear
//            greenFrame.isUserInteractionEnabled = false
//            overlayView.addSubview(greenFrame)
//            
//            // التسمية فوق الإطار
//            let label = UILabel()
//            label.text = "ضع الهوية داخل الإطار والتقط الصورة"
//            label.font = UIFont.boldSystemFont(ofSize: 16)
//            label.textColor = .white
//            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            label.textAlignment = .center
//            label.numberOfLines = 2
//            label.isUserInteractionEnabled = false
//            
//            let labelHeight = frameHeight * 0.15
//            let labelY = greenFrame.frame.minY - labelHeight - 10
//            label.frame = CGRect(x: greenFrame.frame.minX,
//                                 y: labelY,
//                                 width: greenFrame.frame.width,
//                                 height: labelHeight)
//            
//            overlayView.addSubview(label)
//            
//            picker.cameraOverlayView = overlayView
//            
//            // تغيير الاتجاه للعربية
//            picker.view.semanticContentAttribute = .forceRightToLeft
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
//        private var buttonTextTimer: Timer?
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//            super.init()
//            
//            // بدء مؤقت لتغيير نصوص الأزرار - مع تكرار أكثر
//            buttonTextTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
//                self?.updateButtonTexts()
//            }
//            
//            // محاولة إضافية بعد تأخير للتأكد من تحميل الواجهة
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//                self?.forceUpdateButtonTexts()
//            }
//        }
//        
//        // دالة إضافية لتحديث النصوص بقوة
//        private func forceUpdateButtonTexts() {
//            for _ in 0...10 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1...1.0)) { [weak self] in
//                    self?.updateButtonTexts()
//                    // محاولة إضافية لضبط المحاذاة
//                    self?.alignButtonsHorizontally()
//                }
//            }
//        }
//        
//        // دالة لضبط المحاذاة الأفقية للأزرار
//        private func alignButtonsHorizontally() {
//            DispatchQueue.main.async {
//                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                   let window = windowScene.windows.first {
//                    var usePhotoButton: UIButton?
//                    var retakeButton: UIButton?
//                    
//                    // البحث عن كلا الزرين
//                    self.findButtons(in: window, usePhotoButton: &usePhotoButton, retakeButton: &retakeButton)
//                    
//                    // إذا وجدنا كلا الزرين، نضبط محاذاتهما
//                    if let useButton = usePhotoButton, let retButton = retakeButton {
//                        // التأكد من أن لهما نفس الارتفاع والمحاذاة
//                        let sameY = min(useButton.frame.origin.y, retButton.frame.origin.y)
//                        useButton.frame.origin.y = sameY
//                        retButton.frame.origin.y = sameY
//                    }
//                }
//            }
//        }
//        
//        // دالة مساعدة للبحث عن الأزرار
//        private func findButtons(in view: UIView, usePhotoButton: inout UIButton?, retakeButton: inout UIButton?) {
//            if let button = view as? UIButton {
//                if let title = button.titleLabel?.text {
//                    if title.contains("استخدم") || title.contains("Use") {
//                        usePhotoButton = button
//                    } else if title.contains("أعد") || title.contains("Retake") {
//                        retakeButton = button
//                    }
//                }
//            }
//            
//            for subview in view.subviews {
//                findButtons(in: subview, usePhotoButton: &usePhotoButton, retakeButton: &retakeButton)
//            }
//        }
//        
//        deinit {
//            buttonTextTimer?.invalidate()
//        }
//        
//        private func updateButtonTexts() {
//            DispatchQueue.main.async {
//                // استخدام الطريقة الحديثة للحصول على النافذة
//                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                   let window = windowScene.windows.first {
//                    self.findAndReplaceButtonTexts(in: window)
//                }
//            }
//        }
//        
//        private func findAndReplaceButtonTexts(in view: UIView) {
//            // دالة بسيطة للبحث عن الأزرار وتغيير نصوصها
//            if let button = view as? UIButton {
//                // فحص جميع حالات الزر
//                let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
//                
//                // حفظ حجم الخط الأصلي
//                let originalFontSize = button.titleLabel?.font.pointSize ?? 17
//                // حساب الحجم الجديد كنسبة مئوية (80% من الحجم الأصلي)
//                let newFontSize = originalFontSize * 0.8
//                
//                // الآن نقوم بتغيير النص
//                for state in states {
//                    if let title = button.title(for: state) {
//                        if title == "Use Photo" || title.contains("Use Photo") || title.contains("Use") {
//                            // تغيير النص والخصائص
//                            button.setTitle("استخدم الصورة", for: state)
//                            
//                            // ضبط خصائص النص لضمان ظهوره كاملاً
//                            if let titleLabel = button.titleLabel {
//                                // استخدام نسبة من الحجم الأصلي
//                                titleLabel.font = titleLabel.font.withSize(newFontSize)
//                                // السماح بتصغير الخط إذا لزم الأمر
//                                titleLabel.adjustsFontSizeToFitWidth = true
//                                titleLabel.minimumScaleFactor = 0.7
//                                // محاذاة في المنتصف
//                                titleLabel.textAlignment = .center
//                                // سطر واحد فقط
//                                titleLabel.numberOfLines = 1
//                                // إزالة أي محاذاة رأسية إضافية
//                                titleLabel.baselineAdjustment = .alignCenters
//                            }
//                            
//                            // تقليل الحشو الداخلي للزر (نسبي أيضاً)
//                            let buttonWidth = button.frame.width
//                            let horizontalInset = buttonWidth * 0.05 // 5% من عرض الزر
//                            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
//                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                            
//                            // ضبط المحاذاة الرأسية
//                            button.contentVerticalAlignment = .center
//                            button.contentHorizontalAlignment = .center
//                            
//                            // إجبار إعادة التخطيط
//                            button.setNeedsLayout()
//                            button.layoutIfNeeded()
//                            
//                        } else if title == "Retake" || title.contains("Retake") {
//                            button.setTitle("أعد الالتقاط", for: state)
//                            
//                            // نفس خصائص زر "استخدم الصورة" للحصول على نفس المستوى
//                            if let titleLabel = button.titleLabel {
//                                titleLabel.font = titleLabel.font.withSize(newFontSize)  // نفس النسبة
//                                titleLabel.adjustsFontSizeToFitWidth = true
//                                titleLabel.minimumScaleFactor = 0.7
//                                titleLabel.textAlignment = .center
//                                titleLabel.numberOfLines = 1
//                                titleLabel.baselineAdjustment = .alignCenters
//                            }
//                            
//                            // نفس الحشو والمحاذاة (نسبي)
//                            let buttonWidth = button.frame.width
//                            let horizontalInset = buttonWidth * 0.05 // 5% من عرض الزر
//                            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
//                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                            button.contentVerticalAlignment = .center
//                            button.contentHorizontalAlignment = .center
//                            
//                            // إجبار إعادة التخطيط
//                            button.setNeedsLayout()
//                            button.layoutIfNeeded()
//                            
//                        } else if title == "Cancel" || title.contains("Cancel") {
//                            button.setTitle("إلغاء", for: state)
//                        }
//                    }
//                }
//            }
//            
//            // البحث في العناصر الفرعية
//            for subview in view.subviews {
//                findAndReplaceButtonTexts(in: subview)
//            }
//        }
//        
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//            buttonTextTimer?.invalidate()
//            
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
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            buttonTextTimer?.invalidate()
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
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}





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
//            picker.showsCameraControls = true
//            
//            // إنشاء Overlay
//            let overlayView = UIView(frame: UIScreen.main.bounds)
//            overlayView.backgroundColor = UIColor.clear
//            overlayView.isUserInteractionEnabled = false
//            
//            // حساب الأبعاد نسبيًا
//            let screenBounds = UIScreen.main.bounds
//            let minSide = min(screenBounds.width, screenBounds.height)
//            let scaleFactor: CGFloat = 0.7
//            let frameWidth = minSide * scaleFactor
//            let ratio: CGFloat = 5.5 / 8.5  // الارتفاع/العرض
//            let frameHeight = frameWidth * ratio
//            
//            // حساب الارتفاع المناسب للتعتيم - يترك مساحة كبيرة للأزرار
//            let totalBottomSpace: CGFloat = 220 // مساحة كافية لجميع الأزرار
//            
//            // إنشاء طبقة التعتيم - تتوقف قبل منطقة الأزرار
//            let darkOverlay = UIView(frame: CGRect(
//                x: 0,
//                y: 0,
//                width: screenBounds.width,
//                height: screenBounds.height - totalBottomSpace
//            ))
//            darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//            overlayView.addSubview(darkOverlay)
//            
//            // إنشاء مساحة شفافة في المنتصف
//            let transparentRect = CGRect(
//                x: (screenBounds.width - frameWidth) / 2,
//                y: (darkOverlay.frame.height - frameHeight) / 2,
//                width: frameWidth,
//                height: frameHeight
//            )
//            
//            let path = UIBezierPath(rect: darkOverlay.bounds)
//            let transparentPath = UIBezierPath(roundedRect: transparentRect, cornerRadius: 15)
//            path.append(transparentPath)
//            path.usesEvenOddFillRule = true
//            
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = path.cgPath
//            maskLayer.fillRule = .evenOdd
//            darkOverlay.layer.mask = maskLayer
//            
//            // الإطار الأخضر مع الزوايا المقوسة
//            let greenFrame = UIView(frame: transparentRect)
//            greenFrame.layer.borderWidth = 4
//            greenFrame.layer.borderColor = UIColor.green.cgColor
//            greenFrame.layer.cornerRadius = 15
//            greenFrame.backgroundColor = UIColor.clear
//            greenFrame.isUserInteractionEnabled = false
//            overlayView.addSubview(greenFrame)
//            
//            // التسمية فوق الإطار
//            let label = UILabel()
//            label.text = "ضع الهوية داخل الإطار والتقط الصورة"
//            label.font = UIFont.boldSystemFont(ofSize: 16)
//            label.textColor = .white
//            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            label.textAlignment = .center
//            label.numberOfLines = 2
//            label.isUserInteractionEnabled = false
//            
//            let labelHeight = frameHeight * 0.15
//            let labelY = greenFrame.frame.minY - labelHeight - 10
//            label.frame = CGRect(x: greenFrame.frame.minX,
//                                 y: labelY,
//                                 width: greenFrame.frame.width,
//                                 height: labelHeight)
//            
//            overlayView.addSubview(label)
//            
//            picker.cameraOverlayView = overlayView
//            
//            // تغيير الاتجاه للعربية
//            picker.view.semanticContentAttribute = .forceRightToLeft
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
//        private var buttonTextTimer: Timer?
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//            super.init()
//            
//            // بدء مؤقت لتغيير نصوص الأزرار - مع تكرار أكثر
//            buttonTextTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
//                self?.updateButtonTexts()
//            }
//            
//            // محاولة إضافية بعد تأخير للتأكد من تحميل الواجهة
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//                self?.forceUpdateButtonTexts()
//            }
//        }
//        
//        // دالة إضافية لتحديث النصوص بقوة
//        private func forceUpdateButtonTexts() {
//            for _ in 0...10 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1...1.0)) { [weak self] in
//                    self?.updateButtonTexts()
//                    // محاولة إضافية لضبط المحاذاة
//                    self?.alignButtonsHorizontally()
//                }
//            }
//        }
//        
//        // دالة لضبط المحاذاة الأفقية للأزرار
//        private func alignButtonsHorizontally() {
//            DispatchQueue.main.async {
//                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                   let window = windowScene.windows.first {
//                    var usePhotoButton: UIButton?
//                    var retakeButton: UIButton?
//                    
//                    // البحث عن كلا الزرين
//                    self.findButtons(in: window, usePhotoButton: &usePhotoButton, retakeButton: &retakeButton)
//                    
//                    // إذا وجدنا كلا الزرين، نضبط محاذاتهما
//                    if let useButton = usePhotoButton, let retButton = retakeButton {
//                        // التأكد من أن لهما نفس الارتفاع والمحاذاة
//                        let sameY = min(useButton.frame.origin.y, retButton.frame.origin.y)
//                        useButton.frame.origin.y = sameY
//                        retButton.frame.origin.y = sameY
//                    }
//                }
//            }
//        }
//        
//        // دالة مساعدة للبحث عن الأزرار
//        private func findButtons(in view: UIView, usePhotoButton: inout UIButton?, retakeButton: inout UIButton?) {
//            if let button = view as? UIButton {
//                if let title = button.titleLabel?.text {
//                    if title.contains("استخدم") || title.contains("Use") {
//                        usePhotoButton = button
//                    } else if title.contains("أعد") || title.contains("Retake") {
//                        retakeButton = button
//                    }
//                }
//            }
//            
//            for subview in view.subviews {
//                findButtons(in: subview, usePhotoButton: &usePhotoButton, retakeButton: &retakeButton)
//            }
//        }
//        
//        deinit {
//            buttonTextTimer?.invalidate()
//        }
//        
//        private func updateButtonTexts() {
//            DispatchQueue.main.async {
//                // استخدام الطريقة الحديثة للحصول على النافذة
//                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                   let window = windowScene.windows.first {
//                    self.findAndReplaceButtonTexts(in: window)
//                }
//            }
//        }
//        
//        private func findAndReplaceButtonTexts(in view: UIView) {
//            // دالة بسيطة للبحث عن الأزرار وتغيير نصوصها
//            if let button = view as? UIButton {
//                // فحص جميع حالات الزر
//                let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
//                
//                // الآن نقوم بتغيير النص
//                for state in states {
//                    if let title = button.title(for: state) {
//                        if title == "Use Photo" || title.contains("Use Photo") || title.contains("Use") {
//                            // تغيير النص والخصائص
//                            button.setTitle("استخدم الصورة", for: state)
//                            
//                            // ضبط خصائص النص لضمان ظهوره كاملاً
//                            if let titleLabel = button.titleLabel {
//                                // جعل الخط أصغر
//                                titleLabel.font = UIFont.systemFont(ofSize: 14)
//                                // السماح بتصغير الخط إذا لزم الأمر
//                                titleLabel.adjustsFontSizeToFitWidth = true
//                                titleLabel.minimumScaleFactor = 0.8
//                                // محاذاة في المنتصف
//                                titleLabel.textAlignment = .center
//                                // سطر واحد فقط
//                                titleLabel.numberOfLines = 1
//                                // إزالة أي محاذاة رأسية إضافية
//                                titleLabel.baselineAdjustment = .alignCenters
//                            }
//                            
//                            // تقليل الحشو الداخلي للزر
//                            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                            
//                            // ضبط المحاذاة الرأسية
//                            button.contentVerticalAlignment = .center
//                            button.contentHorizontalAlignment = .center
//                            
//                            // إجبار إعادة التخطيط
//                            button.setNeedsLayout()
//                            button.layoutIfNeeded()
//                            
//                        } else if title == "Retake" || title.contains("Retake") {
//                            button.setTitle("أعد الالتقاط", for: state)
//                            
//                            // نفس خصائص زر "استخدم الصورة" للحصول على نفس المستوى
//                            if let titleLabel = button.titleLabel {
//                                titleLabel.font = UIFont.systemFont(ofSize: 14)  // نفس حجم الخط
//                                titleLabel.adjustsFontSizeToFitWidth = true
//                                titleLabel.minimumScaleFactor = 0.8
//                                titleLabel.textAlignment = .center
//                                titleLabel.numberOfLines = 1
//                                titleLabel.baselineAdjustment = .alignCenters
//                            }
//                            
//                            // نفس الحشو والمحاذاة
//                            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                            button.contentVerticalAlignment = .center
//                            button.contentHorizontalAlignment = .center
//                            
//                            // إجبار إعادة التخطيط
//                            button.setNeedsLayout()
//                            button.layoutIfNeeded()
//                            
//                        } else if title == "Cancel" || title.contains("Cancel") {
//                            button.setTitle("إلغاء", for: state)
//                        }
//                    }
//                }
//            }
//            
//            // البحث في العناصر الفرعية
//            for subview in view.subviews {
//                findAndReplaceButtonTexts(in: subview)
//            }
//        }
//        
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//            buttonTextTimer?.invalidate()
//            
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
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            buttonTextTimer?.invalidate()
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
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}






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
//            // إنشاء Overlay
//            let overlayView = UIView(frame: UIScreen.main.bounds)
//            overlayView.backgroundColor = UIColor.clear
//            overlayView.isUserInteractionEnabled = false
//            
//            // حساب الأبعاد نسبيًا
//            let screenBounds = UIScreen.main.bounds
//            let minSide = min(screenBounds.width, screenBounds.height)
//            let scaleFactor: CGFloat = 0.7
//            let frameWidth = minSide * scaleFactor
//            let ratio: CGFloat = 5.5 / 8.5  // الارتفاع/العرض
//            let frameHeight = frameWidth * ratio
//            
//            // حساب الارتفاع المناسب للتعتيم - يترك مساحة كبيرة للأزرار
//            let totalBottomSpace: CGFloat = 220 // مساحة كافية لجميع الأزرار
//            
//            // إنشاء طبقة التعتيم - تتوقف قبل منطقة الأزرار
//            let darkOverlay = UIView(frame: CGRect(
//                x: 0,
//                y: 0,
//                width: screenBounds.width,
//                height: screenBounds.height - totalBottomSpace
//            ))
//            darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//            overlayView.addSubview(darkOverlay)
//            
//            // إنشاء مساحة شفافة في المنتصف
//            let transparentRect = CGRect(
//                x: (screenBounds.width - frameWidth) / 2,
//                y: (darkOverlay.frame.height - frameHeight) / 2,
//                width: frameWidth,
//                height: frameHeight
//            )
//            
//            let path = UIBezierPath(rect: darkOverlay.bounds)
//            let transparentPath = UIBezierPath(roundedRect: transparentRect, cornerRadius: 15)
//            path.append(transparentPath)
//            path.usesEvenOddFillRule = true
//            
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = path.cgPath
//            maskLayer.fillRule = .evenOdd
//            darkOverlay.layer.mask = maskLayer
//            
//            // الإطار الأخضر مع الزوايا المقوسة
//            let greenFrame = UIView(frame: transparentRect)
//            greenFrame.layer.borderWidth = 4
//            greenFrame.layer.borderColor = UIColor.green.cgColor
//            greenFrame.layer.cornerRadius = 15
//            greenFrame.backgroundColor = UIColor.clear
//            greenFrame.isUserInteractionEnabled = false
//            overlayView.addSubview(greenFrame)
//            
//            // التسمية فوق الإطار
//            let label = UILabel()
//            label.text = "ضع الهوية داخل الإطار والتقط الصورة"
//            label.font = UIFont.boldSystemFont(ofSize: 16)
//            label.textColor = .white
//            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            label.textAlignment = .center
//            label.numberOfLines = 2
//            label.isUserInteractionEnabled = false
//            
//            let labelHeight = frameHeight * 0.15
//            let labelY = greenFrame.frame.minY - labelHeight - 10
//            label.frame = CGRect(x: greenFrame.frame.minX,
//                                 y: labelY,
//                                 width: greenFrame.frame.width,
//                                 height: labelHeight)
//            
//            overlayView.addSubview(label)
//            
//            picker.cameraOverlayView = overlayView
//            
//            // تغيير الاتجاه للعربية
//            picker.view.semanticContentAttribute = .forceRightToLeft
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
//        private var buttonTextTimer: Timer?
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//            super.init()
//            
//            // بدء مؤقت لتغيير نصوص الأزرار
//            buttonTextTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//                self?.updateButtonTexts()
//            }
//        }
//        
//        deinit {
//            buttonTextTimer?.invalidate()
//        }
//        
//        private func updateButtonTexts() {
//            DispatchQueue.main.async {
//                if let window = UIApplication.shared.windows.first {
//                    self.findAndReplaceButtonTexts(in: window)
//                }
//            }
//        }
//        
//        private func findAndReplaceButtonTexts(in view: UIView) {
//            // دالة بسيطة للبحث عن الأزرار وتغيير نصوصها
//            if let button = view as? UIButton {
//                // فحص جميع حالات الزر
//                let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
//                for state in states {
//                    if let title = button.title(for: state) {
//                        if title == "Use Photo" || title.contains("Use Photo") {
//                            button.setTitle("استخدم الصورة", for: state)
//                        } else if title == "Retake" || title.contains("Retake") {
//                            button.setTitle("أعد الالتقاط", for: state)
//                        } else if title == "Cancel" || title.contains("Cancel") {
//                            button.setTitle("إلغاء", for: state)
//                        }
//                    }
//                }
//            }
//            
//            // البحث في العناصر الفرعية
//            for subview in view.subviews {
//                findAndReplaceButtonTexts(in: subview)
//            }
//        }
//        
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//            buttonTextTimer?.invalidate()
//            
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
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            }
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            buttonTextTimer?.invalidate()
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
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}





// يعمل
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
//            // إنشاء Overlay
//            let overlayView = UIView(frame: UIScreen.main.bounds)
//            overlayView.backgroundColor = .clear
//            overlayView.isUserInteractionEnabled = false
//            
//            // 1) حساب الأبعاد نسبيًا
//            let screenBounds = UIScreen.main.bounds
//            let minSide = min(screenBounds.width, screenBounds.height)
//            let scaleFactor: CGFloat = 0.7
//            let frameWidth = minSide * scaleFactor
//            let ratio: CGFloat = 5.5 / 8.5  // الارتفاع/العرض
//            let frameHeight = frameWidth * ratio
//            
//            let greenFrame = UIView(frame: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
//            greenFrame.center = overlayView.center
//            greenFrame.layer.borderWidth = 4
//            greenFrame.layer.borderColor = UIColor.green.cgColor
//            greenFrame.backgroundColor = .clear
//            greenFrame.isUserInteractionEnabled = false
//            overlayView.addSubview(greenFrame)
//            
//            // 2) التسمية فوق الإطار
//            let label = UILabel()
//            label.text = "ضع الهوية داخل الإطار والتقط الصورة"
//            label.font = UIFont.boldSystemFont(ofSize: 16)
//            label.textColor = .white
//            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            label.textAlignment = .center
//            label.numberOfLines = 2
//            label.isUserInteractionEnabled = false
//            
//            let labelHeight = frameHeight * 0.15
//            let labelY = greenFrame.frame.minY - labelHeight - 10
//            label.frame = CGRect(x: greenFrame.frame.minX,
//                                 y: labelY,
//                                 width: greenFrame.frame.width,
//                                 height: labelHeight)
//            
//            overlayView.addSubview(label)
//            
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
//                   // print("❌ لم يتم التقاط صورة.")
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
//                       // print("فشل تحميل \(imageType) من السيرفر.")
//                        self.parent.showToast?("❌ فشل تحميل \(imageType) من السيرفر.", Color.red, true)
//                        self.parent.onUploadComplete?(false, nil)
//                    }
//                }
//            }.resume()
//        }
//    }
//}

//






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
            case .notDetermined: break
              //  print("🔹 لم يتم تحديد الإذن.")
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
