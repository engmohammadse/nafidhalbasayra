//
//  LoginViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//new

import SwiftUI
import Network

class LoginViewModel: ObservableObject {
   // private var vmTeacherFromApi = TeacherDataFromApiViewModel() // تعريف محلي لـ TeacherDataFromApiViewModel
    
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

    // تعريف أنواع الصفحات بناءً على الحالة
    enum PageType {
        case registerInfo
        case waitProcess
        case homePage
        case rejectionIssue
    }

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

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }

    // محاولة تسجيل الدخول
    private func performLoginAttempt() {
        self.isLoading = true
        apiService.login(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let response):
                    self.handleSuccessfulLogin(response)
                case .failure(let error):
                    self.handleLoginFailure(error: error)
                }
            }
        }
    }

    // التعامل مع تسجيل الدخول الناجح
    private func handleSuccessfulLogin(_ response: LoginResponse) {
        self.isLoggedIn = true
        self.loginError = nil
        
        
        // تحديث الرسالة لعرضها للمستخدم
         self.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
        
  
        
        
        let defaults = UserDefaults.standard
        let teacherId = "\(response.id)"

        
        // ✅ حفظ معرف المعلم

        defaults.set(teacherId, forKey: "teacherId")
        defaults.set(response.data?.rejectionReason, forKey: "rejectionReason")
        
        
        // ✅ حفظ اسم المستخدم إذا كان متاحًا
        if let username = response.data?.username {
            defaults.set(username, forKey: "username")
            print("✅ تم حفظ اسم المستخدم في UserDefaults: \(username)")
        }

        
        
        // تخزين معرف المعلم
            
         print("✅ تم تخزين معرف الأستاذ في قاعدة البيانات.")
         print("\(response.id)")


        // تحديد الصفحة بناءً على الحالة
        switch response.state {
        case 0:
            self.nextPage = .registerInfo
        case 1:
            self.nextPage = .waitProcess
        case 2:
            self.nextPage = .homePage
            let loginState = 2
            defaults.set(loginState, forKey: "loginState")
        case 3:
            self.nextPage = .rejectionIssue
        default:
            self.loginError = "حالة غير معروفة: \(response.state)"
            self.nextPage = nil
        }

        // تفعيل التنقل إذا كانت الحالة معروفة
        if self.nextPage != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigateToNextPage = true
            }
        }
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
