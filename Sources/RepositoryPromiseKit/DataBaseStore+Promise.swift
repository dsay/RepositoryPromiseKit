import PromiseKit
import Foundation
import SwiftRepository

public extension LocalStoreDataBase {
    
    func getItems() -> Promise<[Item]> {
        Promise { resolver in
            getItems { result in
                switch result {
                case .success(let items):
                    resolver.fulfill(items)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func getItem() -> Promise<Item> {
        Promise { resolver in
            getItem { result in
                switch result {
                case .success(let item):
                    resolver.fulfill(item)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func get(with id: Int) -> Promise<Item> {
        Promise { resolver in
            get(with: id) { result in
                switch result {
                case .success(let item):
                    resolver.fulfill(item)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func get(with id: String) -> Promise<Item> {
        Promise { resolver in
            get(with: id) { result in
                switch result {
                case .success(let item):
                    resolver.fulfill(item)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func get(with predicate: NSPredicate) -> Promise<[Item]> {
        Promise { resolver in
            get(with: predicate) { result in
                switch result {
                case .success(let item):
                    resolver.fulfill(item)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func update(_ write: @escaping () -> Void) -> Promise<Void> {
        Promise { resolver in
            update(write) { result in
                switch result {
                case .success(let item):
                    resolver.fulfill(item)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func save(_ item: Item, policy: UpdatePolicy = .all) -> Promise<Void> {
        Promise { resolver in
            save(item, policy: policy) { result in
                switch result {
                case .success:
                    resolver.fulfill(())
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func save(_ items: [Item], policy: UpdatePolicy = .all) -> Promise<Void> {
        Promise { resolver in
            save(items, policy: policy) { result in
                switch result {
                case .success:
                    resolver.fulfill(())
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func remove(_ item: Item) -> Promise<Void> {
        Promise { resolver in
            remove(item) { result in
                switch result {
                case .success:
                    resolver.fulfill(())
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func remove(_ items: [Item]) -> Promise<Void> {
        Promise { resolver in
            remove(items) { result in
                switch result {
                case .success:
                    resolver.fulfill(())
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
}

public extension Thenable  {
    
    func update<S: LocalStoreDataBase>(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ store: S, _ transform: @escaping(T) -> Void) -> Promise<T> {
        let rg = Promise<T>.pending()
        
        pipe {
            switch $0 {
            case .fulfilled(let value):
                on.async(flags: flags) {
                    store.update( {
                        transform(value)
                    }, response: { result in
                        switch result {
                        case .success:
                            rg.resolver.fulfill(value)
                            
                        case .failure(let error):
                            rg.resolver.reject(error)
                        }
                    })
                }
                
            case .rejected(let error):
                rg.resolver.reject(error)
            }
        }
        return rg.promise
    }
}

public extension Thenable where T: Sequence {
    
    func update<S: LocalStoreDataBase>(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ store: S, _ transform: @escaping([T.Iterator.Element]) -> Void) -> Promise<[T.Iterator.Element]> {
        let rg = Promise<[T.Iterator.Element]>.pending()
        
        pipe {
            switch $0 {
            case .fulfilled(let values):
                store.update({
                    transform(values.map { $0 })
                }) { result in
                    switch result {
                    case .success:
                        rg.resolver.fulfill(values.map { $0 })
                        
                    case .failure(let error):
                        rg.resolver.reject(error)
                    }
                }
            case .rejected(let error):
                rg.resolver.reject(error)
            }
        }
        return rg.promise
    }
}

extension Optional where Wrapped: DispatchQueue {
    
    @inline(__always)
    func async(flags: DispatchWorkItemFlags?, _ body: @escaping() -> Void) {
        switch self {
        case .none:
            body()
        case .some(let q):
            if let flags = flags {
                q.async(flags: flags, execute: body)
            } else {
                q.async(execute: body)
            }
        }
    }
}
