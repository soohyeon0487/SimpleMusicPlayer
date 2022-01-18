//
//  MediaPlayerManager.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Foundation
import MediaPlayer
import StoreKit

class MediaPlayerManager {
    // MARK: Singleton
    static let shared = MediaPlayerManager()
    private init() {}
    // MARK: Internal
    func requestAuthorization() {

    }
    // MARK: Private
    private func fetchMediaQueryItems() -> [MPMediaItem] {
        return []
    }
}
