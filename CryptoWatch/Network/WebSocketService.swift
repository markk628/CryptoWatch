//
//  WebSocketService.swift
//  CryptoWatch
//
//  Created by Mark Kim on 4/29/21.
//

import UIKit
import Combine
import UserNotifications

protocol CryptoPriceDelegate: class {
    func reloadTable()
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
    
    var coins: [MyCoin]!
    
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
        
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.coins.map { $0.assetId! }
                    .forEach { self.sendMessage(coinSymbol: $0) }
            }
        }
        
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
    
    private func sendMessage(coinSymbol: String) {
        
        // if coin doesnt exist in exchange check other exchanges by iterating through them
        let string = "{\"type\":\"subscribe\",\"symbol\":\"BINANCE:\(coinSymbol)USDT\"}"
        
        let message = URLSessionWebSocketTask.Message.string(string)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket couldn't send message because: \(error)")
            }
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
                        
                        // filter through coredata coins and find the coin.assetid that matches result.data s value and update current price with result.data p
                        
                        let symbol = result.data[0].s.components(separatedBy: ":").last
                        let coin = self!.coins.filter { (symbol?.contains($0.assetId!))! }
                            .first
                        let coinTempPrice = coin?.currentPrice
                        coin?.currentPrice = Double(self!.price) ?? coinTempPrice!
                        CoreDataStack.shared.saveContext()
                        
                        if coinTempPrice! < coin!.targetPrice && coin!.targetPrice < Double(self!.price)! {
                            let content = UNMutableNotificationContent()
                            content.title = "\(String(describing: coin!.assetId!))"
                            content.body = "\(String(describing: coin!.name!)) is now at \(coin!.targetPrice)"
                            content.sound = UNNotificationSound.default
                            
                            let date = Date().addingTimeInterval(1)
                            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                            let uuidString = UUID().uuidString
                            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                            
                            cWNotification.add(request) { error in
                                print("send notification")
                            }
                        } else if Double(self!.price)! < coin!.targetPrice && coin!.targetPrice < coinTempPrice! {
                            let content = UNMutableNotificationContent()
                            content.title = "\(String(describing: coin!.assetId!))"
                            content.body = "\(String(describing: coin!.name!)) is now at \(coin!.targetPrice)"
                            content.sound = UNNotificationSound.default
                            
                            let date = Date().addingTimeInterval(1)
                            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                            let uuidString = UUID().uuidString
                            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
                            cWNotification.add(request) { error in
                                print("send notification")
                            }
                        }
                        
                        self?.cryptoPriceDelegate?.reloadTable()
                        
                        
                    }
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
    
    public var s: String
    public var p: Float
    
    private enum CodingKeys: String, CodingKey {
        case s, p
    }
}
