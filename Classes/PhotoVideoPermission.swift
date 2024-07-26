//
//  PhotoVideoPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 11/01/2024.
//

import Foundation
import Photos

class PhotoVideoPermission: AppPermissionProtocol {
        
    var _status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    func status() async -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPermission() async -> PHAuthorizationStatus {
        _status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        if _status == .authorized || _status == .limited {
            AppPermission.permissionAccept.send(())
        }
        return _status
    }
}
