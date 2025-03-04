//
//  ImageUploader.swift
//  nafidhalbasayra
//
//  Created by muhammad on 04/03/2025.
//


import Foundation
import UIKit

struct IDUploader {
    let baseURL = "http://145.14.157.11:8000"

    func uploadIDImage(image: UIImage, for type: String, completion: @escaping (Bool, String?, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/predict-with-image/") else {
            completion(false, nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let fileName = type == "Face_id" ? "face.jpg" : "back.jpg"

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let boundaryPrefix = "--\(boundary)\r\n"
            body.append(Data(boundaryPrefix.utf8))
            body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".utf8))
            body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
            body.append(imageData)
            body.append(Data("\r\n".utf8))
        }

        body.append(Data("--\(boundary)--\r\n".utf8))
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, nil, nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let isID = json["is_id"] as? Bool,
                   let imageURLPart = json["image_url"] as? String,
                   let responseType = json["type"] as? String {

                    if isID {
                        completion(true, "\(self.baseURL)\(imageURLPart)", responseType)
                    } else {
                        completion(false, nil, nil)
                    }
                } else {
                    completion(false, nil, nil)
                }
            } catch {
                completion(false, nil, nil)
            }
        }.resume()
    }
}
