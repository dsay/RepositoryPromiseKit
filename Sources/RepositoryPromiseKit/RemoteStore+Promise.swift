import PromiseKit
import Foundation
import SwiftRepository

public extension RemoteStore {
    
    func requestString(request: RequestProvider) -> Promise<String> {
        Promise { resolver in
            send(request: request, responseString: { (response: Swift.Result<String, Error>) -> Void  in
                switch response {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
    
    func requestData(request: RequestProvider) -> Promise<Data> {
        Promise { resolver in
            send(request: request, responseData: { (response: Swift.Result<Data, Error>) -> Void  in
                switch response {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
    
    func requestJSON(request: RequestProvider) -> Promise<Any> {
        Promise { resolver in
            send(request: request, responseJSON: { (response: Swift.Result<Any, Error>) -> Void  in
                switch response {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
}

public extension RemoteStoreObjects {
    
    func requestArray(request: RequestProvider, keyPath: String? = nil) -> Promise<[Item]> {
        Promise { resolver in
            send(request: request, keyPath: keyPath, responseArray: { (response: Swift.Result<[Item], Error>) -> Void  in
                switch response {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
    
    func requestObject(request: RequestProvider, keyPath: String? = nil) -> Promise<Item> {
        Promise { resolver in
            send(request: request, keyPath: keyPath, responseObject: { (response: Swift.Result<Item, Error>) -> Void  in
                switch response {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
}
