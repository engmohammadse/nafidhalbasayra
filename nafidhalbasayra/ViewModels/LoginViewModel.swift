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
                        // سيتم استدعاء هذا الـ notify بعد انتهاء جميع المهام (تحميل الصورة وجلب الحضور والطلاب)
                        group.notify(queue: .main) {
                            self.isLoading = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                defaults.set(2, forKey: "loginState")
                                
                                defaults.set(response.data?.governorate_id, forKey: "governorate_id")
                                
                                
                                
                                self.navigateToNextPage = true
                                
                                
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
            print("❌ فشل تحميل الصورة: \(combinedError)")
            completion(false)
        }
    }
    task.resume()
}


//func downloadAndSaveImage(imageUrl: String, group: DispatchGroup, completion: @escaping (Bool) -> Void) {
//    group.enter()
//    guard let url = URL(string: imageUrl) else {
//        group.leave()
//        completion(false)
//        return
//    }
//    let task = URLSession.shared.dataTask(with: url) { data, _, error in
//        defer { group.leave() }
//        if let data = data, let image = UIImage(data: data) {
//            if let savedPath = saveImageToFileManager(image: image) {
//                UserDefaults.standard.set(savedPath, forKey: "profileImagePath")
//                DispatchQueue.main.async {
//                    NotificationCenter.default.post(name: NSNotification.Name("ProfileImageUpdated"), object: nil)
//                }
//            }
//            completion(true)
//        } else {
//            // الحصول على رسالة الخطأ من السيرفر أو رسالة افتراضية
//            let serverError = error?.localizedDescription ?? "خطأ غير معروف"
//            let combinedError = "حدث خطأ أثناء تحميل بيانات الاستاذ من السيرفر\n\(serverError)"
//            UserDefaults.standard.set(combinedError, forKey: "imageDownloadError")
//           // print("❌ فشل تحميل الصورة: \(combinedError)")
//            completion(false)
//        }
//    }
//    task.resume()
//}




func saveImageToFileManager(image: UIImage) -> String? {
    let fileManager = FileManager.default
    guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let filePath = directory.appendingPathComponent("profile_image.jpg")
    if let data = image.jpegData(compressionQuality: 0.8) {
        do {
            try data.write(to: filePath)
            return filePath.path
        } catch {
            print("❌ فشل حفظ الصورة محليًا: \(error.localizedDescription)")
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
            print("✅ تم حذف الصورة بنجاح من FileManager.")
        } catch {
            print("❌ فشل في حذف الصورة: \(error.localizedDescription)")
        }
    }
}



















//import SwiftUI
//import Network
//
//
//
//enum PageType: Hashable {
//    case registerInfo
//    case waitProcess
//    case homePage
//    case rejectionIssue
//}
//
//
//class LoginViewModel: ObservableObject {
//   // private var vmTeacherFromApi = TeacherDataFromApiViewModel() // تعريف محلي لـ TeacherDataFromApiViewModel
//    
//    @StateObject var studentFetcher = fetchAndStoreStudentsFromBackEnd(database: StudentViewModel.shared)
//    @StateObject var attendanceFetcher = fetchAndStoreAttendancesFromBackEnd(database: AttendaceStatusViewModel.shared)
//    
//    @Published var username = ""
//    @Published var password = ""
//    @Published var loginError: String?
//    @Published var isLoggedIn = false
//    @Published var responseMessage = ""
//    @Published var isConnectedToInternet = true
//    @Published var navigateToNextPage = false
//    @Published var isLoading = false
//    @Published var nextPage: PageType?
//
//    private var apiService = ApiService()
//
//    // تعريف أنواع الصفحات بناءً على الحالة
//   
//
//    // دالة تسجيل الدخول
//    func login() {
//        checkInternetConnection { [weak self] isConnected in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.isConnectedToInternet = isConnected
//                if isConnected {
//                    self.performLoginAttempt()
//                } else {
//                    self.isLoading = false
//                    self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//                }
//            }
//        }
//    }
//
//    // التحقق من الاتصال بالإنترنت
//    private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        request.timeoutInterval = 10
//
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    // محاولة تسجيل الدخول
//    private func performLoginAttempt() {
//        self.isLoading = true
//        apiService.login(username: username, password: password) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.isLoading = false
//
//                switch result {
//                case .success(let response):
//                    self.handleSuccessfulLogin(response)
//                case .failure(let error):
//                    self.handleLoginFailure(error: error)
//                }
//            }
//        }
//    }
//
//    // التعامل مع تسجيل الدخول الناجح
//    private func handleSuccessfulLogin(_ response: LoginResponse) {
//        self.isLoggedIn = true
//        self.loginError = nil
//        
//        
//        // تحديث الرسالة لعرضها للمستخدم
//         self.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
//        
//  
//        //  حفظ بيانات الأستاذ في Core Data
//        let coreDataVM = CoreDataViewModel.shared
//            coreDataVM.saveTeacherInfo(from: response)
//        //
//        
//        let defaults = UserDefaults.standard
//        let teacherId = "\(response.id)"
//
//        
//        // ✅ حفظ معرف المعلم
//
//        defaults.set(teacherId, forKey: "teacherId")
//        defaults.set(response.data?.rejectionReason, forKey: "rejectionReason")
//        
//        
//        // ✅ حفظ اسم المستخدم إذا كان متاحًا
//        if let username = response.data?.username {
//            defaults.set(username, forKey: "username")
//            print("✅ تم حفظ اسم المستخدم في UserDefaults: \(username)")
//        }
//        
//        // ✅ حفظ رابط الصورة وتنزيلها محليًا
//          if let imageUrl = response.data?.image_1 {
//              let fullImageUrl = "http://198.244.227.48:8082\(imageUrl)" // 🔗 تحويل الرابط النسبي إلى مطلق
//              downloadAndSaveImage(imageUrl: fullImageUrl)
//          }
//
//        
//        
//        // تخزين معرف المعلم
//            
//         print("✅ تم تخزين معرف الأستاذ في قاعدة البيانات.")
//         print("\(response.id)")
//
//
//        // تحديد الصفحة بناءً على الحالة
//        switch response.state {
//        case 0:
//            self.nextPage = .registerInfo
//            let loginState = 0
//            defaults.set(loginState, forKey: "loginState")
//        case 1:
//            self.nextPage = .waitProcess
//            let loginState = 1
//            defaults.set(loginState, forKey: "loginState")
//        case 2:
//            self.nextPage = .homePage
//            let loginState = 2
//            defaults.set(loginState, forKey: "loginState")
//            
//            Task {
//                               await attendanceFetcher.fetchAndStoreAttendances(teacherID: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7")
//                           }
//            
//            Task {
//                       await studentFetcher.fetchAndStoreStudents(teacherID: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7") // 🔹 جلب الطلاب عند إعادة فتح التطبيق
//                   }
//            
//        case 3:
//            self.nextPage = .rejectionIssue
//            let loginState = 3
//            defaults.set(loginState, forKey: "loginState")
//        default:
//            self.loginError = "حالة غير معروفة: \(response.state)"
//            self.nextPage = nil
//        }
//
//        // تفعيل التنقل إذا كانت الحالة معروفة
//        if self.nextPage != nil {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.navigateToNextPage = true
//            }
//        }
//    }
//
//    // التعامل مع تسجيل الدخول الفاشل
//    private func handleLoginFailure(error: Error) {
//        self.isLoggedIn = false
//        if !isConnectedToInternet {
//            self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//        } else {
//            self.loginError = error.localizedDescription
//        }
//        self.responseMessage = ""
//    }
//}
//
//
//
//// save profile image after login from backend
//
//func downloadAndSaveImage(imageUrl: String) {
//    guard let url = URL(string: imageUrl) else { return }
//
//    let task = URLSession.shared.dataTask(with: url) { data, _, error in
//        guard let data = data, let image = UIImage(data: data) else { return }
//
//        if let savedPath = saveImageToFileManager(image: image) {
//            UserDefaults.standard.set(savedPath, forKey: "profileImagePath")
//            
//            // ✅ إرسال إشعار عند تحديث الصورة
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: NSNotification.Name("ProfileImageUpdated"), object: nil)
//            }
//        }
//    }
//    task.resume()
//}
//
//
//func saveImageToFileManager(image: UIImage) -> String? {
//    let fileManager = FileManager.default
//    guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
//    
//    let filePath = directory.appendingPathComponent("profile_image.jpg") // 🖼️ حفظ باسم ثابت
//    if let data = image.jpegData(compressionQuality: 0.8) {
//        do {
//            try data.write(to: filePath)
//            return filePath.path
//        } catch {
//            print("❌ فشل حفظ الصورة محليًا: \(error.localizedDescription)")
//        }
//    }
//    return nil
//}
//
//
//func getSavedProfileImage() -> UIImage? {
//    if let savedPath = UserDefaults.standard.string(forKey: "profileImagePath") {
//        return UIImage(contentsOfFile: savedPath)
//    }
//    return nil
//}
//
//func deleteProfileImage() {
//    let fileManager = FileManager.default
//    if let savedPath = UserDefaults.standard.string(forKey: "profileImagePath") {
//        let fileURL = URL(fileURLWithPath: savedPath)
//        
//        do {
//            try fileManager.removeItem(at: fileURL)
//            print("✅ تم حذف الصورة بنجاح من FileManager.")
//        } catch {
//            print("❌ فشل في حذف الصورة: \(error.localizedDescription)")
//        }
//    }
//}
//























//old work
//import SwiftUI
//import Network
//
//class LoginViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var password = ""
//    @Published var loginError: String?
//    @Published var isLoggedIn = false
//    @Published var responseMessage = ""
//    @Published var isConnectedToInternet = true
//    @Published var navigateToNextPage = false
//    @Published var isLoading = false // حالة التحميل
//    
//
//
//    private var apiService = ApiService()
//
//    // تسجيل الدخول
//    func login() {
//        checkInternetConnection { [weak self] isConnected in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                
//
//                self.isConnectedToInternet = isConnected
//                if isConnected {
//                    self.performLoginAttempt()
//                } else {
//                    self.isLoading = false // إيقاف التحميل عند الخطأ
//
//                    self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//                }
//            }
//        }
//    }
//
//    // التحقق من الاتصال بالإنترنت عند الحاجة فقط
//    private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        request.timeoutInterval = 10
//
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//                
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    // محاولة تسجيل الدخول
//    private func performLoginAttempt() {
//        apiService.login(username: username, password: password) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.isLoading = true
//                
//                switch result {
//                case .success(let response):
//                    if response.state == 0 {
//                        self.isLoading = false
//                        self.handleSuccessfulLogin(response)
//              
//                    } else {
//                        self.isLoading = false
//                        self.handleFailedLogin(message: response.message)
//                        
//                    }
//                case .failure(let error):
//                    self.isLoading = false
//                    self.handleLoginFailure(error: error)
//                }
//            }
//        }
//    }
//
//    // التعامل مع تسجيل الدخول الناجح
//    private func handleSuccessfulLogin(_ response: LoginResponse) {
//        self.isLoggedIn = true
//        self.isLoading = false
//        self.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
//        self.loginError = nil
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.navigateToNextPage = true
//        }
//    }
//
//    // التعامل مع تسجيل الدخول الفاشل
//    private func handleFailedLogin(message: String) {
//        self.loginError = message
//        self.responseMessage = ""
//    }
//
//    // التعامل مع فشل الاتصال أو حدوث خطأ آخر
//    private func handleLoginFailure(error: Error) {
//        if !isConnectedToInternet {
//            self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//        } else {
//            self.loginError = error.localizedDescription
//        }
//        self.responseMessage = ""
//    }
//}


















//import SwiftUI
//import Network
//
//class LoginViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var password = ""
//    @Published var loginError: String?
//    @Published var isLoggedIn = false
//    @Published var responseMessage = ""
//    @Published var isConnectedToInternet = true
//    @Published var navigateToNextPage = false
//
//    private var apiService = ApiService()
//    private var monitor: NWPathMonitor?
//
//    init() {
//        startMonitoringInternetConnection()
//    }
//
//    // دالة للتحقق من الاتصال بالإنترنت
//    private func startMonitoringInternetConnection() {
//        monitor = NWPathMonitor()
//        monitor?.pathUpdateHandler = { [weak self] path in
//            DispatchQueue.main.async {
//                if path.status == .satisfied {
//                    self?.isConnectedToInternet = true
//                    self?.login() // إذا كان الاتصال متاحًا نتابع تسجيل الدخول
//                } else {
//                    self?.isConnectedToInternet = false
//                    self?.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//                }
//            }
//        }
//        let queue = DispatchQueue(label: "InternetConnectionMonitor")
//        monitor?.start(queue: queue)
//    }
//
//    // دالة لتسجيل الدخول
//    func login() {
//        if !isConnectedToInternet {
//            // إذا لم يكن هناك اتصال بالإنترنت، لا نستطيع إتمام عملية تسجيل الدخول
//            loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//            return
//        }
//        
//        apiService.login(username: username, password: password) { [weak self] result in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    if response.state == 0 {
//                        self.isLoggedIn = true
//                        self.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
//                        self.loginError = nil
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            self.navigateToNextPage = true
//                        }
//                    } else {
//                        self.loginError = response.message // رسالة الخطأ من الخادم مباشرة
//                        self.responseMessage = ""
//                    }
//                case .failure(let error):
//                    self.loginError = error.localizedDescription // إظهار الخطأ إذا فشل الـ API
//                    self.responseMessage = ""
//                }
//            }
//        }
//    }
//
//    // إيقاف مراقبة الاتصال بالإنترنت عند تدمير الـ ViewModel
//    deinit {
//        monitor?.cancel()
//    }
//}






//
//import SwiftUI
//import Network
//
//class LoginViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var password = ""
//    @Published var loginError: String?
//    @Published var isLoggedIn = false
//    @Published var responseMessage = ""
//    @Published var isConnectedToInternet = true
//    @Published var navigateToNextPage = false
//
//    private var apiService = ApiService()
//
//    // دالة لتسجيل الدخول
//    func login() {
//        checkInternetConnection { [weak self] isConnected in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                self.isConnectedToInternet = isConnected
//                if !isConnected {
//                    self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//                    return
//                }
//                self.performLoginAttempt()
//            }
//        }
//    }
//
//    // التحقق من الاتصال بالإنترنت
//    private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            DispatchQueue.main.async {
//                if path.status == .satisfied {
//                    self.checkInternetAccess { isReachable in
//                        DispatchQueue.main.async {
//                            completion(isReachable)
//                        }
//                    }
//                } else {
//                    completion(false)
//                }
//            }
//        }
//        let queue = DispatchQueue(label: "InternetConnectionMonitor")
//        monitor.start(queue: queue)
//    }
//
//    private func checkInternetAccess(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        request.timeoutInterval = 5
//
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    // محاولة تسجيل الدخول
//    private func performLoginAttempt() {
//        apiService.login(username: username, password: password) { [weak self] result in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    if response.state == 0 {
//                        self.handleSuccessfulLogin(response)
//                    } else {
//                        self.handleFailedLogin(message: response.message)
//                    }
//                case .failure(let error):
//                    self.handleLoginFailure(error: error)
//                }
//            }
//        }
//    }
//
//    // التعامل مع تسجيل الدخول الناجح
//    private func handleSuccessfulLogin(_ response: LoginResponse) {
//        self.isLoggedIn = true
//        self.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
//        self.loginError = nil
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.navigateToNextPage = true
//        }
//    }
//
//    // التعامل مع تسجيل الدخول الفاشل
//    private func handleFailedLogin(message: String) {
//        self.loginError = message
//        self.responseMessage = ""
//    }
//
//    // التعامل مع فشل الاتصال أو حدوث خطأ آخر
//    private func handleLoginFailure(error: Error) {
//        // فقط إذا كان هناك خطأ في الاتصال بالإنترنت
//        if !self.isConnectedToInternet {
//            self.loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//        } else {
//            self.loginError = error.localizedDescription // إظهار الخطأ من request
//        }
//        self.responseMessage = ""
//    }
//}
//
//
//
//
//



//import SwiftUI
//import Network
//
//class LoginViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var password = ""
//    @Published var loginError: String?
//    @Published var isLoggedIn = false
//    @Published var responseMessage = ""
//    @Published var isConnectedToInternet = true
//    @Published var navigateToNextPage = false
//
//    private var apiService = ApiService()
//    private var monitor: NWPathMonitor?
//
//    init() {
//        startMonitoringInternetConnection()
//    }
//
//    private func startMonitoringInternetConnection() {
//        monitor = NWPathMonitor()
//        monitor?.pathUpdateHandler = { [weak self] path in
//            DispatchQueue.main.async {
//                // التحقق من وجود اتصال بشبكة الإنترنت الفعلي
//                if path.status == .satisfied {
//                    self?.checkInternetAccess { isReachable in
//                        DispatchQueue.main.async {
//                            self?.isConnectedToInternet = isReachable
//                        }
//                    }
//                } else {
//                    self?.isConnectedToInternet = false
//                }
//            }
//        }
//
//        let queue = DispatchQueue(label: "InternetConnectionMonitor")
//        monitor?.start(queue: queue)
//    }
//
//    deinit {
//        monitor?.cancel()
//    }
//
//    private func checkInternetAccess(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD" // استخدام طلب خفيف للتحقق
//        request.timeoutInterval = 5 // مهلة قصيرة
//
//        let task = URLSession.shared.dataTask(with: request) { _, response, error in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
//        task.resume()
//    }
//
//    func login() {
//        guard isConnectedToInternet else {
//            loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//            return
//        }
//
//        apiService.login(username: username, password: password) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    if response.state == 0 {
//                        self?.isLoggedIn = true
//                        self?.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
//                        self?.loginError = nil
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            self?.navigateToNextPage = true // Delay navigation
//                        }
//                    } else {
//                        self?.loginError = response.message
//                        self?.responseMessage = ""
//                    }
//                case .failure(let error):
//                    self?.loginError = error.localizedDescription
//                    self?.responseMessage = ""
//                }
//            }
//        }
//    }
//}














//old
//import SwiftUI
//import Network
//
//class LoginViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var password = ""
//    @Published var loginError: String?
//    @Published var isLoggedIn = false
//    @Published var responseMessage = ""
//    @Published var isConnectedToInternet = true
//    @Published var navigateToNextPage = false
//
//    private var apiService = ApiService()
//    private var monitor: NWPathMonitor?
//
//    init() {
//        startMonitoringInternetConnection()
//    }
//
//    private func startMonitoringInternetConnection() {
//        monitor = NWPathMonitor()
//        monitor?.pathUpdateHandler = { [weak self] path in
//            DispatchQueue.main.async {
//                self?.isConnectedToInternet = (path.status == .satisfied)
//            }
//        }
//
//        let queue = DispatchQueue(label: "InternetConnectionMonitor")
//        monitor?.start(queue: queue)
//    }
//
//    deinit {
//        monitor?.cancel()
//    }
//
//    func login() {
//        guard isConnectedToInternet else {
//            loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
//            return
//        }
//
//        apiService.login(username: username, password: password) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    if response.state == 0 {
//                        self?.isLoggedIn = true
//                        self?.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
//                        self?.loginError = nil
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                             self?.navigateToNextPage = true // Delay navigation
//                                  }
//                        
//                    } else {
//                        self?.loginError = response.message
//                        self?.responseMessage = ""
//                    }
//                case .failure(let error):
//                    self?.loginError = error.localizedDescription
//                    self?.responseMessage = ""
//                }
//            }
//        }
//    }
//}
