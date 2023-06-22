//
//  StorageManager.swift
//  KickStartTask
//
//  Created by MohamedOsama on 21/06/2023.
//

import Foundation
import CoreData


class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
    
    
    public func saveProducts(products: [APIProduct]) {
        container.performBackgroundTask { context in
            self.deleteOldSavedItems(context: context)
            self.saveProductToCoreData(products: products, context: context)
        }
    }
    
    
    private func deleteOldSavedItems(context: NSManagedObjectContext) {
        do {
            let oldProducts = try context.fetch(fetchRequest)
            _ = oldProducts.map { context.delete($0) }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func saveProductToCoreData(products: [APIProduct], context: NSManagedObjectContext) {
        context.perform {
            for product in products {
                let productEntity = Product(context: context)
                productEntity.id = Int64(product.id)
                productEntity.description_ = product.description
                productEntity.title = product.title
                productEntity.price = product.price
                productEntity.rate = product.rating
                productEntity.category = product.category
                productEntity.discountPercentage = product.discountPercentage
                productEntity.stock = Int64(product.stock)
                productEntity.thumbnail = product.thumbnail
                productEntity.image = product.images.first
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    public func fetchProducts() -> [Product]? {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let products = try container.viewContext.fetch(fetchRequest)
            return products
        } catch {
            print("Failed to fetch products: \(error)")
            return nil
        }
    }

    public func searchProducts(query: String) -> [Product]? {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", query)
        fetchRequest.predicate = predicate
        
        do {
            let products = try container.viewContext.fetch(fetchRequest)
            return products
        } catch {
            print("Failed to fetch products: \(error)")
            return nil
        }
    }
}
