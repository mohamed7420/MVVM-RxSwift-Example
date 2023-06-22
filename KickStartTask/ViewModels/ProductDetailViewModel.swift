//
//  ProductDetailViewModel.swift
//  KickStartTask
//
//  Created by MohamedOsama on 21/06/2023.
//

import Foundation

struct ProductDetailViewModel {
    
    private let product: APIProduct
    
    init(product: APIProduct) {
        self.product = product
    }
    
    var images: [String] {
        product.images
    }
    
    var brand: String {
        product.brand
    }
    
    var title: String {
        product.title
    }
    
    var description: String {
        product.description
    }
    
    var price: String {
        .localizedStringWithFormat("$%.2f", product.price)
    }
}
