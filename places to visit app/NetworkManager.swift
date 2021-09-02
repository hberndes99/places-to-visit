//
//  NetworkManager.swift
//  places to visit app
//
//  Created by Harriette Berndes on 26/08/2021.
//

import Foundation

class NetworkManager {
    
    static let localHostUrl = "http://127.0.0.1:8000/"
    
    static func getData(completion: @escaping ([WishList]) -> Void) {
        let url = URL(string: "\(localHostUrl)places/wishlists/")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("bad response")
                return
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                if let decodedData = try? jsonDecoder.decode([WishList].self, from: data) {
                    completion(decodedData)
                }
            }
        }
        task.resume()
    }
    
    static func postData<T: Codable>(dataToPost: T, endpoint: String, completion: @escaping (T) -> ()) {
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(dataToPost) {
            if let url = URL(string: "\(localHostUrl)\(endpoint)") {
                print("url worked")
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = encodedData
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("bad response")
                        return
                    }
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        if let decodedData = try? jsonDecoder.decode(T.self, from: data) {
                            print("calling completion")
                            completion(decodedData)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    static func deleteItem(endpoint: String, id: Int) {
        if let url = URL(string: "\(localHostUrl)\(endpoint)\(id)") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                    print("bad response")
                    return
                }
            }
            task.resume()
        }
    }
    
}
