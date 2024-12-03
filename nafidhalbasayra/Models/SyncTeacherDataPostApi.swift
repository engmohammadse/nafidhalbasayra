//
//  sendDataIfConnected.swift
//  nafidhalbasayra
//
//  Created by muhammad on 28/11/2024.
//
//import Foundation
//import Network
//import CoreData
//
//class SyncTeacherDataPostApi {
//    static let shared = SyncTeacherDataPostApi()
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "NetworkMonitor")
//
//    private var coreDataViewModel: CoreDataViewModel?
//
//    private init() {}
//
//    func startMonitoring(coreDataViewModel: CoreDataViewModel) {
//        self.coreDataViewModel = coreDataViewModel
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                DispatchQueue.main.async {
//                    self.sendDataIfConnected()
//                }
//            }
//        }
//        monitor.start(queue: queue)
//    }
//
//    private func sendDataIfConnected() {
//        guard let context = coreDataViewModel?.container.viewContext else { return }
//
//        let fetchRequest: NSFetchRequest<TeacherInfo> = TeacherInfo.fetchRequest()
//
//        do {
//            let teachers = try context.fetch(fetchRequest)
//            for teacher in teachers {
//                sendTeacherData(teacher: teacher, context: context)
//            }
//        } catch {
//            print("Failed to fetch teachers: \(error.localizedDescription)")
//        }
//    }
//
//    private func sendTeacherData(teacher: TeacherInfo, context: NSManagedObjectContext) {
//        guard let url = URL(string: "http://198.244.227.48:8082/teachers/register-teacher") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Date Formatter
//        let dateFormatter = ISO8601DateFormatter()
//        dateFormatter.formatOptions = [.withFullDate]
//
//        // Format birth_date or use an empty string if nil
//        let formattedDate = teacher.birthDay != nil ? dateFormatter.string(from: teacher.birthDay!) : ""
//
//        let body: [String: Any] = [
//            "teacher_id": teacher.teacherID ?? "",
//            "region_id": teacher.province ?? "",
//            "governorate_id": teacher.city ?? "",
//            "full_name": teacher.name ?? "",
//            "gender": "male",
//            "birth_date": formattedDate, // Use the formatted date here
//            "phone_number": teacher.phonenumber ?? "",
//            "work": teacher.currentWork ?? "",
//            "mosque_name": teacher.mosquname ?? "",
//            "degree": teacher.academiclevel ?? "",
//            "previous_teacher": teacher.didyoutaught ?? false,
//            "image_1": teacher.frontfaceidentity?.base64EncodedString() ?? "",
//            "image_2": teacher.backfaceidentity?.base64EncodedString() ?? "",
//            "image_3": teacher.profileimage?.base64EncodedString() ?? ""
//        ]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
//        } catch {
//            print("Failed to serialize body: \(error.localizedDescription)")
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Failed to send data: \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                print("Data sent successfully for teacher: \(teacher.name ?? "Unknown")")
//                self.deleteTeacher(teacher, context: context)
//            } else {
//                print("Failed to send data. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
//            }
//        }
//        task.resume()
//    }
//
//
//    private func deleteTeacher(_ teacher: TeacherInfo, context: NSManagedObjectContext) {
//        context.delete(teacher)
//
//        do {
//            try context.save()
//            print("Teacher deleted successfully from Core Data.")
//        } catch {
//            print("Failed to delete teacher: \(error.localizedDescription)")
//        }
//    }
//}
