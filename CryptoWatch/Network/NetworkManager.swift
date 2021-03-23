//
//  NetworkManager.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/18/21.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct Request {
    
    func requestForAssetList() -> URLRequest {
        let fullURL = URL(string: "\(Constants.assetListURL)?apikey=\(apiKey)")!
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        
        return request
    }
    
    func requestForAssetIcons() -> URLRequest {
        let fullURL = URL(string: "\(Constants.assetIconURL)/20?apikey=\(apiKey)")!
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        
        return request
    }
    
    func requestForAsset(coin: String) -> URLRequest {
        let fullURL = URL(string: "\(Constants.assetListURL)/\(coin)?apikey=\(apiKey)")!
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        
        return request
    }
}

class NetworkManager {
    
    let urlSession = URLSession.shared
    let requestURL = Request()
    static let shared = NetworkManager()
    
    func getCoins(completion: @escaping (Result<[Coin]>) -> ()) {
        let request = requestURL.requestForAssetList()
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode([Coin].self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
    
    func getCoinIcons(completion: @escaping (Result<[Icon]>) -> ()) {
        let request = requestURL.requestForAssetIcons()
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode([Icon].self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
    
    func getCoin(coin: String, completion: @escaping (Result<[Coin]>) -> ()) {
        let request = requestURL.requestForAsset(coin: coin)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode([Coin].self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
}
