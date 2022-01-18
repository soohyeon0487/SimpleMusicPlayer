//
//  MediaPlayerManager.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Combine
import Foundation
import MediaPlayer
import StoreKit

enum MediaPlayerError: Error {
    case permissionDenied
}

class MediaPlayerManager {
    // MARK: Singleton
    static let shared = MediaPlayerManager()
    private init() {}
    // MARK: Internal
    func requestAuthorization() -> Future<Bool?, Never> {
        return Future { promise in
            SKCloudServiceController.requestAuthorization { state in
                switch state {
                case .notDetermined:
                    promise(Result.success(nil))
                case .authorized:
                    promise(Result.success(true))
                default:
                    promise(Result.success(false))
                }
            }
        }
    }

    func fetchMediaQueryItems() -> [MPMediaItem] {
        return MPMediaQuery.songs().items ?? []
    }
    // MARK: Private
}
