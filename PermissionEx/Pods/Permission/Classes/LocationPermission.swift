//
//  LocationPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 15/01/2024.
//

import Foundation
import CoreLocation


public class LocationPermission: NSObject, AppPermissionProtocol, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    private var isRequested = false
    
    public lazy var _status = manager.authorizationStatus
    
    private
    var callbackLocation: ((CLAuthorizationStatus) -> Void)?
    
    public func status() async -> CLAuthorizationStatus {
        manager.authorizationStatus
    }
    
    public func requestPermission() async -> CLAuthorizationStatus {
        guard !isRequested else { return _status }
        isRequested = true
        manager.delegate = self
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else {
                continuation.resume(returning: CLLocationManager.authorizationStatus())
                return
            }
            self.callbackLocation = { status in
                if status == .authorizedAlways || status == .authorizedWhenInUse {
                    AppPermission.permissionAccept.send(())
                }
                continuation.resume(returning: status)
            }
            DispatchQueue.main.async {
                self.manager.requestWhenInUseAuthorization()
            }
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        _status = manager.authorizationStatus
        callbackLocation?(_status)
        callbackLocation = nil
    }
}
