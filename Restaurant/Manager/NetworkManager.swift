//
//  NetworkManager.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 04.06.2022.
//

import UIKit

class NetworkManager {
    let baseURL = URL(string: "http://mda.getoutfit.co:8090")!
    
    // MARK: - Get Methods
    
    func getCategories(completion: @escaping ([String]?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
            let decodedDate = try decoder.decode(Categories.self, from: data)
                completion(decodedDate.categories, nil)
            } catch let error {
                completion(nil,error)
            }
    }
        task.resume()
}
    func getMenuItems(for category: String, completion: @escaping([MenuItem]?, Error?) -> Void) {
        let initialUrl = baseURL.appendingPathComponent("menu")
        guard let url = initialUrl.withQueries(["category": category]) else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(MenuItems.self, from: data)
                completion(decodedData.items, nil)
            } catch let error {
                completion(nil, error)
            }

        }
        task.resume()
    }
    func getImage(_ initialURL: URL, completion: @escaping(UIImage?, Error?) -> Void) {
        var components = URLComponents(url: initialURL, resolvingAgainstBaseURL: true)
        components?.host = baseURL.host
        guard let url = components?.url else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }
        task.resume()
    }
    
    // MARK: - POST Methtods
        func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Int?, Error?) -> Void) {
            let url = baseURL.appendingPathComponent("order")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = ["menuIds": menuIDs]
            let encoder = JSONEncoder()
            let jsonData = try? encoder.encode(data)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    print(#line, #function, "ERROR: Data is nil")
                    completion(nil, nil)
                    return
                }
                let decoder = JSONDecoder()
                guard let preparationTime = try? decoder.decode(PreparationTime.self, from: data) else {
                    print(#line, #function, "ERROR: Can't decode data from json")
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!) // Print JSON raw value for debug
                    completion(nil, nil)
                    return
                }

                completion(preparationTime.prepTime, nil)
            }
            task.resume()
        }
}
