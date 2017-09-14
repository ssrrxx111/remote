//
//  SSTracker.swift
//  Common
//
//  Created by adad184 on 19/06/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public let TRACKER = SSTracker()

public protocol SSTrackEventPoint {

    var category: String {get}
    var action: String {get}
    var label: String {get}
    var property: [AnyHashable: Any] {get}
}


public protocol SSTrackScreenPoint {
    
    var name: String {get}
    var property: [AnyHashable: Any] {get}
}

public protocol SSTrackErrorPoint {
    
    var domain: String {get}
    var code: Int {get}
    var property: [AnyHashable: Any] {get}
    
    func error(with error: NSError?) -> NSError
}

extension SSTrackEventPoint {
    
    public var category: String {
        let className = "\(type(of: self))"
        let prefix = "SSEvent"
        
        if className.hasPrefix(prefix) {
            return (className as NSString).substring(from: prefix.characters.count)
        }
        
        return className
    }
    
    public var label: String {
        return ""
    }
    
    public var property: [AnyHashable: Any] {
        return [:]
    }
}

extension SSTrackScreenPoint {
    
    public var property: [AnyHashable: Any] {
        return [:]
    }
}


extension SSTrackErrorPoint {
    
    
    public var code: Int {
        return 0
    }
    
    public var property: [AnyHashable: Any] {
        return [:]
    }
    
    public func error(with error: NSError? = nil) -> NSError {
        
        let domain = self.domain
        var code = self.code
        var userInfo = self.property
        
        if let error = error {
            userInfo["NSErrorDomain"] = error.domain
            userInfo["NSErorrCode"] = "\(error.code)"
            
            for (key, value) in error.userInfo {
                userInfo[key] = value
            }
            
            code = error.code
        }
        
        return NSError(
            domain: domain,
            code: code,
            userInfo: userInfo
        )
    }
}


extension SSTrackEventPoint where Self: RawRepresentable, Self.RawValue == String {
    
    public var action: String {
        return self.rawValue
    }
}

extension SSTrackScreenPoint where Self: RawRepresentable, Self.RawValue == String {
    
    public var name: String {
        return self.rawValue
    }
}

extension SSTrackErrorPoint where Self: RawRepresentable, Self.RawValue == String {
    
    public var domain: String {
        
        let className = "\(type(of: self))"
        let prefix = "SSError"
        
        var type = className
        
        if className.hasPrefix(prefix) {
            type = "." + (className as NSString).substring(from: prefix.characters.count)
        }
        
        return "Error" + type + ".\(self.rawValue)"
    }
    
}

public protocol SSTrackable {

    func signIn(_ uid: String)

    func signOut()

    func event(_ event: SSTrackEventPoint, property: [AnyHashable: Any])

    func screen(_ screen: SSTrackScreenPoint, property: [AnyHashable: Any])
    
    func error(_ error: NSError, property: [AnyHashable: Any])
}

public class SSTracker {
    
    public let queue = DispatchQueue(label: "com.stocks666.tracker.queue")
    
    public var tracker: SSTrackable? = nil

    fileprivate init() {

    }

    public func signIn(_ uid: String) {
        
        if let tracker = self.tracker {
            self.queue.async {
                tracker.signIn(uid)
            }
        }
    }

    public func signOut() {
        
        if let tracker = self.tracker {
            self.queue.async {
                tracker.signOut()
            }
        }
    }

    public func event(_ event: SSTrackEventPoint, property: [AnyHashable: Any] = [:], _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        if let tracker = self.tracker {
            self.queue.async {
                
                var prop = property
                prop["_TRACK"] = "\(file) | \(function) | \(line)"
                
                tracker.event(event, property: prop)
            }
        }
    }
    
    public func screen(_ screen: SSTrackScreenPoint, property: [AnyHashable: Any] = [:], _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        if let tracker = self.tracker {
            self.queue.async {
                
                var prop = property
                prop["_TRACK"] = "\(file) | \(function) | \(line)"
                
                tracker.screen(screen, property: prop)
            }
        }
    }
    
    public func error(_ error: NSError, property: [AnyHashable: Any] = [:], _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        if let tracker = self.tracker {
            self.queue.async {
                
                var prop = property
                prop["_TRACK"] = "\(file) | \(function) | \(line)"
                
                tracker.error(error, property: prop)
            }
        }
    }
    
    public func error(_ errorPoint: SSTrackErrorPoint, property: [AnyHashable: Any] = [:], _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        self.error(errorPoint.error(), property: property, file, function, line)
    }
}
