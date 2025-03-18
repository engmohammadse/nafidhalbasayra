

import SwiftUI

struct TeacherProfileView: View {
    @StateObject var vmTeacher = CoreDataViewModel.shared
    @State private var showDeleteConfirmation = false
    @State private var profileImage: UIImage? = getSavedProfileImage()
    @Environment(\.dismiss) var dismiss

    var teacher: TeacherInfo? {
        return vmTeacher.savedEntitiesTeacher.first
    }
    

    var body: some View {
        //NavigationStack {
            VStack(spacing: 15) {
             
                //  عنوان الصفحة
                Text("الملف الشخصي للأستاذ")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundColor(primaryColor)
                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.05)
                    .background(Color(red: 220 / 255, green: 225 / 255, blue: 230 / 255))
                    .cornerRadius(8)
                    .padding(.top, screenHeight * 0.08)
                   
                

                if let teacher = teacher {
                    //  صورة الأستاذ الشخصية
                    
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(primaryColor, lineWidth: 2))
                            .shadow(radius: 4)
                            .padding(.top, uiDevicePhone ? screenHeight * 0.04 : screenHeight * 0.08)
                            .padding(.bottom, uiDevicePhone ? screenHeight * 0.05 : screenHeight * 0.08)
                        
                        
                        
                    }  else if let imageData = teacher.profileimage, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(primaryColor, lineWidth: 2))
                            .shadow(radius: 4)
                            .padding(.top, uiDevicePhone ? screenHeight * 0.04 : screenHeight * 0.08)
                            .padding(.bottom, uiDevicePhone ? screenHeight * 0.05 : screenHeight * 0.08)

                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .padding(.top, uiDevicePhone ? screenHeight * 0.04 : screenHeight * 0.08)
                            .padding(.bottom, uiDevicePhone ? screenHeight * 0.05 : screenHeight * 0.08)


                    }
                    
                    
                   

                    //  معلومات الأستاذ
                    VStack(alignment: .trailing, spacing: 10) {
                        InfoRow(title: "الاسم:", value: teacher.name ?? "غير معروف")
                        InfoRow(title: "تاريخ الميلاد:", value: teacher.birthDay?.formatted(date: .long, time: .omitted) ?? "غير مدخل")
                        InfoRow(title: "رقم الهاتف:", value: teacher.phonenumber)
                        InfoRow(title: "اسم المسجد:", value: teacher.mosquname ?? "غير مدخل")
                        InfoRow(title: "المستوى الأكاديمي:", value: teacher.academiclevel ?? "غير مدخل")
                        InfoRow(title: "الوظيفة الحالية:", value: teacher.currentWork ?? "غير مدخلة")
                        InfoRow(title: "هل قام بالتدريس:", value: teacher.didyoutaught ? "نعم" : "لا")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)

                    //  عرض صور الهوية أفقيًا مع التأكد من توحيد الارتفاع
                    HStack(spacing: 15) {
                        if let frontData = teacher.frontfaceidentity, let frontImage = UIImage(data: frontData) {
                            IDImageView(image: frontImage, title: "الوجه الأمامي")
                        }
                        if let backData = teacher.backfaceidentity, let backImage = UIImage(data: backData) {
                            IDImageView(image: backImage, title: "الوجه الخلفي")
                        }
                    }
                    .frame(maxWidth: .infinity) // يضمن توسيع الـ HStack عبر الشاشة بالكامل
                    .padding(.horizontal)
                    .padding(.vertical)
                    .padding(.bottom, uiDevicePhone ? screenHeight * 0.03 : screenHeight * 0.05)


                } else {
                    Text("لم يتم العثور على بيانات للأستاذ.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.horizontal, screenWidth * 0.05)
            .navigationSplitViewStyle(.automatic) //  يمنع ظهور الـ Sidebar في iPad
            .navigationBarBackButtonHidden(true)
            .onAppear {
                vmTeacher.fetchTeacherInfo()
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColorPage)
            .environment(\.layoutDirection, .rightToLeft) // 🔹 تفعيل RTL

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
            
       // }
      
    }
}

//  مكون لإظهار المعلومات
struct InfoRow: View {
    let title: String
    let value: String?

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                .foregroundColor(primaryColor)

            Spacer()

            Text(value ?? "غير متوفر")
                .foregroundColor(.black)
                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
        }
        .padding(.horizontal)
    }
}

//  مكون لعرض صور الهوية مع توحيد الحجم وتدوير الصور العمودية
struct IDImageView: View {
    let image: UIImage
    let title: String

    var rotatedImage: UIImage {
        if image.size.height > image.size.width {
            return image.rotated(by: 90) ?? image //  تدوير 90 درجة إذا كانت الصورة عمودية
        }
        return image
    }

    var body: some View {
        VStack {
            Image(uiImage: rotatedImage)
                .resizable()
                .scaledToFit()
                .frame(width: uiDevicePhone ?  160 : 300, height: uiDevicePhone ?  120 : 240) //  عرض الصورة أفقيًا دائمًا
                .cornerRadius(10)
                .shadow(radius: 5)

            Text(title)
                .font(.custom("BahijTheSansArabic-Bold", size: 14))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center) //  جعل النصوص في نفس المستوى
        }
    }
}

//  امتداد لتدوير الصور
import UIKit

extension UIImage {
    func rotated(by degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180
        let newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}

#Preview {
    TeacherProfileView()
}





















//
//import SwiftUI
//
//struct TeacherProfileView: View {
//    @StateObject var vmTeacher = CoreDataViewModel.shared
//    @State private var showDeleteConfirmation = false
//
//    var teacher: TeacherInfo? {
//        return vmTeacher.savedEntitiesTeacher.first
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 15) {
//                // ✅ عنوان الصفحة
//                Text("الملف الشخصي للأستاذ")
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
//                    .foregroundColor(.white)
//                    .frame(width: screenWidth * 0.85, height: screenHeight * 0.05)
//                    .background(primaryColor)
//                    .cornerRadius(8)
//                    .padding(.top)
//                
//                if let teacher = teacher {
//                    // ✅ صورة الأستاذ الشخصية
//                    if let imageData = teacher.profileimage, let image = UIImage(data: imageData) {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 120, height: 120)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(primaryColor, lineWidth: 2))
//                            .shadow(radius: 4)
//                            .padding()
//                    } else {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 120, height: 120)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    // ✅ معلومات الأستاذ
//                    VStack(alignment: .trailing, spacing: 10) {
//                        InfoRow(title: "الاسم:", value: teacher.name ?? "غير معروف")
//                        InfoRow(title: "تاريخ الميلاد:", value: teacher.birthDay?.formatted(date: .long, time: .omitted) ?? "غير مدخل")
//                        InfoRow(title: "رقم الهاتف:", value: teacher.phonenumber)
//                        InfoRow(title: "اسم المسجد:", value: teacher.mosquname ?? "غير مدخل")
//                        InfoRow(title: "المستوى الأكاديمي:", value: teacher.academiclevel ?? "غير مدخل")
//                        InfoRow(title: "الوظيفة الحالية:", value: teacher.currentWork ?? "غير مدخلة")
//                        InfoRow(title: "هل قام بالتدريس:", value: teacher.didyoutaught ? "نعم" : "لا")
//                    }
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.horizontal)
//                    
//                    // ✅ عرض صور الهوية أفقيًا
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            if let frontData = teacher.frontfaceidentity, let frontImage = UIImage(data: frontData) {
//                                IDImageView(image: frontImage, title: "الوجه الأمامي")
//                            }
//                            if let backData = teacher.backfaceidentity, let backImage = UIImage(data: backData) {
//                                IDImageView(image: backImage, title: "الوجه الخلفي")
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .padding(.vertical)
//                    
//                } else {
//                    Text("لم يتم العثور على بيانات للأستاذ.")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(backgroundColorPage)
//            .environment(\.layoutDirection, .rightToLeft) // 🔹 تفعيل RTL
//        }
//        .onAppear {
//            vmTeacher.fetchTeacherInfo()
//        }
//    }
//}
//
//// ✅ مكون لإظهار المعلومات
//struct InfoRow: View {
//    let title: String
//    let value: String?
//
//    var body: some View {
//        HStack {
//            Text(title)
//                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
//                .foregroundColor(primaryColor)
//            
//            Spacer()
//            
//            Text(value ?? "غير متوفر")
//                .foregroundColor(.black)
//                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
//        }
//        .padding(.horizontal)
//    }
//}
//
//// ✅ مكون لعرض صور الهوية بشكل أفقي
//import SwiftUI
//
//struct IDImageView: View {
//    let image: UIImage
//    let title: String
//
//    var rotatedImage: UIImage {
//        if image.size.height > image.size.width {
//            return image.rotated(by: 90) ?? image // تدوير 90 درجة إذا كانت الصورة عمودية
//        }
//        return image
//    }
//
//    var body: some View {
//        VStack {
//            Image(uiImage: rotatedImage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 160, height: 120) // 📌 عرضها بشكل أفقي دائمًا
//                .cornerRadius(10)
//                .shadow(radius: 5)
//
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//}
//
//import UIKit
//
//extension UIImage {
//    func rotated(by degrees: CGFloat) -> UIImage? {
//        let radians = degrees * .pi / 180
//        var newSize = CGRect(origin: .zero, size: self.size)
//            .applying(CGAffineTransform(rotationAngle: radians))
//            .integral.size
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//
//        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
//        context.rotate(by: radians)
//        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
//
//        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return rotatedImage
//    }
//}
//
//
//#Preview {
//    TeacherProfileView()
//}














//import SwiftUI
//
//struct TeacherProfileView: View {
//    @StateObject var vmTeacher = CoreDataViewModel.shared
//    @State private var showDeleteConfirmation = false
//
//    var teacher: TeacherInfo? {
//        return vmTeacher.savedEntitiesTeacher.first
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 15) {
//                
//                Text("الملف الشخصي للأستاذ")
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
//                    .foregroundStyle(.white)
//                    .frame(width: screenWidth * 0.85)
//                    .frame(height: screenHeight * 0.04)
//                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
//                    .cornerRadius(5)
//                
//                if let teacher = teacher {
//                    // ✅ صورة الأستاذ الشخصية
//                    if let imageData = teacher.profileimage, let image = UIImage(data: imageData) {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 120, height: 120)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
//                            .padding()
//                    } else {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 120, height: 120)
//                            .foregroundColor(.gray)
//                    }
//
//                    // ✅ معلومات الأستاذ مع تنسيق RTL
//                    VStack(alignment: .trailing, spacing: 10) {
//                        InfoRow(title: "الاسم:", value: teacher.name ?? "غير معروف")
//                        InfoRow(title: "تاريخ الميلاد:", value: teacher.birthDay?.formatted(date: .long, time: .omitted) ?? "غير مدخل")
//                        InfoRow(title: "رقم الهاتف:", value: teacher.phonenumber)
////                        InfoRow(title: "المحافظة:", value: teacher.province ?? "غير مدخلة")
////                        InfoRow(title: "المدينة:", value: teacher.city ?? "غير مدخلة")
//                        InfoRow(title: "اسم المسجد:", value: teacher.mosquname ?? "غير مدخل")
//                        InfoRow(title: "المستوى الأكاديمي:", value: teacher.academiclevel ?? "غير مدخل")
//                        InfoRow(title: "الوظيفة الحالية:", value: teacher.currentWork ?? "غير مدخلة")
//                        InfoRow(title: "هل قام بالتدريس:", value: teacher.didyoutaught ? "نعم" : "لا")
//                    }
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.horizontal)
//
//                    // ✅ عرض صور الهوية
//                    HStack(spacing: 20) {
//                        if let frontData = teacher.frontfaceidentity, let frontImage = UIImage(data: frontData) {
//                            IDImageView(image: frontImage, title: "الوجه الأمامي")
//                        }
//                        if let backData = teacher.backfaceidentity, let backImage = UIImage(data: backData) {
//                            IDImageView(image: backImage, title: "الوجه الخلفي")
//                        }
//                    }
//
//                    // ✅ زر حذف البيانات
////                    Button(action: {
////                        showDeleteConfirmation = true
////                    }) {
////                        Text("مسح بيانات الأستاذ")
////                            .frame(maxWidth: .infinity)
////                            .padding()
////                            .background(Color.red)
////                            .foregroundColor(.white)
////                            .cornerRadius(8)
////                    }
////                    .padding(.top)
////                    .confirmationDialog("هل أنت متأكد من مسح جميع بيانات الأستاذ؟", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
////                        Button("نعم، احذف", role: .destructive) {
////                            vmTeacher.deleteAllTeacherInfo()
////                        }
////                        Button("إلغاء", role: .cancel) { }
////                    }
//                } else {
//                    Text("لم يتم العثور على بيانات للأستاذ.")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
//            .environment(\.layoutDirection, .rightToLeft) // 🔹 تفعيل RTL في الواجهة
//        }
//        .onAppear {
//            vmTeacher.fetchTeacherInfo()
//        }
//    }
//}
//
//// ✅ مكون لإظهار كل معلومة في صف مع محاذاة لليمين
//struct InfoRow: View {
//    let title: String
//    let value: String?
//
//    var body: some View {
//        HStack {
//            
//            
//            
//            Text(title)
//                .fontWeight(.bold)
//                .foregroundColor(.blue)
//                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//                .foregroundStyle(.white)
//  
//            
//            Text(value ?? "غير متوفر")
//                .foregroundColor(.black)
//                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//                .foregroundStyle(.white)
//    
//            Spacer()
//            
//            
//        }
//        .padding(.horizontal)
//    }
//}
//
//
//// ✅ مكون لعرض صور الهوية
//struct IDImageView: View {
//    let image: UIImage
//    let title: String
//
//    var body: some View {
//        VStack {
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 120)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//}
//
//#Preview {
//    TeacherProfileView()
//}

























//import SwiftUI
//
//struct TeacherProfileView: View {
//    @StateObject var vmTeacher = CoreDataViewModel()
//    @State private var showDeleteConfirmation = false
//
//    var teacher: TeacherInfo? {
//        return vmTeacher.savedEntitiesTeacher.first
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 15) {
//                if let teacher = teacher {
//                    // ✅ صورة الأستاذ الشخصية
//                    if let imageData = teacher.profileimage, let image = UIImage(data: imageData) {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 120, height: 120)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
//                            .padding()
//                    } else {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 120, height: 120)
//                            .foregroundColor(.gray)
//                    }
//
//                    // ✅ معلومات الأستاذ
//                    Group {
//                        InfoRow(title: "الاسم:", value: teacher.name ?? "غير معروف")
//                        InfoRow(title: "تاريخ الميلاد:", value: teacher.birthDay?.formatted(date: .long, time: .omitted) ?? "غير مدخل")
//                        InfoRow(title: "رقم الهاتف:", value: "\(teacher.phonenumber)")
//                        InfoRow(title: "المحافظة:", value: teacher.province ?? "غير مدخلة")
//                        InfoRow(title: "المدينة:", value: teacher.city ?? "غير مدخلة")
//                        InfoRow(title: "اسم المسجد:", value: teacher.mosquname ?? "غير مدخل")
//                        InfoRow(title: "المستوى الأكاديمي:", value: teacher.academiclevel ?? "غير مدخل")
//                        InfoRow(title: "الوظيفة الحالية:", value: teacher.currentWork ?? "غير مدخلة")
//                        InfoRow(title: "هل قام بالتدريس:", value: teacher.didyoutaught ? "نعم" : "لا")
//                    }
//
//                    // ✅ عرض صور الهوية
//                    HStack(spacing: 20) {
//                        if let frontData = teacher.frontfaceidentity, let frontImage = UIImage(data: frontData) {
//                            IDImageView(image: frontImage, title: "الوجه الأمامي")
//                        }
//                        if let backData = teacher.backfaceidentity, let backImage = UIImage(data: backData) {
//                            IDImageView(image: backImage, title: "الوجه الخلفي")
//                        }
//                    }
//
//                    // ✅ زر حذف البيانات
//                    Button(action: {
//                        showDeleteConfirmation = true
//                    }) {
//                        Text("مسح بيانات الأستاذ")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding(.top)
//                    .confirmationDialog("هل أنت متأكد من مسح جميع بيانات الأستاذ؟", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
//                        Button("نعم، احذف", role: .destructive) {
//                            vmTeacher.deleteAllTeacherInfo()
//                        }
//                        Button("إلغاء", role: .cancel) { }
//                    }
//                } else {
//                    Text("لم يتم العثور على بيانات للأستاذ.")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }
//            .padding()
//            .navigationTitle("بيانات الأستاذ")
//        }
//        .onAppear {
//            vmTeacher.fetchTeacherInfo()
//        }
//    }
//}
//
//// ✅ مكون لإظهار كل معلومة في صف منظم
//struct InfoRow: View {
//    let title: String
//    let value: String
//
//    var body: some View {
//        HStack {
//            Text(title)
//                .fontWeight(.bold)
//                .foregroundColor(.blue)
//            Spacer()
//            Text(value)
//                .foregroundColor(.black)
//        }
//        .padding(.horizontal)
//    }
//}
//
//// ✅ مكون لعرض صور الهوية
//struct IDImageView: View {
//    let image: UIImage
//    let title: String
//
//    var body: some View {
//        VStack {
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 120)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//}
//
//#Preview {
//    TeacherProfileView()
//}













//struct TeacherInfoView: View {
//    @StateObject var viewModel = CoreDataViewModel()
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                LazyVStack {
//                    ForEach(viewModel.savedEntitiesTeacher, id: \.self) { teacher in
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text("Name: \(teacher.name ?? "Unknown")")
//                                .font(.headline)
//                            
//                            if let birthDay = teacher.birthDay {
//                                Text("Birthday: \(formatDate(birthDay))")
//                                    .font(.subheadline)
//                            } else {
//                                Text("Birthday: Unknown")
//                            }
//
//                            Text("Province: \(teacher.province ?? "Unknown")")
//                            Text("City: \(teacher.city ?? "Unknown")")
//                            Text("Taught: \(teacher.didyoutaught )")
//                            Text("Mosque Name: \(teacher.mosquname ?? "Unknown")")
//                            Text("Academic Level: \(teacher.academiclevel ?? "Unknown")")
//                            Text("Current Work: \(teacher.currentWork ?? "Unknown")")
//                            Text("Teacher ID: \(teacher.teacherID ?? "N/A")")
//
//                            // Display profile image
//                            if let imageData = teacher.profileimage, let uiImage = UIImage(data: imageData) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 200)
//                                    .cornerRadius(10)
//                            } else {
//                                Text("No Profile Image")
//                                    .foregroundColor(.gray)
//                            }
//
//                            // Display front ID image
//                            if let frontIdData = teacher.frontfaceidentity, let frontIdImage = UIImage(data: frontIdData) {
//                                Text("Front ID:")
//                                Image(uiImage: frontIdImage)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 150)
//                                    .cornerRadius(10)
//                            } else {
//                                Text("No Front ID Image")
//                                    .foregroundColor(.gray)
//                            }
//
//                            // Display back ID image
//                            if let backIdData = teacher.backfaceidentity, let backIdImage = UIImage(data: backIdData) {
//                                Text("Back ID:")
//                                Image(uiImage: backIdImage)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 150)
//                                    .cornerRadius(10)
//                            } else {
//                                Text("No Back ID Image")
//                                    .foregroundColor(.gray)
//                            }
//
//                            Divider()
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .navigationTitle("Teachers Info")
//        }
//        .onAppear {
//            viewModel.fetchTeacherInfo()
//        }
//    }
//
//    // Helper function to format the date
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter.string(from: date)
//    }
//}
