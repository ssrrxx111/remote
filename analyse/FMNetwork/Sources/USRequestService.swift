//
//  USRequestService.swift
//  FMNetwork
//
//  Created by adad184 on 09/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Common
import Moya
import RxSwift
import Alamofire
import enum Result.Result

public let SharedRequest = USRequestService()

public class USRequestService: NSObject {
    
    public var header: [String: String] = [:]

    public private(set) var `default`: RxMoyaProvider<USRequestTarget> = RxMoyaProvider<USRequestTarget>(
        endpointClosure: USRequestService.endpointClosure,
        requestClosure: USRequestService.requestClosure(10),
        manager: USRequestService.NormalMananger,
        plugins: []
    )

    public private(set) var long: RxMoyaProvider<USRequestTarget> = RxMoyaProvider<USRequestTarget>(
        endpointClosure: USRequestService.endpointClosure,
        requestClosure: USRequestService.requestClosure(60),
        manager: USRequestService.NormalMananger,
        plugins: []
    )

    public var needSSLPinning: Bool = false {
        didSet {
            self.default = RxMoyaProvider<USRequestTarget>(
                endpointClosure: USRequestService.endpointClosure,
                requestClosure: USRequestService.requestClosure(10),
                manager: self.needSSLPinning ? USRequestService.SSLPinningManager : USRequestService.NormalMananger,
                plugins: []
            )

            self.long = RxMoyaProvider<USRequestTarget>(
                endpointClosure: USRequestService.endpointClosure,
                requestClosure: USRequestService.requestClosure(60),
                manager: self.needSSLPinning ? USRequestService.SSLPinningManager : USRequestService.NormalMananger,
                plugins: []
            )
        }
    }

    private static let SSLPinningpolicy = ServerTrustPolicy.pinPublicKeys(
        publicKeys: ServerTrustPolicy.publicKeys(in: Bundle(for: FMNetwork.self)),
        validateCertificateChain: false,
        validateHost: false
    )

    private static let SSLPinningPolicies = WildcardServerTrustPolicyManager(policies: [
        "*": USRequestService.SSLPinningpolicy,
//        ".webull.com": USRequestService.SSLPinningpolicy,
//        ".webulltrade.com": USRequestService.SSLPinningpolicy,
        ]
    )

    private static let NormalPinningPolicies = WildcardServerTrustPolicyManager(policies: [
        "*": ServerTrustPolicy.disableEvaluation,
//        ".webull.com": ServerTrustPolicy.disableEvaluation,
//        ".webulltrade.com": ServerTrustPolicy.disableEvaluation,
//        ".webulltest.com": ServerTrustPolicy.disableEvaluation,
//        ".webulltradetest.com": ServerTrustPolicy.disableEvaluation,
        ]
    )

    private static var sessionConfiguration: URLSessionConfiguration {
        let cfg = URLSessionConfiguration.default
//        cfg.protocolClasses = [USURLProtocol.classForCoder()]

        return cfg
    }

    private static let SSLPinningManager = Manager(
        configuration: USRequestService.sessionConfiguration,
        serverTrustPolicyManager: USRequestService.SSLPinningPolicies
    )

    private static let NormalMananger = Manager(
        configuration: USRequestService.sessionConfiguration,
        serverTrustPolicyManager: USRequestService.NormalPinningPolicies
    )

    private static let endpointClosure = { (target: USRequestTarget) -> Moya.Endpoint<USRequestTarget> in

        let url = target.baseURL.appendingPathComponent(target.path).absoluteString

//        NSLog("\(url)")

        var header = SharedRequest.header

        let endpoint = Moya.Endpoint<USRequestTarget>(
            url: url,
            sampleResponseClosure: {
                .networkResponse(200, target.sampleData)
            },
            method: target.method,
            parameters: target.parameters,
            parameterEncoding: target.parameterEncoding,
            httpHeaderFields: header)

        return endpoint
    }

    private static let requestClosure = { (_ timeout: TimeInterval) -> ((Endpoint<USRequestTarget>, @escaping RxMoyaProvider<USRequestTarget>.RequestResultClosure) -> Void) in

        let closure = { (endpoint: Moya.Endpoint<USRequestTarget>, done: RxMoyaProvider<USRequestTarget>.RequestResultClosure) in

            if let request = endpoint.urlRequest {

                let r = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest

                r.timeoutInterval = timeout

                done(Result<URLRequest, Moya.MoyaError>.success(r as URLRequest))
            } else {
                done(Result<URLRequest, Moya.MoyaError>.failure(MoyaError.requestMapping(endpoint.url)))
            }
        }

        return closure
    }

    fileprivate override init() {
        super.init()
    }
    
    private func setup() {
        
    }
}
