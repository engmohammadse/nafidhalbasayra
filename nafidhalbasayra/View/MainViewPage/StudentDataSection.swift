//
//  AttendanceHistorySection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 16/10/2024.
//

import SwiftUI

struct StudentDataSection: View {
    @Environment(\.dismiss) var dismiss
    
    
    @State private var selectedStudent: StudentInfo? = nil
    @StateObject var vmStudent = StudentViewModel()
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
    
   
    
    var body: some View {
       
        VStack{
            HStack{
                
                Text("عدد طلاب الدورة: \(vmStudent.savedEntities.count)")
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .padding(.all, screenWidth * 0.025)
            }
            .background(.white)
            .cornerRadius(5)
            .offset(x: screenWidth * 0.25 ,y: screenHeight * 0.05)
            
            Spacer()
                .frame(height: screenHeight * 0.07)
            
            
            
            
            ScrollView {
                ForEach(Array(vmStudent.savedEntities.enumerated()), id: \.element.studentID) { index, entity in
                    studentInfo(
                        vmStudent: vmStudent,
                        name: entity.name ?? "لا يوجد اسم",
                        age: entity.age ?? "no",
                        phoneNumber: entity.phoneNumber ?? "no number",
                        city: entity.city ?? "no city",
                        level: entity.level ?? "no level",
                        size: entity.size ?? "no size",
                        student: entity,
                        orderNumber: index + 1,
                        onEdit: { selectedStudent = entity }, // تعيين الطالب المحدد
                        state: Int(entity.state)
                    )
                    
                }
                
            }
            
           

            
//            ScrollView {
//                ForEach(Array(vmStudent.savedEntities.enumerated()), id: \.element) { index, entity in
//                    studentInfo(vmStudent: vmStudent, name: entity.name ?? "لا يوجد اسم", age: entity.age ?? "no", phoneNumber: entity.phoneNumber ?? "no number",city: entity.city ?? " no c", level: entity.level ?? " no level",size: entity.size ?? " no size", student: entity, orderNumber: index + 1)
//                    
////                    studentInfo(vmStudent: vmStudent, name: entity.name ?? "لا يوجد اسم", age: entity.age ?? "no", phoneNumber: entity.phoneNumber ?? "no number", student: entity, orderNumber: index + 1)
//                }
//                
//                
//                
//            }
            .frame(maxWidth: .infinity)
            
            
            //Button(action: {}){
                NavigationLink(destination: AddStudentToStudentDataSection( )
                    //.environmentObject(teacherData)
                   
                    .environmentObject(vmStudent)){
                    Text("تسجيل بيانات طالب جديد")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                        .foregroundStyle(.white)
                        .frame(width: screenWidth * 0.85)
                        .frame(height: screenHeight * 0.05)
                        .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                        .cornerRadius(5)
                    
                }
            //}
           
            
            
            
        }
        .padding()
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .overlay{
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
             
        }
    
        
        
        
        .overlay{
            ZStack{
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.09 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        
        .navigationBarBackButtonHidden(true)
        
            
        
    }
}

#Preview {
    StudentDataSection()
        .environmentObject(TeacherDataViewModel())
        .environmentObject(StudentViewModel())
}












struct studentInfo :View {
    
    @ObservedObject var vmStudent = StudentViewModel()
    @EnvironmentObject var teacherData: TeacherDataViewModel

  //  @State var selectedStudent: StudentInfo?
    @State var updatedName: String = ""
    
    
    @State private var showInternetAlert = false
      @State private var alertInternetMessage = ""
    
    
    var name: String
    var age: String
    var phoneNumber: String
    var city: String
    var level: String
    var size: String
    var student: StudentInfo // إضافة هذا المتغير للإشارة إلى الكائن الحالي
    var orderNumber: Int
    var onEdit: () -> Void
    var state: Int
    
   
    
    var body: some View {
        
        
        
          VStack {
              Color.clear
                  .frame(height: screenHeight * 0.05)
              
              VStack {
                      
                      HStack{
                          
                          VStack{
                              Text("المرحلة")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                              Spacer()
                                  
                                  .frame(height: screenHeight * 0.02)
                              Text(level)
                                  .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                              
                              
                          }
                          Spacer()
                              .frame(width: screenWidth * 0.15)
                          
                          VStack{
                              Text("العمر")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                              Spacer()
                                  .frame(height: screenHeight * 0.02)
                              Text(age)
                                  .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                          }
                          
                          
                          Spacer()
                              .frame(width: screenWidth * 0.05)
                          
                          VStack{
                              Text("اسم الطالب")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                              Spacer()
                                  .frame(height: screenHeight * 0.02)
                              
                     
                           
                              
                              
                              Text(name)
                                  .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                              
                              
                              Text("\(state)")

//                              Text(phoneNumber)
//                              Text(age)
//                              Text(city)
//                              Text(level)
//                              Text(size)
                          }
   
                      }
                      
                      HStack(spacing: 0) {
                                 // First half with red background
                                 ZStack {
                                     Color(red: 228/255, green: 194/255, blue: 194/255)
                                     
                                     
                                     Button(action: {
                                         
                                         InternetChecker.isInternetAvailable { isAvailable in
                                             DispatchQueue.main.async {
                                                 if isAvailable {
                                                     // التحقق من وجود idFromApi
                                                     if let idFromApi = student.idFromApi {
                                                         // استدعاء دالة الحذف من API
                                                         StudentDeleter.deleteStudent(withId: idFromApi) { success, statusCode, errorMessage in
                                                             DispatchQueue.main.async {
                                                                 if success {
                                                                     
                                                                     // عرض التنبيه أولاً
                                                                     alertInternetMessage = "✅ تم حذف الطالب من الخادم بنجاح."
                                                                     showInternetAlert = true
                                                                     print("idFromApi was delete: \(idFromApi)")
//                                                                     // حذف الطالب محليًا بعد عرض التنبيه
                                                                         if let index = vmStudent.savedEntities.firstIndex(of: student) {
                                                                             vmStudent.deleteStudentInfo(indexSet: IndexSet(integer: index))
                                                                         }
//                                                                     
//                                                                     
//                                                                     print("✅ تم حذف الطالب من الخادم بنجاح.")

                                                                 } else {
                                                                     print("❌ فشل حذف الطالب من الخادم. رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
                                                                     // عرض رسالة خطأ
                                                                     alertInternetMessage = "فشل الحذف من الخادم: \(errorMessage ?? "خطأ غير معروف")"
                                                                     showInternetAlert = true
                                                                 }
                                                             }
                                                         }
                                                     } else {
                                                         print("❌ لا يحتوي الطالب على معرف idFromApi صالح.")
                                                         alertInternetMessage = "لا يمكن حذف الطالب لأن المعرف غير صالح."
                                                         showInternetAlert = true
                                                     }
                                                 } else {
                                                     print("❌ لا يوجد اتصال بالإنترنت.")
                                                     alertInternetMessage = "يجب توفر اتصال بالإنترنت لتنفيذ عملية الحذف."
                                                     showInternetAlert = true
                                                 }
                                             }
                                         }

                                         
//                                         InternetChecker.isInternetAvailable { isAvailable in
//                                             DispatchQueue.main.async {
//                                                 if isAvailable {
//                                                     // التحقق من وجود idFromApi
//                                                     if let idFromApi = student.idFromApi {
//                                                         // استدعاء دالة الحذف من API
//                                                         StudentDeleter.deleteStudent(withId: idFromApi) { success, statusCode, errorMessage in
//                                                             DispatchQueue.main.async {
//                                                                 if success {
//                                                                     print("✅ تم حذف الطالب من الخادم بنجاح.")
//                                                                     
//                                                                    
//                                                                     alertInternetMessage = ("✅ تم حذف الطالب من الخادم بنجاح.")
//                                                                     showInternetAlert = true
//                                                                     
//                                                                     // حذف الطالب محليًا
//                                                                     if let index = vmStudent.savedEntities.firstIndex(of: student) {
//                                                                         vmStudent.deleteStudentInfo(indexSet: IndexSet(integer: index))
//                                                                       
//                                                                     }
//                                                                 } else {
//                                                                     print("❌ فشل حذف الطالب من الخادم. رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
//                                                                     // عرض رسالة خطأ
//                                                                     alertInternetMessage = "فشل الحذف من الخادم: \(errorMessage ?? "خطأ غير معروف")"
//                                                                     showInternetAlert = true
//                                                                 }
//                                                             }
//                                                         }
//                                                     } else {
//                                                         print("❌ لا يحتوي الطالب على معرف idFromApi صالح.")
//                                                         alertInternetMessage = "لا يمكن حذف الطالب لأن المعرف غير صالح."
//                                                         showInternetAlert = true
//                                                     }
//                                                 } else {
//                                                     print("❌ لا يوجد اتصال بالإنترنت.")
//                                                     alertInternetMessage = "يجب توفر اتصال بالإنترنت لتنفيذ عملية الحذف."
//                                                     showInternetAlert = true
//                                                 }
//                                             }
//                                         }

                                         
//                                         InternetChecker.isInternetAvailable { isAvailable in
//                                             
//                                             DispatchQueue.main.async {
//                                                 if isAvailable {
//                                                     
//                                                     if let index = vmStudent.savedEntities.firstIndex(of: student) {
//                                                         vmStudent.deleteStudentInfo(indexSet: IndexSet(integer: index))
//                                                     }
//                                                 } else {
//                                                     showInternetAlert = true
//                                                 }
//                                             }
//                                             
//                                             
//                                         }
                                         
                                         
                                       
                                         
                                         
                                     }) {
                                         Text("حذف بيانات الطالب")
                                             .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                                             .foregroundColor(Color(red: 123/255, green: 42/255, blue: 42/255))
                                             .padding(.all, screenWidth * 0.02)
                                     }
                                     .alert(isPresented: $showInternetAlert) {
                                         Alert(
                                             title: Text("حالة الإنترنت"),
                                             message: Text(alertInternetMessage),
                                             dismissButton: .default(Text("حسنًا")) {
                                                 // إجراء إضافي بعد إغلاق التنبيه إذا لزم الأمر
                                             }
                                         )
                                     }



                                     
                                 }
                                 
                                 .frame(maxWidth: .infinity) // Takes up half of the HStack width
                          
                                 
                                 // Second half with blue background
                                 ZStack {
                                     Color(red: 223/255, green: 239/255, blue: 242/255)
                                     
                                     Button(action: {
                                         
                                         
                                         
                                     }){
//                                         Text("تعديل البيانات")
//                                             .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
//                                             .foregroundColor(Color(red: 24/255, green: 82/255, blue: 100/255))
//                                             .padding(.all, screenWidth * 0.02)
                                         
                                         NavigationLink(destination: EditStudentAtStudentDataSection(student: student, teacherData: TeacherDataViewModel() )
                                            .environmentObject(vmStudent)
                                            .environmentObject(teacherData)
                                         )
                                         {
                                             Text("تعديل البيانات")
                                                
                                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023)) .foregroundColor(Color(red: 24/255, green: 82/255, blue: 100/255)) .padding(.all, screenWidth * 0.02) }
                                         
                                         
                                         
                                         
                                         
                                         
                                     }
                                     
                                 }
                               
                                 .frame(maxWidth: .infinity) // Takes up half of the HStack width
                             }
                             
                      
                      
                      
              }.padding(.top, screenHeight * 0.025)
                  
              
                  .background(Color.white)
              .cornerRadius(5)
            
          } 
          .frame(width: screenWidth * 0.85)
          .padding(.bottom, screenHeight * 0.01)
          
          
          .overlay{
            //  Image("Group 124")
              //Text("\(orderNumber)")
              Circle()
                  .fill(primaryColor)
                  .frame(width: screenWidth * 0.065)
                  .overlay( Text("\(orderNumber)")
                    .foregroundColor(.white))
                
                  .frame(width: screenWidth * 0.06)
                  .offset(y: screenHeight * -0.06)
             
          }
        
        
    }
}
