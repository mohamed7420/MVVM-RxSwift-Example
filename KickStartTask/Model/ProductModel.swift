//
//  ProductModel.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import Foundation
import Differentiator

struct APIProductResponse: Decodable {
    let products: [APIProduct]
}

struct APIProduct: Decodable, IdentifiableType, Equatable {
    typealias Identity = UUID
    var identity: UUID {
        UUID()
    }
    
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
}
