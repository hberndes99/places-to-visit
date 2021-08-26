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
}
