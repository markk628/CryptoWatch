//
//  WebSocketService.swift
//  CryptoWatch
//
//  Created by Mark Kim on 4/29/21.
//

import Foundation
import Combine

protocol CryptoPriceDelegate: class {
    func sendPrice()
}

class WebSocketService: ObservableObject {
    
    static let shared = WebSocketService()
    
    private let urlSession: URLSession = URLSession(configuration: .default)
    private var webSocketTask: URLSessionWebSocketTask?
    
    private let baseURL: URL = URL(string: "\(Constants.baseWebSocketURL)?token=\(webSocketAPIKey)")!
        
    let didChange = PassthroughSubject<Void, Never>()
    @Published var price: String = ""
    
    private var cancellable: AnyCancellable? = nil
    
    var priceResult: String = "" {
        didSet {
            didChange.send()
        }
    }
    
    weak var cryptoPriceDelegate: CryptoPriceDelegate?
    
    
    init() {
        cancellable = AnyCancellable($price
                                        .debounce(for: 0.5, scheduler: DispatchQueue.main)
                                        .removeDuplicates()
                                        .assign(to: \.priceResult, on: self))
    }
    
    func connect() {
        
        stop()
        webSocketTask = urlSession.webSocketTask(with: baseURL)
        webSocketTask?.resume()
        
        sendMessage()
        receiveMessage()
        //sendPing()
    }
    
    private func sendPing() {
        webSocketTask?.sendPing { (error) in
            if let error = error {
                print("Sending PING failed: \(error)")
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.sendPing()
            }
        }
    }
    
    func stop() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func sendMessage() {
        let string = "{\"type\":\"subscribe\",\"symbol\":\"BINANCE:BTCUSDT\"}"
        
        let message = URLSessionWebSocketTask.Message.string(string)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket couldn't send message because: \(error)")
            }
//            self.cryptoPriceDelegate?.sendPrice()
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(.string(let str)):
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(APIResponse.self, from: Data(str.utf8))
                    DispatchQueue.main.async{
                        self?.price = "\(result.data[0].p)"
                    }
                    self?.cryptoPriceDelegate?.sendPrice()
                } catch  {
                    print("error is \(error.localizedDescription)")
                }
                
                self?.receiveMessage()
                
            default:
                print("default")
            }
        }
    }
    
}

struct APIResponse: Codable {
    var data: [PriceData]
    var type : String
    
    private enum CodingKeys: String, CodingKey {
        case data, type
    }
}

struct PriceData : Codable{
    
    public var p: Float
    
    private enum CodingKeys: String, CodingKey {
        case p
    }
}
