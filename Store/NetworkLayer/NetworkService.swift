//
//  NetworkService.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[Product]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    private let url = "http://94.127.67.113:8099/getGoods"
    
    func fetchProducts(completion: @escaping (Result<[Product]?, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let obj = try JSONDecoder().decode([Product].self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
