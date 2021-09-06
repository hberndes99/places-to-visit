//
//  NetworkManager.swift
//  places to visit app
//
//  Created by Harriette Berndes on 26/08/2021.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    static let localHostUrl = "http://127.0.0.1:8000/"
    var networkSessionObject: NetworkSession
    
    init(networkSessionObject: NetworkSession = URLSession.shared) {
        self.networkSessionObject = networkSessionObject
    }
    
    func getData(completion: @escaping (_ wishLists: [WishList]?, _ errorMessage: String?) -> Void) {
        let url = URL(string: "\(NetworkManager.localHostUrl)places/wishlists/")
        let task = networkSessionObject.dataTask(with: url!) { data, response, error in
            if error != nil {
                completion(nil, "error occured")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, "bad response")
                return
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                if let decodedData = try? jsonDecoder.decode([WishList].self, from: data) {
                    completion(decodedData, nil)
                }
            }
        }
        task.resume()
    }
    
    func postData<T>(dataToPost: T, endpoint: String, completion: @escaping (T) -> ()) where T : Decodable, T : Encodable {
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(dataToPost) {
            if let url = URL(string: "\(NetworkManager.localHostUrl)\(endpoint)") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = encodedData
                let task = networkSessionObject.dataTask(with: request) { data, response, error in
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
    
    func deleteItem(endpoint: String, id: Int) {
        if let url = URL(string: "\(NetworkManager.localHostUrl)\(endpoint)\(id)/") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            let task = networkSessionObject.dataTask(with: request) { data, response, error in
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




protocol NetworkManagerProtocol {
    func getData(completion: @escaping (_ wishLists: [WishList]?, _ errorMessage: String?) -> Void)
    func postData<T: Codable>(dataToPost: T, endpoint: String, completion: @escaping (T) -> ())
    func deleteItem(endpoint: String, id: Int)
}


protocol NetworkTask {
    func resume()
}

extension URLSessionDataTask: NetworkTask {
    
}

protocol NetworkSession {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask

    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}

extension URLSession: NetworkSession {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        return dataTask(with: request, completionHandler: completion)
    }
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        return dataTask(with: url, completionHandler: completion)
    }
}
