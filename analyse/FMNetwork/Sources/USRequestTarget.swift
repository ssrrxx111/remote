//
//  USRequestTarget.swift
//  FMNetwork
//
//  Created by adad184 on 09/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Moya
import RxSwift

public struct USRequest {

    public var host: USHost = .zhuzhuxia
    public var path: String = ""
    public var method: Moya.Method = .get
    public var parameterEncoding: ParameterEncoding = JSONEncoding.default
    public var parameters: [String: Any]? = nil
    public var task: Task = Task.request
    public var sampleData: Data = Data()
    public var validate: Bool = false

    public init(host: USHost,
         path: String,
         method: Moya.Method = .get,
         parameterEncoding: ParameterEncoding = JSONEncoding.default,
         parameters: [String: Any]? = nil,
         task: Task = Task.request,
         sampleData: Data = Data(),
         validate: Bool = false
        ) {
        self.host = host
        self.path = path
        self.method = method
        self.parameterEncoding = parameterEncoding
        self.parameters = parameters
        self.task = task
        self.sampleData = sampleData
        self.validate = validate
    }

    public var baseURL: URL {
        return URL(string: self.host.baseURL)!
    }
}

public protocol USTargetType: TargetType {
    var request : USRequest {get}
}

extension USTargetType {

    public var path: String {
        return self.request.path
    }

    public var baseURL: URL {

        return self.request.baseURL
    }

    public var method: Moya.Method {
        return self.request.method
    }

    public var parameters: [String: Any]? {
        return self.request.parameters
    }

    public var parameterEncoding: ParameterEncoding {
        return self.request.parameterEncoding
    }

    public var sampleData: Data {
        return self.request.sampleData
    }

    public var task: Task {
        return self.request.task
    }

    public var validate: Bool {
        return self.request.validate
    }
}

open class USRequestTarget: TargetType {

    public static var baseAdjustHandler: ((_ url: URL) -> (URL))? = nil

    private(set) var api: USTargetType

    public init(_ api: USTargetType) {
        self.api = api
    }

    open var path: String {
        return self.api.path
    }

    open var baseURL: URL {

        return self.api.baseURL
    }

    open var method: Moya.Method {
        return self.api.method
    }

    open var parameters: [String: Any]? {
        return self.api.parameters
    }

    public var parameterEncoding: ParameterEncoding {
        return self.api.parameterEncoding
    }

    open var sampleData: Data {
        return self.api.sampleData
    }
    
    open var task: Task {
        return self.api.task
    }

    open var validate: Bool {
        return self.api.validate
    }
}
