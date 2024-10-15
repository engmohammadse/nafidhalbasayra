//
//  LoginViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var loginError: String?
    @Published var isLoggedIn = false
    @Published var responseMessage = ""

    private var apiService = ApiService()

    func login() {
        apiService.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.state == 0 {
                        self?.isLoggedIn = true
                        self?.responseMessage = "Login successful, ID: \(response.id)"
                        self?.loginError = nil  // Clear any previous errors
                    } else {
                        self?.loginError = response.message
                        self?.responseMessage = ""  // Clear the response message on failure
                    }
                case .failure(let error):
                    // If the error is a custom error with a message, use that; otherwise, fallback to generic message
                    self?.loginError = error.localizedDescription
                    self?.responseMessage = ""
                }
            }
        }
    }
}
