//
//  ProductViewModel.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import Foundation
import RxSwift
import RxRelay
import Differentiator

struct ProductViewModel {
    
    enum URLError: Error {
        case invalidURL
    }
    public let productsBehavior = BehaviorRelay<[APIProduct]>(value: [])
    public let isLoadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private let manager = NetworkService.shared
    private let storageManager = StorageManager.shared
    
    var isUserConnected: Bool {
        manager.isNetworkConnected()
    }
    
    public func checkLoadingProducts() {
        Task {
            do {
                isUserConnected ? try await self.loadAllProducts() : self.fetchSavedProducts()
            } catch {
                print(error)
            }
        }
    }
    
    private func loadAllProducts() async throws {
        guard let url = URL(string: Constants.apiURL) else { throw URLError.invalidURL }
        
        isLoadingBehavior.accept(true)
        
        let product: APIProductResponse = try await manager.sendRequest(url: url)
        productsBehavior.accept(product.products)
        
        DispatchQueue.main.async {
            self.storageManager.saveProducts(products: product.products)
        }
        isLoadingBehavior.accept(false)
    }
    
    private func fetchSavedProducts() {
        if let products = storageManager.fetchProducts() {
            let apiProducts = products.map {
                APIProduct(id: Int($0.id), title: $0.title ?? "not found", description: $0.description_ ?? "",
                           price: $0.price,
                           discountPercentage: $0.discountPercentage, rating: $0.rate,
                           stock: Int($0.stock), brand: $0.brand ?? "", category: $0.category ?? "",
                           thumbnail: $0.thumbnail ?? "", images: [$0.image ?? ""])
            }
            productsBehavior.accept(apiProducts)
        }
    }
    
    public func search(by text: String) {
        if !text.isEmptyOrWhitespaces {
            if let products = storageManager.searchProducts(query: text) {
                let apiProducts = products.map {
                    APIProduct(id: Int($0.id), title: $0.title ?? "not found", description: $0.description_ ?? "",
                               price: $0.price,
                               discountPercentage: $0.discountPercentage, rating: $0.rate,
                               stock: Int($0.stock), brand: $0.brand ?? "", category: $0.category ?? "",
                               thumbnail: $0.thumbnail ?? "", images: [$0.image ?? ""])
                }
                productsBehavior.accept(apiProducts)
            }
        } else {
            checkLoadingProducts()
        }
    }
}
