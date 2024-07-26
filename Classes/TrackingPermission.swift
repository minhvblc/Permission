//
//  TrackingPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 11/01/2024.
//

import Foundation
import AppTrackingTransparency


class TrackingPermission: AppPermissionProtocol {
        
    var _status: ATTrackingManager.AuthorizationStatus = ATTrackingManager.trackingAuthorizationStatus
    
    func status() async -> ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }
    
    func requestPermission() async -> ATTrackingManager.AuthorizationStatus {
        print("TRACKING ATT", ATTrackingManager.trackingAuthorizationStatus == .notDetermined)
        self._status = await ATTrackingManager.requestTrackingAuthorization()
        if _status == .authorized {
            AppPermission.permissionAccept.send(())
        }
        return _status
    }
}
