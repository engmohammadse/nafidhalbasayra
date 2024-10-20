//
//  LoginViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//

import SwiftUI
import Network

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var loginError: String?
    @Published var isLoggedIn = false
    @Published var responseMessage = ""
    @Published var isConnectedToInternet = true // حالة الاتصال بالإنترنت

    private var apiService = ApiService()
    private var monitor: NWPathMonitor? // لمراقبة الاتصال بالإنترنت

    init() {
        startMonitoringInternetConnection()
    }

    private func startMonitoringInternetConnection() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                // تحديث حالة الاتصال بالإنترنت
                self?.isConnectedToInternet = (path.status == .satisfied)
            }
        }

        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor?.start(queue: queue)
    }
    
    deinit {
        monitor?.cancel() // إيقاف المراقبة عند تدمير الكائن
    }

    func login() {
        // تحقق من الاتصال بالإنترنت قبل محاولة تسجيل الدخول
        guard isConnectedToInternet else {
            loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
            return
        }

        apiService.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // تحقق من نجاح تسجيل الدخول
                    if response.state == 0 {
                        self?.isLoggedIn = true
                        self?.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
                        self?.loginError = nil  // مسح أي أخطاء سابقة
                    } else {
                        self?.loginError = response.message
                        self?.responseMessage = ""  // مسح رسالة الاستجابة عند الفشل
                    }
                case .failure(let error):
                    // معالجة الأخطاء
                    self?.loginError = error.localizedDescription
                    self?.responseMessage = ""
                }
            }
        }
    }
}
