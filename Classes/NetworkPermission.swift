//
//  NetworkPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 11/01/2024.
//

import Foundation
import Network

private
extension UserDefaults {
    var networkPermissionStatus: Bool {
        get { UserDefaults.standard.bool(forKey: "networkPermissionStatus" )}
        set { UserDefaults.standard.set(newValue, forKey: "networkPermissionStatus" )}
    }
    
    var localNetWorkIsDetermined: Bool {
        get { UserDefaults.standard.bool(forKey: "localNetWorkIsDetermined" )}
        set { UserDefaults.standard.set(newValue, forKey: "localNetWorkIsDetermined" )}
    }
    
}

public
extension UserDefaults {
    var currentSessionLocalNetWorkIsDetermined: Bool {
        get { UserDefaults.standard.bool(forKey: "currentSessionLocalNetWorkIsDetermined" )}
        set { UserDefaults.standard.set(newValue, forKey: "currentSessionLocalNetWorkIsDetermined" )}
    }
}

class NetworkPermission: AppPermissionProtocol {
  
    var _status: Bool = UserDefaults.standard.networkPermissionStatus
    
    func status() async -> Bool {
        _status
    }
    
    init() {
        UserDefaults.standard.currentSessionLocalNetWorkIsDetermined = UserDefaults.standard.localNetWorkIsDetermined
    }
        
    func requestPermission() async -> Bool {
        self._status = await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                LocalNetworkAuthorization().requestAuthorization { granted in
                    UserDefaults.standard.localNetWorkIsDetermined = true
                    if granted {
                        AppPermission.permissionAccept.send(())
                    }
                    continuation.resume(returning: granted)
                }
            }
        }
        UserDefaults.standard.networkPermissionStatus = _status
        return _status
    }
    
}


private class LocalNetworkAuthorization: NSObject {
    
    deinit {
        print("LocalNetworkAuthorization DEINIT")
    }
    
    private var browser: NWBrowser?
    private var netService: NetService?
    private var completion: ((Bool) -> Void)?
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        // Create parameters, and allow browsing over peer-to-peer link.
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        // Browse for a custom service type.
        let browser = NWBrowser(for: .bonjour(type: "_bonjour._tcp", domain: nil), using: parameters)
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                print(error.localizedDescription)
            case .ready, .cancelled:
                break
            case let .waiting(error):
                print("Local network permission has been denied: \(error)")
                self.reset()
                self.completion?(false)
            default:
                break
            }
        }
        
        self.netService = NetService(domain: "local.", type:"_lnp._tcp.", name: "LocalNetworkPrivacy", port: 1100)
        self.netService?.delegate = self
        
        self.browser?.start(queue: .main)
        self.netService?.publish()
    }
    
    private func reset() {
        self.browser?.cancel()
        self.browser = nil
        self.netService?.stop()
        self.netService = nil
    }
}

@available(iOS 14.0, *)
extension LocalNetworkAuthorization : NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
        self.reset()
        print("Local network permission has been granted")
        completion?(true)
    }
}
