//
//  NetworkManager.swift
//  places to visit app
//
//  Created by Harriette Berndes on 26/08/2021.
//

import Foundation

class NetworkManager {
    static func getData(completion: @escaping ([WishList]) -> Void) {
        let url = URL(string: "http://127.0.0.1:8000/places/wishlists/")
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
    
    static func postData(wishList: WishList, completion: @escaping (WishList) -> ()) {
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(wishList) {
            print(encodedData)
            if let url = URL(string: "http://127.0.0.1:8000/places/wishlists/") {
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
                        if let decodedData = try? jsonDecoder.decode(WishList.self, from: data) {
                            print("calling completion")
                            completion(decodedData)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    static func postMapPoint(mapPoint: MapAnnotationPoint, completion: @escaping (MapAnnotationPoint) -> ()) {
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(mapPoint) {
            guard let url = URL(string: "http://localhost:8000/places/wishlists/mappoints/") else {
                return
            }
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
                    if let decodedData = try? jsonDecoder.decode(MapAnnotationPoint.self, from: data) {
                        completion(decodedData)
                    }
                }
            }
            task.resume()
        }
    }
}
