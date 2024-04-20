//
//  PANetworkingManager.swift
//  PAGrid
//
//  Created by Admin on 15/04/24.
//

import Foundation

var baseURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
var placeHolderImage = "https://cdn.dummyjson.com/product-images/8/thumbnail.jpg"

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Int)
        case invalidResponse
        case invalidData
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.requestFailed(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
