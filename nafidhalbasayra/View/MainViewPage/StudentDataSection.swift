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
    @StateObject var vmStudent = StudentViewModel.shared
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @EnvironmentObject var vmAttendaceStatus : AttendaceStatusViewModel
    @State private var showNoInternetToast = false

    @State private var showDeleteToast = false  // إضافة حالة التبيه للحذف

    
    var body: some View {
       
        VStack{
            HStack{
                
                Text("عدد طلاب الدورة: \(vmStudent.savedEntitiesStudent.count)")
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .padding(.all, screenWidth * 0.025)
            }
            .background(.white)
            .cornerRadius(5)
            .offset(x: uiDevicePhone ? screenWidth * 0.25 : screenWidth * 0.31 ,y: screenHeight * 0.07)
            
            Spacer()
                .frame(height: uiDevicePhone
                       ? (screenWidth > 400 ?  screenHeight * 0.08 : screenHeight * 0.07)
                       : screenHeight * 0.06)
            
            
            
            
            ScrollView {
                ForEach(Array(vmStudent.savedEntitiesStudent.enumerated()), id: \.element.studentID) { index, entity in
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
                        state: Int(entity.state),
                        onDelete: {
                            
                            // عرض Toast بعد الحذف
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                withAnimation {
                                    self.showDeleteToast = true
                                }
                            }

                            // إخفاء الـ Toast بعد 2 ثانية
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    self.showDeleteToast = false
                                }
                            }
                        }
                        
                    )
                    
                }
                
            }
            .scrollIndicators(.hidden) //  إخفاء شريط التمرير
            .frame(maxWidth: .infinity)
            
        

            
            //Button(action: {}){
                NavigationLink(destination: AddStudentToStudentDataSection( )
                    //.environmentObject(teacherData)
                   
                    .environmentObject(vmStudent)){
                    Text("تسجيل بيانات طالب جديد")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                        .foregroundStyle(.white)
                        .frame(width: screenWidth * 0.85)
                        .frame(height: screenHeight * 0.04)
                        .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                        .cornerRadius(5)
                    
                }
            //}
            
            
            Button(action: {
                
                InternetChecker.isInternetAvailable { isAvailable in
                    DispatchQueue.main.async {
                        if isAvailable {
                            
                            Task {
                                         // إرسال بيانات الطلاب
                                  let studentUploader = StudentUploader(database: vmStudent)
                                studentUploader.sendPendingStudentData() // استدعاء الدالة لإرسال بيانات الطلاب
                                   }
                        } else {
                            
                            withAnimation {
                                 showNoInternetToast = true
                                              }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showNoInternetToast = false
                                }
                            }
                        }
                    }
                }
                
                
                
               
                
            }) {
                Text("ارسال الطلبة الغير مرسلين")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.04)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
            }
            .overlay(
                       VStack {
                           if showNoInternetToast {
                               Text("⚠️ لا يوجد اتصال بالإنترنت")
                                   .padding()
                                   .background(Color.red.opacity(0.8))
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                                   .transition(.opacity)
                                   .onAppear {
                                       withAnimation(.easeInOut(duration: 0.5)) {
                                           showNoInternetToast = true
                                       }
                                   }
                                   .onDisappear {
                                       withAnimation(.easeInOut(duration: 0.5)) {
                                           showNoInternetToast = false
                                       }
                                   }
                           }
                           
                           // إضافة التبيه عند الحذف بنجاح
                           if showDeleteToast {
                               Text("✅ تم الحذف بنجاح")
                                   .padding()
                                   .background(Color.green.opacity(0.8))
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                                   .transition(.opacity)
                                   .frame(maxWidth: .infinity)
                                   .padding(.bottom, 50)
                               
                           }
                       }
                       .padding(.bottom, 100),
                       alignment: .bottom
                   )
           
            
            
            
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
                .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
            }
        }
        
        .navigationBarBackButtonHidden(true)
        
            
        
    }
}

//#Preview {
//    StudentDataSection()
//        .environmentObject(TeacherDataViewModel())
//        .environmentObject(StudentViewModel.shared)
//}

#Preview {
    // ✅ إنشاء نسخة من `StudentViewModel.shared`
    let previewStudentViewModel = StudentViewModel.shared

    // ✅ إزالة أي بيانات قديمة
    previewStudentViewModel.savedEntitiesStudent.removeAll()

    // ✅ إنشاء بيانات وهمية
    let student1 = StudentInfo(context: previewStudentViewModel.container.viewContext)
    student1.setValue(UUID().uuidString, forKey: "studentID")
    student1.setValue("أحمد محمد محمد", forKey: "name")
    student1.setValue("14", forKey: "age")
    student1.setValue("0912345678", forKey: "phoneNumber")
    student1.setValue("طرابلس", forKey: "city")
    student1.setValue("إعدادي", forKey: "level")
    student1.setValue("متوسط", forKey: "size")
    student1.setValue(1, forKey: "state")

    let student2 = StudentInfo(context: previewStudentViewModel.container.viewContext)
    student2.setValue(UUID().uuidString, forKey: "studentID")
    student2.setValue("فاطمة الزهراء محمد محمد", forKey: "name")
    student2.setValue("12", forKey: "age")
    student2.setValue("0923456789", forKey: "phoneNumber")
    student2.setValue("بنغازي", forKey: "city")
    student2.setValue("إعدادي", forKey: "level")
    student2.setValue("صغير", forKey: "size")
    student2.setValue(2, forKey: "state")
    
    let student3 = StudentInfo(context: previewStudentViewModel.container.viewContext)
    student2.setValue(UUID().uuidString, forKey: "studentID")
    student2.setValue("فاطمة الزهراء محمد محمد", forKey: "name")
    student2.setValue("12", forKey: "age")
    student2.setValue("0923456789", forKey: "phoneNumber")
    student2.setValue("بنغازي", forKey: "city")
    student2.setValue("إعدادي", forKey: "level")
    student2.setValue("صغير", forKey: "size")
    student2.setValue(2, forKey: "state")

    // ✅ إضافة الطلاب إلى المصفوفة
    previewStudentViewModel.savedEntitiesStudent.append(student1)
    previewStudentViewModel.savedEntitiesStudent.append(student2)
    previewStudentViewModel.savedEntitiesStudent.append(student3)


    return StudentDataSection()
        .environmentObject(TeacherDataViewModel()) // ✅ تمرير بيانات المعلم
        .environmentObject(previewStudentViewModel) // ✅ تمرير بيانات الطلاب
}











struct studentInfo :View {
    
    @ObservedObject var vmStudent = StudentViewModel.shared
    @EnvironmentObject var teacherData: TeacherDataViewModel

  //  @State var selectedStudent: StudentInfo?
    @State var updatedName: String = ""
    
    @State private var isDeleteConfirmation = false
    @State private var showAlert = false  // عرض التنبيه
    @State private var alertTitle = ""    // عنوان التنبيه
    @State private var alertMessage = ""
    
    @State private var showInternetAlert = false
    @State private var alertInternetMessage = ""
    @State private var showDeleteToast = false
    
    
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
    var onDelete: () -> Void
    
   
    
    var body: some View {
        
        
        
          VStack {
              Color.clear
                  .frame(height: uiDevicePhone ? screenHeight * 0.01 : screenHeight * 0.02)
              
              VStack {
                      
                  HStack(alignment: .firstTextBaseline) { // ✅ يضمن بقاء جميع النصوص على نفس الخط
                      // المرحلة (على اليسار)
                      VStack(alignment: .leading) {
                          Text("المرحلة")
                              .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                              .frame(maxWidth: .infinity, minHeight: screenHeight * 0.04, alignment: .leading) // ✅ ضبط الارتفاع

                          Text(level)
                              .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .minimumScaleFactor(0.8)
                              .lineLimit(1)
                      }

                      // العمر (في المنتصف)
                      VStack(alignment: .center) {
                          Text("العمر")
                              .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                              .frame(maxWidth: .infinity, minHeight: screenHeight * 0.04, alignment: .center) // ✅ ضبط الارتفاع

                          Text(age)
                              .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                              .frame(maxWidth: .infinity, alignment: .center)
                              .minimumScaleFactor(0.8)
                              .lineLimit(1)
                      }

                      // الاسم (على اليمين)
                      VStack(alignment: .trailing) {
                          Text("اسم الطالب")
                              .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                              .frame(maxWidth: .infinity, minHeight: screenHeight * 0.04, alignment: .trailing) // ✅ ضبط الارتفاع

                          Text(name)
                              .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                              .frame(maxWidth: .infinity, alignment: .trailing)
                              .minimumScaleFactor(0.7)
                              .lineLimit(1)
                      }
                  }
                  .frame(maxWidth: .infinity)
                  .padding(.horizontal, screenWidth * 0.05) // ✅ إضافة مسافة من الجوانب


                      
                      HStack(spacing: 0) {
                                 // First half with red background
                                 ZStack {
                                     Color(red: 228/255, green: 194/255, blue: 194/255)
                                     
                                     
                                     Button(action: {
                                         
                                         alertTitle = "تأكيد الحذف"
                                         alertMessage = "هل أنت متأكد أنك تريد حذف الطالب \n\(student.name ?? "بدون اسم")؟"
                                           isDeleteConfirmation = true
                                           showAlert = true
   
                                     }) {
                                         Text("حذف بيانات الطالب")
                                             .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                                             .foregroundColor(Color(red: 123/255, green: 42/255, blue: 42/255))
                                             .padding(.all, screenWidth * 0.02)
                                     }
//                                     .alert(isPresented: $showAlert) {
//                                         Alert(
//                                             title: Text(alertTitle),
//                                             message: Text(alertMessage),
//                                             dismissButton: .default(Text("حسنًا"))
//                                         )
//                                     }
//                                     .confirmationDialog("هل أنت متأكد أنك تريد حذف الطالب؟", isPresented: $isDeleteConfirmation, titleVisibility: .visible) {
//                                         Button("نعم", role: .destructive) {
//                                             deleteStudent() // تنفيذ عملية الحذف بعد التأكيد
//                                         }
//                                         Button("إلغاء", role: .cancel) {}
//                                     }

                                     .alert(isPresented: $showAlert) {
                                         if isDeleteConfirmation {
                                             // إذا كانت حالة التأكيد على الحذف
                                             return Alert(
                                                 title: Text(alertTitle),
                                                 message: Text(alertMessage),
                                                 primaryButton: .destructive(Text("نعم")) {
                                                     // تنفيذ عملية الحذف بعد التأكيد
                                                     deleteStudent()
                   
                                                 },
                                                 secondaryButton: .cancel(Text("إلغاء"))
                                             )
                                         } else {
                                             // إذا كانت حالة التنبيه العام
                                             return Alert(
                                                 title: Text(alertTitle),
                                                 message: Text(alertMessage),
                                                 dismissButton: .default(Text("حسنًا"))
                                             )
                                         }
                                     }




                                     
                                 }
                                 
                                 .frame(maxWidth: .infinity) // Takes up half of the HStack width
                          
                          
                          
                          
                          
                          // send or not
                          VStack{
                              Text(" \(state == 1 ? "مرسل" : "غير مرسل")")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                                  .padding(.all, screenWidth * 0.02)
                                  .foregroundColor(.white) // ✅ لون مختلف حسب الحالة
                          }
                          .background(Color.green)
                          
                          //
                          
                                 
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
                  .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.05)
                  .overlay( Text("\(orderNumber)")
                    .foregroundColor(.white))
                
                  .frame(width: screenWidth * 0.06)
                  .position(x: screenWidth * 0.42, y: uiDevicePhone ?  screenHeight * 0.02 : screenHeight * 0.025) // تعديل الإحداثيات

          }
        
        
    }
    
    
    
    
    //  تنفيذ عملية الحذف بعد تأكيد المستخدم
    func deleteStudent() {
 
        
        // إذا كانت حالة الطالب تساوي 0، احذفه مباشرةً محليًا دون التحقق من الإنترنت
          if student.state == 0 {
              if let index = vmStudent.savedEntitiesStudent.firstIndex(of: student) {
                  vmStudent.deleteStudentInfo(indexSet: IndexSet(integer: index))
              }

              onDelete()
              
              return
          }
 
        // إذا لم تكن الحالة 0، تحقق من الإنترنت وحاول حذفه من السيرفر
        InternetChecker.isInternetAvailable { isAvailable in
            DispatchQueue.main.async {
                if isAvailable {
                    if let idFromApi = student.idFromApi {
                        StudentDeleter.deleteStudent(withId: idFromApi) { success, statusCode, errorMessage in
                            DispatchQueue.main.async {
                                if success {
//                                    alertTitle = "✅ نجاح"
//                                    alertMessage = "تم حذف الطالب من الخادم بنجاح."
                                    
                                    // حذف الطالب محليًا بعد التأكيد
                                    if let index = vmStudent.savedEntitiesStudent.firstIndex(of: student) {
                                        vmStudent.deleteStudentInfo(indexSet: IndexSet(integer: index))
                                    }
                                    onDelete()
                                    
                                } else {
                                    alertTitle = "❌ فشل الحذف"
                                    alertMessage = "فشل حذف الطالب من الخادم: \(errorMessage ?? "خطأ غير معروف")"
                                }
                                
                                isDeleteConfirmation = false
                                showAlert = true

                                
                            }
                        }
                    } else {
                        alertTitle = "❌ خطأ"
                        alertMessage = "لا يمكن حذف الطالب لأن المعرف غير صالح."
                        isDeleteConfirmation = false
                        showAlert = true
                    }
                } else {
                    alertTitle = "⚠️ لا يوجد إنترنت"
                    alertMessage = "يجب توفر اتصال بالإنترنت لتنفيذ عملية الحذف، لأن البيانات مخزنة على الخادم."
                    isDeleteConfirmation = false
                    showAlert = true
                }
            }
        }
    }
    
    
    

    
}


