import SwiftUI

struct TeacherInfoView: View {
    @StateObject var viewModel = CoreDataViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.savedEntities, id: \.self) { teacher in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(teacher.name ?? "Unknown")")
                                .font(.headline)
                            
                            if let birthDay = teacher.birthDay {
                                Text("Birthday: \(formatDate(birthDay))")
                                    .font(.subheadline)
                            } else {
                                Text("Birthday: Unknown")
                            }

                            Text("Province: \(teacher.province ?? "Unknown")")
                            Text("City: \(teacher.city ?? "Unknown")")
                            Text("Taught: \(teacher.didyoutaught )")
                            Text("Mosque Name: \(teacher.mosquname ?? "Unknown")")
                            Text("Academic Level: \(teacher.academiclevel ?? "Unknown")")
                            Text("Current Work: \(teacher.currentWork ?? "Unknown")")
                            Text("Teacher ID: \(teacher.teacherID ?? "N/A")")

                            // Display profile image
                            if let imageData = teacher.profileimage, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            } else {
                                Text("No Profile Image")
                                    .foregroundColor(.gray)
                            }

                            // Display front ID image
                            if let frontIdData = teacher.frontfaceidentity, let frontIdImage = UIImage(data: frontIdData) {
                                Text("Front ID:")
                                Image(uiImage: frontIdImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                            } else {
                                Text("No Front ID Image")
                                    .foregroundColor(.gray)
                            }

                            // Display back ID image
                            if let backIdData = teacher.backfaceidentity, let backIdImage = UIImage(data: backIdData) {
                                Text("Back ID:")
                                Image(uiImage: backIdImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                            } else {
                                Text("No Back ID Image")
                                    .foregroundColor(.gray)
                            }

                            Divider()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Teachers Info")
        }
        .onAppear {
            viewModel.fetchTeacherInfo()
        }
    }

    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
