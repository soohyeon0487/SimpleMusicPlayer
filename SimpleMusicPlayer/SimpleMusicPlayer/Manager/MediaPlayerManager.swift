//
//  AudioPlayerManager.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Combine
import Foundation
import MediaPlayer

enum MediaValueKey: String {
    case playList
}

class MediaPlayerManager {
    // MARK: Singleton
    static let shared = MediaPlayerManager()
    private init() {
        self.syncMediaPlayer()
    }

    // MARK: Internal
    @Published var nowPlayingItem: MPMediaItem?
    @Published var isPlaying: MPMusicPlaybackState = .stopped
    @Published var repeatMode: RepeatMode = .none
    @Published var shuffleMode: ShuffleMode = .off

    // 음악 목록을 받으면 player Queue에 적용
    func setPlayList(_ queue: [MPMediaItem], shuffled: Bool) {
        self.player.setQueue(with: MPMediaItemCollection(items: queue))
        self.applyShuffleMode(mode: shuffled ? .songs : .off)
        self.play()
    }

    func getCurrentPlaybackTime() -> TimeInterval {
        return self.player.currentPlaybackTime
    }

    func getPlaybackDuration() -> TimeInterval {
        return self.player.nowPlayingItem?.playbackDuration ?? 0
    }

    func nextRepeatMode() {
        self.applyRepeatMode(mode: self.repeatMode.getNextMode() ?? .none)
    }

    func backward() {
        self.player.skipToPreviousItem()
    }

    func play() {
        guard self.player.nowPlayingItem != nil else {
            return
        }
        self.player.prepareToPlay()
        self.player.play()
    }

    func pause() {
        self.player.pause()
    }

    func forward() {
        self.player.skipToNextItem()
    }

    func nextShuffleMode() {
        self.applyShuffleMode(mode: self.shuffleMode.getNextMode() ?? .off)
    }

    func syncNowPlayingItem() {
        self.nowPlayingItem = self.player.nowPlayingItem
    }

    func syncPlayBackState() {
        self.isPlaying = self.player.playbackState
    }

    func syncPlayerMode() {
        self.repeatMode = .init(rawValue: self.player.repeatMode.rawValue) ?? .none
        self.shuffleMode = .init(rawValue: self.player.shuffleMode.rawValue) ?? .off
    }

    // MARK: Private
    private let player = MPMusicPlayerController.systemMusicPlayer

    private var cancelBag = Set<AnyCancellable>()

    private func syncMediaPlayer() {
        self.syncNowPlayingItem()
        self.syncPlayBackState()
        self.syncPlayerMode()
    }

    private func applyRepeatMode(mode: RepeatMode) {
        self.player.repeatMode = .init(rawValue: mode.rawValue) ?? .none
        self.repeatMode = mode
    }

    private func applyShuffleMode(mode: ShuffleMode) {
        self.player.shuffleMode = .init(rawValue: mode.rawValue) ?? .off
        self.shuffleMode = mode
    }
}
