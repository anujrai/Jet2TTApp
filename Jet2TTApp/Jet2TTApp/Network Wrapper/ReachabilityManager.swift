//
//  ReachabilityManager.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 29/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

class ReachabilityManager {
    
    enum ApplicationConnectionMode {
        case unknown
        case online
        case offline
    }
    
    static private(set) var applicationConnectionMode: ApplicationConnectionMode = .unknown
    
    private static var callBack:((Reachability?)->Void)?
    
    private static var reachability: Reachability = {
        let reachability = Reachability()!
        return reachability
    }()
    
    class var isConnected: Bool {
        return self.reachability.connection != .none
    }
    
    class func updateApplicationConnectionStatus() {
        self.applicationConnectionMode = self.isConnected ? .online : .offline
    }
    
    class func registerToMonitorNetworkChange(withCallBack callBack: ((Reachability?)->Void)?) {
        
        self.callBack = callBack
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try self.reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    @objc class func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular, .wifi:
            self.callBack?(reachability)
        default:
            print("still not connected...")
        }
    }
    
    class func deregisterToMonitorNetworkChange() {
        self.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
