//
//  RecordPermission.swift
//  AppPermission
//
//  Created by Zoro4rk on 11/01/2024.
//

import Foundation
import AVFoundation


class RecordPermission: AppPermissionProtocol {
    
    var _status: AVAudioSession.RecordPermission = AVAudioSession.sharedInstance().recordPermission
    
    func status() async -> AVAudioSession.RecordPermission {
        AVAudioSession.sharedInstance().recordPermission
    }
    
    
    func requestPermission() async -> AVAudioSession.RecordPermission {
        _status = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                if granted {
                    AppPermission.permissionAccept.send(())
                }
                continuation.resume(returning: AVAudioSession.sharedInstance().recordPermission)
            })
        }
        return _status
    }
}
