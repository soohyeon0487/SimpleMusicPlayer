//
//  NotificationName+Extension.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Foundation

extension Notification.Name {
    static let setPlayList = Notification.Name("Media.SetPlayList")
    static let mediaPlay = Notification.Name("Media.Play")
    static let mediaPause = Notification.Name("Media.Pause")
    static let volumeChanged = NSNotification.Name(
        rawValue: "AVSystemController_SystemVolumeDidChangeNotification"
    )
}
