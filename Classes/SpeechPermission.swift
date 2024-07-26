//
//  SpeechPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 11/01/2024.
//

import Foundation
import Speech


class SpeechPermission: AppPermissionProtocol {
    
    var _status: SFSpeechRecognizerAuthorizationStatus = SFSpeechRecognizer.authorizationStatus()
    
    func status() async -> SFSpeechRecognizerAuthorizationStatus {
        SFSpeechRecognizer.authorizationStatus()
    }
    
    func requestPermission() async -> SFSpeechRecognizerAuthorizationStatus {
        self._status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                if status == .authorized {
                    AppPermission.permissionAccept.send(())
                }
                continuation.resume(returning: status)
            }
        }
        return _status
    }
}
