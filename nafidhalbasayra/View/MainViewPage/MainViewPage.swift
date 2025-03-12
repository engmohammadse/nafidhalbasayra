//
//  MainViewPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct MainViewPage: View {
    //@EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
    
   // @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    


    @StateObject var vmAttendaceStatus = AttendaceStatusViewModel.shared

    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    @StateObject var studentFetcher = fetchAndStoreStudentsFromBackEnd(database: StudentViewModel.shared)
    @StateObject var attendanceFetcher = fetchAndStoreAttendancesFromBackEnd(database: AttendaceStatusViewModel.shared)

    @StateObject var studentViewModel = StudentViewModel.shared
    
    
    var body: some View {
        
        
  
        ZStack {
               
                      VStack(spacing: screenHeight * 0.02) {
                          
                          Spacer().frame(height: uiDevicePhone ? screenHeight * 0.42 :  screenHeight * 0.4 )
                          
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 20", text: "إرسال الحضور", destination: sendAttendanceSection()
                                .environmentObject(StudentViewModel.shared)
                                .environmentObject(teacherData)
                                .environmentObject(vmAttendaceStatus))
                              
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات", destination: NotificationChannelSection()
                                .environmentObject(teacherData)
                                  .environmentObject(vmAttendaceStatus))
                          }
                          
                        //  Spacer().frame(height: screenHeight * 0.0)
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 24", text: "سجل الحضور", destination: HistoryAttendance()
                                .environmentObject(teacherData)
                                  .environmentObject(vmAttendaceStatus)
                              )
                              VStackSection(imageName: "Group 23", text: "بيانات الطلبة", destination: StudentDataSection()
                                .environmentObject(teacherData)
                                  .environmentObject(vmAttendaceStatus))
                          }
                          
                         // Spacer().frame(height: screenHeight * 0.02)
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 29", text: "دليل الاستخدام", destination: UserManual()
                                .environmentObject(teacherData)
                                .environmentObject(vmAttendaceStatus))
                              VStackSection(imageName: "folder-minus-solid 1", text: "الخطة الدراسية", destination: StudyPlanSection()
                                .environmentObject(teacherData)
                                  .environmentObject(vmAttendaceStatus))
                          }
        
                      }
                     // .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                      .offset(y: screenHeight * -0.17)
                
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            
            

            
               // button setting
                    VStack {
                        
                        
                            ButtonSetting()
                        
                        
                        
                        //SettingSection
                        
                        Spacer()
                            .frame(height: screenHeight * 0.02)
                        HStack{
                            socialMediaButton(url: "https://www.alkafeelquran.com", image: "globe-solid")
                            socialMediaButton(url: "https://t.me/AlKafeelQuraanNajaf", image: "Group 39")
                            socialMediaButton(url: "https://www.facebook.com/AlKafeelQuraanNajaf/?locale=ar_AR", image: "Group 40")
                            socialMediaButton(url: "https://www.instagram.com/accounts/login/?next=https%3A%2F%2Fwww.instagram.com%2Falkafeelquraannajaf%2F%3Fhl%3Dar&is_from_rle", image: "Group 36")
                            
                        }
                    }
                    .offset(y: screenHeight > 700 ?  screenHeight * 0.36 : screenHeight * 0.39)
            
            //HadeethSection
            
            VStack{
                Spacer().frame(height: uiDevicePhone ? screenHeight * 0.075 : screenHeight * 0.1)
                
                HadeethSection()
                  
                    .overlay(
                        LogoIUserInfo()
                            .environmentObject(teacherData)
                              .environmentObject(vmAttendaceStatus)
                            .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * -0.07 : screenHeight * -0.08)
                    )
            }
      
       }
        .environmentObject(teacherData) // إضافة الكائن إلى البيئة
        .navigationBarBackButtonHidden(true)
        .onAppear {
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                
//                   let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//                   attendanceUploader.sendPendingAttendanceData()
                
                // إرسال بيانات الطلاب
//                let studentUploader = StudentUploader(database: studentViewModel)
//                studentUploader.sendPendingStudentData() // استدعاء الدالة لإرسال بيانات الطلاب
//                
                
                Task {
                                   await attendanceFetcher.fetchAndStoreAttendances(teacherID: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7")
                               }
                
                Task {
                           await studentFetcher.fetchAndStoreStudents(teacherID: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7") // 🔹 جلب الطلاب عند إعادة فتح التطبيق
                       }
                
               }

//            let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
//            attendanceUploader.sendPendingAttendanceData()

            
        



                }


    }
}

#Preview {
    MainViewPage()
        .environmentObject(AttendaceStatusViewModel.shared)
        .environmentObject(TeacherDataViewModel())
}

//
//.frame(maxWidth: .infinity, maxHeight: .infinity)
//.background(Color(red: 236/255, green: 242/255, blue: 245/255))


//.background(Color(red: 236/255, green: 242/255, blue: 245/255))



struct VStackSection<Destination: View>: View {
    //@EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel

    let imageName: String
    let text: String
    @State var destination : Destination
    
    var body: some View {
        VStack {
            
            
            Button(action: {
                
                
            }){
                
               
           
                
                
                
                NavigationLink(destination: destination
                    //.environmentObject(vmAttendaceStatus)
                )
                {
                    VStack{
                        
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.07)
                            .padding(.top, uiDevicePhone ? screenHeight * 0.03 : screenHeight * 0.02)
                        Spacer()
                            .frame(height: screenHeight * 0.02)
                        
                        Text(text)
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03  : screenWidth * 0.025))
                           
                            .foregroundColor(.black)
                            .padding(.horizontal, screenWidth * 0.04)
                            .padding(.bottom, screenHeight * 0.02)
                            .frame(height:  uiDevicePhone ? screenHeight * 0.04 : screenHeight * 0.05)
                            .frame(width: uiDevicePhone ? screenWidth * 0.3 : screenWidth * 0.26)
                        
                       
                        
                    }
                }
                
            }
          
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}


struct ButtonSetting: View {
    var body: some View {
        NavigationLink(destination: TeacherProfileView()) {
            HStack {
                Text("الإعدادات")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.033 : screenWidth * 0.025))
                    .foregroundStyle(Color.black)

                Image("VectorSetting")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: uiDevicePhone ? screenWidth * 0.05 : screenWidth * 0.04)
            }
            .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.56, height: screenHeight * 0.05)
            .background(Color.white)
            .cornerRadius(5)
            .contentShape(Rectangle()) //  يجعل المساحة الفارغة داخل HStack قابلة للنقر
        }
    }
}


//struct ButtonSetting: View {
//    var body: some View {
//        NavigationLink(destination: SettingSection(province: .constant(""))) {
//            HStack {
//                Text("الإعدادات")
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.033 : screenWidth * 0.025))
//                    .foregroundStyle(Color.black)
//
//                Image("VectorSetting")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: uiDevicePhone ? screenWidth * 0.05 : screenWidth * 0.04)
//            }
//            .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.56, height: screenHeight * 0.05)
//            .background(Color.white)
//            .cornerRadius(5)
//            .contentShape(Rectangle()) //  يجعل المساحة الفارغة داخل HStack قابلة للنقر
//        }
//    }
//}




