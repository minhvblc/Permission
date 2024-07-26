//
//  AppPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 11/01/2024.
//

import AppTrackingTransparency
import Photos
import Speech
import AVFoundation
import CoreLocation
import EventKit
import Combine
import UserNotifications


public protocol AppPermissionProtocol<AuthorizationStatus> {
    associatedtype AuthorizationStatus
    
    func status() async -> AuthorizationStatus
    
    @discardableResult
    func requestPermission() async -> AuthorizationStatus
}

public struct AppPermission {
    
    public static let permissionAccept = PassthroughSubject<Void, Never>()
    
    private static let trackingPermission = TrackingPermission()
    private static let photoPermission    = PhotoVideoPermission()
    private static let recordPermission   = RecordPermission()
    private static let speechPermission   = SpeechPermission()
    private static let networkPermission  = NetworkPermission()
    private static let locationPermission  = LocationPermission()
    private static let notificationPermission = NotificationPermission()
    
    
    public static func tracking() -> any AppPermissionProtocol<ATTrackingManager.AuthorizationStatus> {
        return trackingPermission
    }
    
    public static func photoVideo() -> any AppPermissionProtocol<PHAuthorizationStatus> {
        return photoPermission
    }
    
    public static func record() -> any AppPermissionProtocol<AVAudioSession.RecordPermission> {
        return recordPermission
    }
    
    public static func speech() -> any AppPermissionProtocol<SFSpeechRecognizerAuthorizationStatus> {
        return speechPermission
    }
    
    public static func network() -> any AppPermissionProtocol<Bool> {
        return networkPermission
    }
    
    public static func location() -> any AppPermissionProtocol<CLAuthorizationStatus> {
        return locationPermission
    }
    
    public static func notification() -> any AppPermissionProtocol<UNAuthorizationStatus> {
        return notificationPermission
    }
}


