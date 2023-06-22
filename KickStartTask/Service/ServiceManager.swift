//
//  ServiceManager.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import Foundation
import Network

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    enum RequestError: Error {
        case networkError
        case invalidResponse(statusCode: Int)
        case decodingError
        
        var description: String {
            switch self {
            case .networkError: return NSLocalizedString("Please check your internet connection", comment: "")
            case .invalidResponse, .decodingError: return NSLocalizedString("Something went wrong", comment: "")
            }
        }
    }
    
    func isNetworkConnected() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 5) // Wait for 5 seconds to check network status
        
        return isConnected
    }
    
    func sendRequest<T: Decodable>(url: URL) async throws -> T {
        guard isNetworkConnected() else {
            throw  RequestError.networkError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for invalid response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw RequestError.invalidResponse(statusCode: statusCode)
        }
          
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw RequestError.decodingError
        }
    }
}
