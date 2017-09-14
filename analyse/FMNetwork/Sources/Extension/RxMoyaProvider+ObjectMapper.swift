//
//  RxMoyaProvider+ObjectMapper.swift
//  NewUstock
//
//  Created by Kyle on 16/6/1.
//  Copyright © 2016年 ustock. All rights reserved.
//

import Common
import Moya
import RxSwift
import SwiftyJSON
import ObjectMapper

extension RxMoyaProvider {

    public func requestJSON(_ token: Target, validate: Bool = false) -> Observable<JSON> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in

            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            try self?.validateResponse(response)
                        } catch {
                            DispatchQueue.main.async(execute: {
                                ShareNetwork.doInterceptionNectWorkErrorCode(nil, error: error as? USError, isTrade: validate)
                                observer.onError(error)
                            })
                        }

                        if validate {
                            let json = JSON(data: response.data)
                            if let result = json["result"].string, result == "1" {
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(json["obj"])
                                    observer.onCompleted()
                                })
                            } else {
                                DispatchQueue.main.async(execute: {
                                    ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                    observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json["obj"]))
                                })
                           }
                        } else {

                            let json = JSON(data: response.data)
                            DispatchQueue.main.async(execute: {
                                observer.onNext(json)
                                observer.onCompleted()
                            })
                        }
                    }

                    break
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(USError.networkError(error._code, error.response?.description ?? "网络错误，请稍候重试"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func requestNoResponseMapper(_ token: Target, validate: Bool = false) -> Observable<SuccessMsg> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            try self?.validateResponse(response)
                        } catch {
                            DispatchQueue.main.async(execute: {
                                ShareNetwork.doInterceptionNectWorkErrorCode(nil, error: error as? USError, isTrade: validate)
                                observer.onError(error)
                            })
                        }

                        if validate {
                            let json = JSON(data: response.data)
                            if let result = json["result"].string, result == "1" {
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(SuccessMsg())
                                    observer.onCompleted()
                                })
                            } else {
                                DispatchQueue.main.async(execute: {
                                    ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                    observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json))
                                })
                           }
                        } else {
                            DispatchQueue.main.async(execute: {
                                observer.onNext(SuccessMsg())
                                observer.onCompleted()
                            })
                        }

                    }
                    break
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(USError.networkError(error._code, error.response?.description ?? "网络错误，请稍候重试"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    enum ZZMapType: String {
        case obj
        case list
        case dic
    }
    
    /// Designated request-making method.
    public func requestObjectMapper<T: Mappable>(_ token: Target, validate: Bool = false, isObj: Bool = true) -> Observable<T> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            try self?.validateResponse(response)
                        } catch {
                            DispatchQueue.main.async(execute: {
                                ShareNetwork.doInterceptionNectWorkErrorCode(nil, error: error as? USError, isTrade: validate)
                                observer.onError(error)
                            })
                        }

                        do {
                            if validate {
                                let json = JSON(data: response.data)
                                if isObj {
                                    if let result = json["result"].string, result == "1",
                                        let dictionary = json["obj"].dictionaryObject,
                                        let object =  Mapper<T>().map(JSON: dictionary) {
                                        DispatchQueue.main.async(execute: {
                                            observer.onNext(object)
                                            observer.onCompleted()
                                        })
                                    } else {
                                        DispatchQueue.main.async(execute: {
                                            ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                            observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json["obj"]))
                                        })
                                    }
                                } else {
                                    if let result = json["result"].string, result == "1",
                                        let dictionary = json["dic"].dictionaryObject,
                                        let object =  Mapper<T>().map(JSON: dictionary) {
                                        DispatchQueue.main.async(execute: {
                                            observer.onNext(object)
                                            observer.onCompleted()
                                        })
                                    } else {
                                        DispatchQueue.main.async(execute: {
                                            ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                            observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json["dic"]))
                                        })
                                    }
                                }
                                
                            } else {
                                let object: T = try response.mapObject(T.self)
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                })
                            }
                        } catch {

                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }

                    break
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(USError.networkError(error._code, error.response?.description ?? "网络错误，请稍候重试"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func requestArrayMapper<T: Mappable>(_ token: Target, validate: Bool = false) -> Observable<[T]> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            try self?.validateResponse(response)
                        } catch {
                            DispatchQueue.main.async(execute: {
                                ShareNetwork.doInterceptionNectWorkErrorCode(nil, error: error as? USError, isTrade: validate)
                                observer.onError(error)
                            })
                        }

                        do {
                            if validate {
                                let json = JSON(data: response.data)
                                if let result = json["result"].string, result == "1",
                                    let array = json["obj"].arrayObject as? [[String: Any]],
                                    let objects =  Mapper<T>().mapArray(JSONArray: array) {
                                    DispatchQueue.main.async(execute: {
                                        observer.onNext(objects)
                                        observer.onCompleted()
                                    })
                                } else {
                                    DispatchQueue.main.async(execute: {
                                        ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                        observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json["obj"]))
                                        
                                        // 统一处理错误弹出提示
                                        HUD.toast(json["message"].string ?? "未知错误")
                                        
                                    })
                               }
                            } else {
                                let array: [T] = try response.mapArray(T.self)
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(array)
                                    observer.onCompleted()
                                })
                            }
                        } catch {

                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(USError.networkError(error._code, error.response?.description ?? "网络错误，请稍候重试"))
                        HUD.toast("网络错误，请稍候重试")
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    /// Designated request-making method.
    public func requestAny<T: Any>(_ token: Target, validate: Bool = false) -> Observable<T> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            try self?.validateResponse(response)
                        } catch {
                            DispatchQueue.main.async(execute: {
                                ShareNetwork.doInterceptionNectWorkErrorCode(nil, error: error as? USError, isTrade: validate)
                                observer.onError(error)
                            })
                        }

                        do {
                            if validate {
                                let json = JSON(data: response.data)
                                if let result = json["result"].string, result == "1",
                                    let object: T = json["obj"].object as? T {
                                    DispatchQueue.main.async(execute: {
                                        observer.onNext(object)
                                        observer.onCompleted()
                                    })
                                } else {
                                    DispatchQueue.main.async(execute: {
                                        ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                        observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json["obj"]))
                                    })
                                }
                            } else {
                                let object: T = try response.mapAny()
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                })
                            }

                        } catch {
                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }

                    break
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(USError.networkError(error._code, error.response?.description ?? "网络错误，请稍候重试"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func requestAnyArray<T: Any>(_ token: Target, validate: Bool = false) -> Observable<[T]> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {

                        do {
                            try self?.validateResponse(response)
                        } catch {
                            DispatchQueue.main.async(execute: {
                                ShareNetwork.doInterceptionNectWorkErrorCode(nil, error: error as? USError, isTrade: validate)
                                observer.onError(error)
                            })
                        }

                        do {
                            if validate {
                                let json = JSON(data: response.data)
                                if let result = json["result"].string, result == "1",
                                    let objects: [T] = json["list"].arrayObject as? [T] {
                                    DispatchQueue.main.async(execute: {
                                        observer.onNext(objects)
                                        observer.onCompleted()
                                    })
                                } else {
                                    DispatchQueue.main.async(execute: {
                                        ShareNetwork.doInterceptionNectWorkErrorCode(json, error: nil, isTrade: validate)
                                        observer.onError(USError.responseValidate(json["code"].string ?? "", json["message"].string ?? "", json["list"]))
                                    })
                                }
                            } else {
                                let object: [T] = try response.mapAnyArray()
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                })
                            }

                        } catch {

                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }

                    }

                    break
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(USError.networkError(error._code, error.response?.description ?? "网络错误，请稍候重试"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func validateResponse(_ response: Moya.Response) throws {

        if response.statusCode == 200 { // 200，没有错误
            return
        }

        var errorMsg: ErrorMsg
        do {
            errorMsg = try response.mapObject(ErrorMsg.self)
        } catch {
            // 未能完成操作。（“Moya.Error”错误 1。）就是从这里抛出来的
            throw USError.networkError(error._code, "网络错误，请稍候重试")
        }

        if (errorMsg.msg.characters.count != 0) || (errorMsg.code.characters.count != 0) {
            let json = JSON(data: response.data)
            throw USError.responseValidate(errorMsg.code, errorMsg.msg, json["obj"])
        }
    }
}
