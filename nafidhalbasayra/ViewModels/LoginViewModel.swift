//
//  LoginViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//new



import SwiftUI
import Network

enum PageType: Hashable {
    case registerInfo
    case waitProcess
    case homePage
    case rejectionIssue
}

class LoginViewModel: ObservableObject {
    @StateObject var studentFetcher = fetchAndStoreStudentsFromBackEnd(database: StudentViewModel.shared)
    @StateObject var attendanceFetcher = fetchAndStoreAttendancesFromBackEnd(database: AttendaceStatusViewModel.shared)
    
    @Published var username = ""
    @Published var password = ""
    @Published var loginError: String?
    @Published var isLoggedIn = false
    @Published var responseMessage = ""
    @Published var isConnectedToInternet = true
    @Published var navigateToNextPage = false
    @Published var isLoading = false
    @Published var nextPage: PageType?
    
    private var apiService = ApiService()
    
    // دالة تسجيل الدخول
    func login() {
        checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnectedToInternet = isConnected
                if isConnected {
                    self.performLoginAttempt()
                } else {
                    self.isLoading = false
                    self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
                }
            }
        }
    }
    
    // التحقق من الاتصال بالإنترنت
    private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.google.com") else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 10
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // محاولة تسجيل الدخول بدون تغيير isLoading بعد الاستجابة مباشرةً
    private func performLoginAttempt() {
        self.isLoading = true
        apiService.login(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.handleSuccessfulLogin(response)
                case .failure(let error):
                    self.handleLoginFailure(error: error)
                    self.isLoading = false
                }
            }
        }
    }
    
    // التعامل مع تسجيل الدخول الناجح
    private func handleSuccessfulLogin(_ response: LoginResponse) {
        self.isLoggedIn = true
        self.loginError = nil
        self.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
        

        
        let defaults = UserDefaults.standard
        defaults.set(response.data?.rejectionReason, forKey: "rejectionReason")
        
        let teacherId = "\(response.id)"
        defaults.set(teacherId, forKey: "teacherId")
        
        if let username = response.data?.username {
            defaults.set(username, forKey: "username")
           // print("✅ تم حفظ اسم المستخدم في UserDefaults: \(username)")
        }
        
        defaults.removeObject(forKey: "governorate_id")
        
        // تحديد الصفحة بناءً على حالة الاستجابة
        switch response.state {
        case 0:
            self.nextPage = .registerInfo
            defaults.set(0, forKey: "loginState")
            // في الحالات الأخرى ننهي التحميل مباشرةً
            self.isLoading = false
            self.navigateToNextPage = true
        case 1:
            self.nextPage = .waitProcess
            defaults.set(1, forKey: "loginState")
            self.isLoading = false
            self.navigateToNextPage = true
        case 2:
            self.nextPage = .homePage
            // في حالة 2، ننتظر تحميل البيانات والصور بالكامل
            let group = DispatchGroup()
            
            // حفظ بيانات الأستاذ في Core Data
            let coreDataVM = CoreDataViewModel.shared
            coreDataVM.saveTeacherInfo(from: response)
            
          
          
          
            
            // تحميل الصورة إن وُجدت، وفي حال تحميلها بنجاح يبدأ بعدها جلب بيانات الحضور والطلاب
            if let imageUrl = response.data?.image_1, !imageUrl.isEmpty  {
                group.enter()  // بدء مهمة تحميل الصورة
                let fullImageUrl = "http://198.244.227.48:8082\(imageUrl)"
                downloadAndSaveImage(imageUrl: fullImageUrl, group: group) { success in                    // داخل الـ closure الخاص بتحميل الصورة
                    
                    if success {

                        // بدء جلب بيانات الحضور
                        group.enter()
                        Task {
                            await self.attendanceFetcher.fetchAndStoreAttendances(teacherID: defaults.string(forKey: "teacherId") ?? teacherId)
                            group.leave()
                        }
                        
                        // بدء جلب بيانات الطلاب
                        group.enter()
                        Task {
                            await self.studentFetcher.fetchAndStoreStudents(teacherID: defaults.string(forKey: "teacherId") ?? teacherId)
                            group.leave()
                        }
                        
                        defaults.set(response.data?.governorate_id, forKey: "governorate_id")
                        
                        // سيتم استدعاء هذا الـ notify بعد انتهاء جميع المهام (تحميل الصورة وجلب الحضور والطلاب)
                        group.notify(queue: .main) {
                            self.isLoading = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                defaults.set(2, forKey: "loginState")
                                
                              
                                self.navigateToNextPage = true
                                
                                // القيم التي سيتم إرسالها
                                let teacherId = UserDefaults.standard.string(forKey: "teacherId") ?? ""
                                let token = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
                                let governorateId = UserDefaults.standard.string(forKey: "governorate_id") ?? ""
                                let type = 1
                                
                                // إرسال البيانات
                                group.enter()
                                Task {
                                       await TokenCreateApi.shared.createToken(teacherId: teacherId, token: token, governorateId: governorateId, type: type)
                                       group.leave()
                                   }
                                
                                
                            }
   
                                 
                          }
                        
                        group.leave() // إنهاء مهمة تحميل الصورة الخارجية
                        
                    } else {
                        
                        self.isLoading = false
                        self.navigateToNextPage = false
                        
                        
                        group.leave()
                        
                    }
                    
                  
                }
                   
            }

            
          
        case 3:
            self.nextPage = .rejectionIssue
            defaults.set(3, forKey: "loginState")
            self.isLoading = false
            self.navigateToNextPage = true
        default:
            self.loginError = "حالة غير معروفة: \(response.state)"
            self.nextPage = nil
            self.isLoading = false
            defaults.set(0, forKey: "loginState")
        }
        
      //  print("✅ تم تخزين معرف الأستاذ في قاعدة البيانات.")
    }
    
    // التعامل مع تسجيل الدخول الفاشل
    private func handleLoginFailure(error: Error) {
        self.isLoggedIn = false
        if !isConnectedToInternet {
            self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
        } else {
            self.loginError = error.localizedDescription
        }
        self.responseMessage = ""
    }
}

// دالة تحميل الصورة مع Completion handler (تظل تعمل حتى في حالة بطء الاتصال)

func downloadAndSaveImage(imageUrl: String, group: DispatchGroup, completion: @escaping (Bool) -> Void) {
    group.enter()
    guard let url = URL(string: imageUrl) else {
        group.leave()
        completion(false)
        return
    }
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        defer { group.leave() }
        if let data = data, let image = UIImage(data: data) {
            if let savedPath = saveImageToFileManager(image: image) {
                UserDefaults.standard.set(savedPath, forKey: "profileImagePath")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("ProfileImageUpdated"), object: nil)
                }
            }
            completion(true)
        } else {
            // محاولة استخراج رسالة الخطأ من بيانات الاستجابة
            let serverError: String
            if let data = data,
               let errorDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = errorDict["message"] as? String {
                serverError = message
            } else {
                serverError = error?.localizedDescription ?? "خطأ غير معروف"
            }
            let combinedError = "حدث خطأ أثناء تحميل بيانات الاستاذ من السيرفر\n\(serverError)"
            UserDefaults.standard.set(combinedError, forKey: "imageDownloadError")
            //print("❌ فشل تحميل الصورة: \(combinedError)")
            completion(false)
        }
    }
    task.resume()
}





func saveImageToFileManager(image: UIImage) -> String? {
    let fileManager = FileManager.default
    guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let filePath = directory.appendingPathComponent("profile_image.jpg")
    if let data = image.jpegData(compressionQuality: 0.8) {
        do {
            try data.write(to: filePath)
            return filePath.path
        } catch {
           // print("❌ فشل حفظ الصورة محليًا: \(error.localizedDescription)")
        }
    }
    return nil
}

func getSavedProfileImage() -> UIImage? {
    if let savedPath = UserDefaults.standard.string(forKey: "profileImagePath") {
        return UIImage(contentsOfFile: savedPath)
    }
    return nil
}

func deleteProfileImage() {
    let fileManager = FileManager.default
    if let savedPath = UserDefaults.standard.string(forKey: "profileImagePath") {
        let fileURL = URL(fileURLWithPath: savedPath)
        do {
            try fileManager.removeItem(at: fileURL)
           // print("✅ تم حذف الصورة بنجاح من FileManager.")
        } catch {
           // print("❌ فشل في حذف الصورة: \(error.localizedDescription)")
        }
    }
}















