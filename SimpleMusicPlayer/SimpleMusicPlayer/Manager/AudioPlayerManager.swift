//
//  AudioPlayerManager.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import AVFoundation
import Foundation

class AudioPlayerManager {
    // MARK: Singleton
    static let shared = AudioPlayerManager()
    private init() {}
    // MARK: Internal
    func isPlaying() -> Bool {
        return true
    }

    func ready() -> Bool {
        return true
    }

    func play() -> Bool {
        return true
    }

    func pause() -> Bool {
        return true
    }
    // MARK: Private
}
