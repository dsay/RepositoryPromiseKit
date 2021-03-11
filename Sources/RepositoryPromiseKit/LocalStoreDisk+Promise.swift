import PromiseKit
import Foundation
import SwiftRepository

public extension LocalStoreDisk {
    
    func isExistsItem(at URL: String) -> Promise<Void> {
        return Promise { resolver in
            if isExists(at: URL) {
                resolver.fulfill(())
            } else {
                resolver.reject(RepositoryError.notExists)
            }
        }
    }
    
    func getItem(from URL: String) -> Promise<Item> {
        return Promise { resolver in
            do {
                let data = try get(from: URL)
                resolver.fulfill(data)
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func removeItem(from URL: String) -> Promise<Void> {
        return Promise { resolver in
            do {
                try remove(from: URL)
                resolver.fulfill(())
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func saveItem(_ item: Item, at URL: String) -> Promise<Void> {
        return Promise { resolver in
            do {
                try save(item, at: URL)
                resolver.fulfill(())
            } catch {
                resolver.reject(error)
            }
        }
    }
}
