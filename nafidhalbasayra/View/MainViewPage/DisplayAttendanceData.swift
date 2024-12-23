//
//  DisplayAttendanceData.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/11/2024.
//



import SwiftUI
import CoreLocation

struct DisplayAttendanceData: View {
    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("بيانات الحضور المخزنة")
                .font(.title)
                .padding()

            List(vmAttendaceStatus.savedEntities) { entity in
                VStack(alignment: .leading, spacing: 10) {
                    if let latitude = entity.latitude as? Double, let longitude = entity.longitude as? Double {
                        Text("الموقع: (\(latitude), \(longitude))")
                        Text("بدون اضافات")
                        Text("\(latitude), \(longitude)")
//                        {"lng":2332,"lat":34434}
                    }
                    
                    
                    Text("state is: \(entity.state)")

                    
                    if let numberOfStudents = entity.numberOfStudents {
                        Text("عدد الطلاب: \(numberOfStudents)")
                    }

                    if let imageData = entity.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    }

                    if let notes = entity.notes {
                        Text("الملاحظات: \(notes)")
                    }
                    
                    if let date = entity.date {
                        Text("الملاحظات: \(date)")
                    }
                }
                .padding()
            }
        }
        .overlay {
            ZStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        .padding()
    }
}

#Preview {
    DisplayAttendanceData().environmentObject(AttendaceStatusViewModel())
}
















//import SwiftUI
//import CoreLocation
//
//struct DisplayAttendanceData: View {
//    @ObservedObject var vmAttendaceStatus: AttendaceStatusViewModel
//    @Environment(\.dismiss) var dismiss
//
//
//    var body: some View {
//        VStack {
//            Text("بيانات الحضور المخزنة")
//                .font(.title)
//                .padding()
//
//            List(vmAttendaceStatus.savedEntities) { entity in
//                VStack(alignment: .leading, spacing: 10) {
//                    if let latitude = entity.latitude as? Double, let longitude = entity.longitude as? Double {
//                        Text("الموقع: (\(latitude), \(longitude))")
//                    }
//                    
//                    if let numberOfStudents = entity.numberOfStudents {
//                        Text("عدد الطلاب: \(numberOfStudents)")
//                    }
//
//                    if let imageData = entity.image, let uiImage = UIImage(data: imageData) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100, height: 100)
//                    }
//
//                    if let notes = entity.notes {
//                        Text("الملاحظات: \(notes)")
//                    }
//                }
//                .padding()
//            }
//        }
//        .overlay{
//            ZStack{
//                Button(action: {
//                    
//                    dismiss()
//                }) {
//                    Image("Group 56")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
//                }
//                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    DisplayAttendanceData(vmAttendaceStatus: AttendaceStatusViewModel())
//}
