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
    @Published var isConnectedToInternet = true
    @Published var navigateToNextPage = false

    private var apiService = ApiService()
    private var monitor: NWPathMonitor?

    init() {
        startMonitoringInternetConnection()
    }

    private func startMonitoringInternetConnection() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnectedToInternet = (path.status == .satisfied)
            }
        }

        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor?.start(queue: queue)
    }

    deinit {
        monitor?.cancel()
    }

    func login() {
        guard isConnectedToInternet else {
            loginError = "الجهاز غير مرتبط بالإنترنت. يرجى التحقق من الاتصال."
            return
        }

        apiService.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.state == 0 {
                        self?.isLoggedIn = true
                        self?.responseMessage = "تم بنجاح تسجيل الدخول، ID: \(response.id)"
                        self?.loginError = nil
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                             self?.navigateToNextPage = true // Delay navigation
                                  }
                        
                    } else {
                        self?.loginError = response.message
                        self?.responseMessage = ""
                    }
                case .failure(let error):
                    self?.loginError = error.localizedDescription
                    self?.responseMessage = ""
                }
            }
        }
    }
}
