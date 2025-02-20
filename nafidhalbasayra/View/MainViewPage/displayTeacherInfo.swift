import SwiftUI

struct TeacherProfileView: View {
    @StateObject var vmTeacher = CoreDataViewModel()
    @State private var showDeleteConfirmation = false

    var teacher: TeacherInfo? {
        return vmTeacher.savedEntitiesTeacher.first
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                if let teacher = teacher {
                    // ✅ صورة الأستاذ الشخصية
                    if let imageData = teacher.profileimage, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            .padding()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }

                    // ✅ معلومات الأستاذ
                    Group {
                        InfoRow(title: "الاسم:", value: teacher.name ?? "غير معروف")
                        InfoRow(title: "تاريخ الميلاد:", value: teacher.birthDay?.formatted(date: .long, time: .omitted) ?? "غير مدخل")
                        InfoRow(title: "رقم الهاتف:", value: "\(teacher.phonenumber)")
                        InfoRow(title: "المحافظة:", value: teacher.province ?? "غير مدخلة")
                        InfoRow(title: "المدينة:", value: teacher.city ?? "غير مدخلة")
                        InfoRow(title: "اسم المسجد:", value: teacher.mosquname ?? "غير مدخل")
                        InfoRow(title: "المستوى الأكاديمي:", value: teacher.academiclevel ?? "غير مدخل")
                        InfoRow(title: "الوظيفة الحالية:", value: teacher.currentWork ?? "غير مدخلة")
                        InfoRow(title: "هل قام بالتدريس:", value: teacher.didyoutaught ? "نعم" : "لا")
                    }

                    // ✅ عرض صور الهوية
                    HStack(spacing: 20) {
                        if let frontData = teacher.frontfaceidentity, let frontImage = UIImage(data: frontData) {
                            IDImageView(image: frontImage, title: "الوجه الأمامي")
                        }
                        if let backData = teacher.backfaceidentity, let backImage = UIImage(data: backData) {
                            IDImageView(image: backImage, title: "الوجه الخلفي")
                        }
                    }

                    // ✅ زر حذف البيانات
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Text("مسح بيانات الأستاذ")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                    .confirmationDialog("هل أنت متأكد من مسح جميع بيانات الأستاذ؟", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                        Button("نعم، احذف", role: .destructive) {
                            vmTeacher.deleteAllTeacherInfo()
                        }
                        Button("إلغاء", role: .cancel) { }
                    }
                } else {
                    Text("لم يتم العثور على بيانات للأستاذ.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("بيانات الأستاذ")
        }
        .onAppear {
            vmTeacher.fetchTeacherInfo()
        }
    }
}

// ✅ مكون لإظهار كل معلومة في صف منظم
struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Spacer()
            Text(value)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}

// ✅ مكون لعرض صور الهوية
struct IDImageView: View {
    let image: UIImage
    let title: String

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 120)
                .cornerRadius(10)
                .shadow(radius: 5)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    TeacherProfileView()
}













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
