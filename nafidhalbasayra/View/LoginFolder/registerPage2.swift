//
//  registerPage2.swift
//  nafidhalbasayra
//
//  Created by muhammad on 09/10/2024.
//

import SwiftUI

struct registerPage2: View {    
 
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @StateObject private var vmTeacher = CoreDataViewModel()
    @Environment(\.dismiss) var dismiss
//    @StateObject var coreDataViewModel = CoreDataViewModel() // temp

    @State private var showImagePicker = false
    @State private var showImagePickerFront = false
    @State private var showImagePickerBack = false
    @State private var showAlertEmptyImages = false
    
    //@State private var goToWaitPage = false
    @State private var shouldNavigate: Bool = false
    //
//    @State private var showAlertUploadSuccess = false
//    @State private var showAlertUploadFailure = false
//    @State private var alertMessage = ""
    //
    
    @State private var showToast = false
    @State private var toastTitle = ""
    @State private var toastMessage = ""
    @State private var toastColor: Color = .red



    
    @State private var image1 = false
    @State private var image2 = false
    @State private var image3 = false

    var isValidImages: Bool {
        guard let profileImageData = teacherData.profileimage?.jpegData(compressionQuality: 0.8), profileImageData.count > 0,
              let frontImageData = teacherData.frontfaceidentity?.jpegData(compressionQuality: 0.8), frontImageData.count > 0,
              let backImageData = teacherData.backfaceidentity?.jpegData(compressionQuality: 0.8), backImageData.count > 0 else {
            return false
        }
//        image1 = (profileImageData.count > 0)
//        image2 = (frontImageData.count > 0)
//        image3 = (backImageData.count > 0)
        return true
    }
    
    var isValidImages2: Bool {
        guard let profileImage = teacherData.profileimage,
              let frontFaceImage = teacherData.frontfaceidentity,
              let backFaceImage = teacherData.backfaceidentity else {
            return false
        }
        return profileImage.size.width > 0 && frontFaceImage.size.width > 0 && backFaceImage.size.width > 0
    }

    


    var body: some View {
        
        
        //NavigationStack {
            ZStack {
                VStack (spacing: 0) {
                    
                    VStack  {
                        HStack {
                        
                            VStack{
                                
                           // عرض الصورة إذا كانت موجودة
                                if let image = teacherData.profileimage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.15  : screenWidth * 0.2) : screenWidth * 0.2)
                                
                                        .clipShape(Circle())
                                }
                
                                else {
                                    Image("Group 123")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                                }

                                
                                Text("الصورة الشخصية")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                            }
                            
                            Spacer()
                                .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
                            
                            VStack {
                                HStack {
                                    Spacer()
                                        .frame(width: screenWidth * 0.2)
                                    Image("Group 124")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                                }
                                
                                Text("يرجى رفع صورة سيلفي\n واضحة يظهر فيها الوجه\n كاملا")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                                .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        Button(action: {
                            showImagePicker = true
                        
        //
                        }) {
                            Text((teacherData.profileimage != nil) ?  "تم الرفع"
                                 : "تحميل الصورة" )
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                                .frame(height: screenHeight * 0.04)
                                .foregroundColor(.white)
                                .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                        }
                        .background((teacherData.profileimage != nil) ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                        .cornerRadius(5)
//                        .sheet(isPresented: $showImagePicker) {
//                                   ImagePicker(selectedImage: $teacherData.profileimage, sourceType: .camera)
//                               }
                        .sheet(isPresented: $showImagePicker) {
                            SelfieCameraPicker(selectedImage: $teacherData.profileimage)
                        }

                    }
                    
                    Spacer()
                        .frame(height: screenHeight * 0.035)
                    
                    VStack{
                        HStack {
                            
                            
                            VStack {
                                
                                
                                
                            
                                
                                HStack {
                                   
                                    Image("Group 125")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                                        .offset(x: uiDevicePhone ? 0 : screenWidth * 0.04)
                                    Spacer()
                                        .frame(width: screenWidth * 0.28)
                                }
                                
                                
                                
                                
                                
                                
                                
                                Text("يرجى تحميل صور الوجه \nالامامي للبطاقة الموحدة\n الخاصة بك")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                                .multilineTextAlignment(.trailing)
                            }
                            
                            Spacer()
                                .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
                        
                            VStack{
                                
                                
        //                        Image("Group 126")
        //                            .resizable()
        //                            .aspectRatio(contentMode: .fit)
        //                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                                
                                //
                                //
                                // عرض الصورة إذا كانت موجودة
                                     if let imageF = teacherData.frontfaceidentity {
                                         Image(uiImage: imageF)
                                             .resizable()
                                             .scaledToFit()
                                             .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.15  : screenWidth * 0.2) : screenWidth * 0.2)
                                     
                                            // .clipShape(Circle())
                                     }
                     
                                     else {
                                         Image("Group 126")
                                             .resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                                     }
                                //
                                
                                Text("الوجه الامامي للهوية")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                                    .offset(x: uiDevicePhone ? 0 : screenWidth * -0.02)
                            }
                            
                            
                            
                           
                        }
                        
                        Button(action: {
                            
                            showImagePickerFront = true
          
                        }) {
                            Text((teacherData.frontfaceidentity != nil)  ?  "تم الرفع"
                                 : "تحميل الصورة" )
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                                .frame(height: screenHeight * 0.04)
                                .foregroundColor(.white)
                                .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                        }
                        .background((teacherData.frontfaceidentity != nil) ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                        .cornerRadius(5)
                        .sheet(isPresented: $showImagePickerFront) {
                            ImagePicker(selectedImage: $teacherData.frontfaceidentity, sourceType: .camera, uploadType: "Face_id") { success, image in
                                Task {
                                    await MainActor.run {
                                        if success {
                                            teacherData.frontfaceidentity = image
                                            toastTitle = "✅ نجاح"
                                            toastMessage = "تم رفع صورة الوجه الأمامي بنجاح!"
                                            toastColor = Color.green
                                        } else {
                                            toastTitle = "⚠️ خطأ"
                                            toastMessage = "فشل التعرف على الوجه الأمامي. يرجى إعادة المحاولة."
                                            toastColor = Color.red
                                        }
                                        showToast = true
                                    }
                                }
                            }
                        }




                    
//                        .sheet(isPresented: $showImagePickerFront) {
//                                   ImagePicker(selectedImage: $teacherData.frontfaceidentity, sourceType: .camera)
//                               }
                    }
                    
                    
                    Spacer()
                        .frame(height: screenHeight * 0.035)
                    
                    VStack{
                        HStack {
                        
                            VStack{
                                
                                
                                // عرض الصورة إذا كانت موجودة
                                     if let imageB = teacherData.backfaceidentity {
                                         Image(uiImage: imageB)
                                             .resizable()
                                             .scaledToFit()
                                             .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.15  : screenWidth * 0.2) : screenWidth * 0.2)
                                     
                                            // .clipShape(Circle())
                                     }
                     
                                     else {
                                         Image("Group 128")
                                             .resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                                     }
                                
                                
                                
        //                        Image("Group 128")
        //                            .resizable()
        //                            .aspectRatio(contentMode: .fit)
        //                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                                
                                Text("الوجه الخلفي للهوية")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
                            }
                            
                            Spacer()
                                .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
                            
                            VStack {
                                HStack {
                                    Spacer()
                                        .frame(width: screenWidth * 0.2)
                                    Image("Group 127")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                                    
                                 
                                    
                                    
                                }
                                
                                Text("يرجى رفع صورة سيلفي\n واضحة يظهر فيها الوجه\n كاملا")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
                                .multilineTextAlignment(.trailing)
                            }
                        }

                        
                        Button(action: {
                        showImagePickerBack = true
                  
                        }) {
                            Text((teacherData.backfaceidentity != nil)  ?   "تم الرفع"
                                 : "تحميل الصورة" )
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                                .frame(height: screenHeight * 0.04)
                                .foregroundColor(.white)
                                .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                        }
                        .background((teacherData.backfaceidentity != nil) ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                        .cornerRadius(5)
                      
                        .sheet(isPresented: $showImagePickerBack) {
                            ImagePicker(selectedImage: $teacherData.backfaceidentity, sourceType: .camera, uploadType: "back_id") { success, image in
                                Task {
                                    await MainActor.run {
                                        if success {
                                            teacherData.backfaceidentity = image
                                            toastTitle = "✅ نجاح"
                                            toastMessage = "تم رفع صورة الوجه الخلفي بنجاح!"
                                            toastColor = Color.green
                                        } else {
                                            toastTitle = "⚠️ خطأ"
                                            toastMessage = "فشل التعرف على الوجه الخلفي. يرجى إعادة المحاولة."
                                            toastColor = Color.red
                                        }
                                        showToast = true
                                    }
                                }
                            }
                        }




//                        .alert(isPresented: $showAlertUploadSuccess) {
//                            Alert(title: Text("نجاح ✅"), message: Text(alertMessage), dismissButton: .default(Text("تم")))
//                        }
//                        .alert(isPresented: $showAlertUploadFailure) {
//                            Alert(title: Text("خطأ ❌"), message: Text(alertMessage), dismissButton: .default(Text("حاول مرة أخرى")))
//                        }


//                        .sheet(isPresented: $showImagePickerBack) {
//                                   ImagePicker(selectedImage: $teacherData.backfaceidentity, sourceType: .camera)
//                               }

                    }
                    
                    
                    Spacer()
                        .frame(height: screenHeight * 0.02)
                    
                    
                    
                    Button(action: {
                
                        // ✅ استدعاء `addTeacherInfoToCoreData` لحفظ جميع بيانات الأستاذ
                        vmTeacher.addTeacherInfoToCoreData(
                                         from: teacherData,
                                         with: teacherData.profileimage?.jpegData(compressionQuality: 0.8),
                                         with: teacherData.frontfaceidentity?.jpegData(compressionQuality: 0.8),
                                         with: teacherData.backfaceidentity?.jpegData(compressionQuality: 0.8)
                                     )
    
                           
                           if isValidImages2 == false {
                               showAlertEmptyImages = true
                              // print("❌ يجب تحميل جميع الصور قبل الإرسال.")
                               return
                           }
                           
                           // إرسال البيانات
                           SyncTeacherDataPostApi.shared.sendTeacherDataFromViewModel(viewModel: teacherData)
                           print("✅ تم إرسال البيانات.")
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                            print("teacherData.isLoadingRP2 after 30 seconds: \(teacherData.isLoadingRP2)")
                        }

                        
                        
                        if isValidImages2 == true && teacherData.sendTeacherDataToBackEndState == 0 {
                            teacherData.isLoadingRP2 = true
                        }
                        
                        
                       // resetField()
                        
                        
        //                    isPressed.toggle()
        //                    withAnimation(.easeInOut(duration: 0.5)) {
        //                        showError.toggle()
        //                    }
        //                    // Navigate to the next screen upon successful login
        //                    isNavigate = true
                    }) {
                        
                        Text("إرسال البيانات")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
                            .frame(height: screenHeight * 0.04)
                            .foregroundColor(.white)
                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                       
    //                        NavigationLink(destination: registerPageWaitProcess()
    //                            .environmentObject(teacherData)) {
    //                        
    //                    }
    //                        .disabled(!isValidImages)
                        
                    }
                   
                    .background(Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                    .cornerRadius(5)
                
                   
                    
//                    
//                    // طباعة
//                    Button(action: {
//                        let coreDataViewModel = CoreDataViewModel()
//                        coreDataViewModel.printStoredData()
//                        
//                        
//                        
//                        
//                    }) {
//                        
//                       
//                            
//                            VStack{
//                                Text("طباعة البيانات المخزنة")
//                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
//                                    .frame(height: screenHeight * 0.04)
//                                    .foregroundColor(.white)
//                                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
//                            }
//                        
//                        
//                        
//                    
//                    }
//                    .background(Color.blue)
//                    .cornerRadius(5)
//                    
//                    
//        //
//                    
//                    
//                    // delete
//                    Button(action: {
//                        vmTeacher.deleteAllTeacherInfo()
//                    }) {
//                        Text("delete all data ")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
//                            .frame(height: screenHeight * 0.04)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
//                    }
//                    .background(Color.blue)
//                    .cornerRadius(5)
//                    
                    
                    
                    
                    
                    Spacer()
                        .frame(height: screenHeight * 0.02)
                    
                    
               
                }
             

                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                .overlay {
                    LogoIUserInfo()
                        .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
                }
                .navigationBarBackButtonHidden(true)
                .overlay {
                    PreviousNextButtonRP2( geoW: screenWidth, geoH: screenHeight, destination: registerPageWaitProcess().environmentObject(teacherData), color: Color.white, imageName: "Group 9", shouldNavigate: true, notEmptyFields: true)
                        .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)

                }
              
                
                .alert("يجب تحميل صور ", isPresented: $showAlertEmptyImages, actions: {
                    Button("تم", role: .cancel) { }
            })
                
                
                
                
                
            
                           if teacherData.isLoadingRP2  {
                               VStack {
                                   ProgressView("جاري إرسال البيانات...")
                                       .progressViewStyle(CircularProgressViewStyle())
                                       .padding()
                                       .background(Color.white)
                                       .cornerRadius(10)
                                       .shadow(radius: 5)
                               }
                               .frame(maxWidth: .infinity, maxHeight: .infinity)
                               .background(Color.black.opacity(0.3))
                           }
                
                
                // ✅ Custom Toast Overlay
                    if showToast {
                        ToastView(title: toastTitle, message: toastMessage, backgroundColor: toastColor) {
                            showToast = false
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.4)) // تأثير شفاف على الخلفية
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }
                    }

                
            }
         

            .onChange(of: teacherData.isLoadingRP2) { newValue in
                DispatchQueue.main.async {
                    print("isLoadingRP2 changed to: \(newValue)")
                    if !newValue {
                        // إيقاف ProgressView أو أي إجراء آخر
                        print("ProgressView should stop now.")
    //                     goToWaitPage = true
    //                    print("goToWaitPage: \(goToWaitPage)")
//                        navigateTo = "registerPageWaitProcess"
//                        print("navigateTo: \(navigateTo)")

                        shouldNavigate = true
                        

                    }
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                registerPageWaitProcess().environmentObject(teacherData)
                        }
          
       // }

        
      
        
        
    }
    
    func resetField() {
        
        // Clear TeacherDataViewModel fields
        teacherData.name = ""
        teacherData.birthDay = Date()
        teacherData.phonenumber = ""
        teacherData.province = ""
        teacherData.city = "النجف"
        teacherData.citynumber = ""
        teacherData.didyoutaught = false
        teacherData.mosquname = ""
        teacherData.academiclevel = ""
        teacherData.currentWork = ""
      //  teacherData.capturedImage = nil
        
    }
}

#Preview {
    registerPage2()
        .environmentObject(TeacherDataViewModel())
}







import SwiftUI

struct PreviousNextButtonRP2<Destination: View>: View {
    var geoW: CGFloat
    var geoH: CGFloat
    var destination: Destination // الوجهة التي ننتقل إليها
    var color: Color
    var imageName: String
    var shouldNavigate: Bool // شرط الانتقال
    var notEmptyFields: Bool
    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    @Environment(\.dismiss) var dismiss // العودة للصفحة السابقة
    
    var body: some View {
      //  NavigationStack {
            HStack {
                // Previous button icon
            

                // Previous button (Button to dismiss and go back)
                Button(action: {
                    dismiss() // العودة إلى الصفحة السابقة
                }) {
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.04)
                        .padding(.vertical, geoH * 0.01)
                        .padding(.leading, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                        .foregroundColor(color)
                    
                    Text("السابق")
                        .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                        .foregroundColor(color)
                }
                .padding(.horizontal, geoW * 0.001)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Divider line
                Image("Line 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geoH * 0.01, height: geoH * 0.03)
                    .padding(.vertical, geoH * 0.008)
                
                
             

                // Next button with conditional navigation
              //  if shouldNavigate && notEmptyFields { // شرط الانتقال
                  //  NavigationLink(destination: destination) {
                        Text("التالي")
                            .opacity(0.3)
                            .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                            .padding(.horizontal, geoW * 0.001)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        
                        
                        Image("Group 16")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.3)
                            .frame(maxWidth: geoW * 0.04)
                            .padding(.vertical, geoH * 0.01)
                            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                        
                  //  }
                    
              //  }
                
                
                
            }
         
            .background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
            .cornerRadius(5)
            .padding()
       // }
    }
}
