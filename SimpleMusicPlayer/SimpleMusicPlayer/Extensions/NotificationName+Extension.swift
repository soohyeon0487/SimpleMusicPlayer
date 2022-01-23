//
//  NotificationName+Extension.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Foundation

extension Notification.Name {
    static let checkAuthorization = Notification.Name("Media.CheckAuthorization")
    static let authorizationChanged = Notification.Name("Media.AuthorizationChanged")
    static let syncSystemPlayerMode = Notification.Name("Media.SyncSystemPlayer")
    static let volumeChanged = NSNotification.Name(
        "AVSystemController_SystemVolumeDidChangeNotification"
    )
}
