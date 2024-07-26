//
//  NotificationPermission.swift
//  CastAppPermission
//
//  Created by Zoro4rk on 31/03/2024.
//

import Foundation
import UserNotifications


class NotificationPermission: AppPermissionProtocol {
    
    func status() async -> UNAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }
    
    func requestPermission() async -> UNAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        continuation.resume(returning: settings.authorizationStatus)
                    }
                }
            }
        }
    }
}
