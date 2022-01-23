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
        self.bindEvent()
    }

    // MARK: Internal
    @Published var nowPlayingItem: MPMediaItem?
    @Published var currentPlaybackTime: TimeInterval = 0
    @Published var playbackDuration: TimeInterval = 0
    @Published var isPlaying: MPMusicPlaybackState = .stopped
    @Published var repeatMode: RepeatMode = .none
    @Published var shuffleMode: ShuffleMode = .off

    // 음악 목록을 받으면 player Queue에 적용
    func setPlayList(_ queue: [MPMediaItem], shuffled: Bool) {
        self.player.setQueue(with: MPMediaItemCollection(items: queue))
        self.applyShuffleMode(mode: shuffled ? .songs : .off)
        self.play()
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

    // MARK: Class Property
    private var cancelBag = Set<AnyCancellable>()
    private var connectedTimer: Cancellable?

    // TODO: Timer ViewModel로 옮기기
    private var timer = Timer.publish(every: 1, tolerance: 0.2, on: .main, in: .common)

    private let player = MPMusicPlayerController.systemMusicPlayer

    // MARK: Class Method
    private func syncMediaPlayer() {
        self.syncNowPlayingItem()
        self.syncPlayBackState()
        self.syncTimerState()
    }

    private func syncNowPlayingItem() {
        self.nowPlayingItem = self.player.nowPlayingItem
    }

    private func syncPlayBackState() {
        self.isPlaying = self.player.playbackState
    }

    private func syncTimerState() {
        if self.player.playbackState == .playing {
            self.startTimer()
        } else {
            self.connectedTimer?.cancel()
        }
    }

    private func applyRepeatMode(mode: RepeatMode) {
        self.player.repeatMode = .init(rawValue: mode.rawValue) ?? .none
        self.repeatMode = mode
    }

    private func applyShuffleMode(mode: ShuffleMode) {
        self.player.shuffleMode = .init(rawValue: mode.rawValue) ?? .off
        self.shuffleMode = mode
    }

    private func startTimer() {
        self.connectedTimer = Timer.publish(every: 1, tolerance: 0.2, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let currentPlaybackTime = self?.player.currentPlaybackTime,
                      let playbackDuration = self?.player.nowPlayingItem?.playbackDuration
                else {
                    return
                }
                self?.currentPlaybackTime = currentPlaybackTime
                self?.playbackDuration = playbackDuration
            }
    }

    private func bindEvent() {
        self.bindInAppNotification()
        self.bindSystemNotification()
    }

    private func bindInAppNotification() {
        NotificationCenter.default.publisher(
            for: .MPMusicPlayerControllerNowPlayingItemDidChange,
               object: nil
        )
            .sink { [weak self] _ in
                self?.syncMediaPlayer()
            }
            .store(in: &self.cancelBag)
    }

    private func bindSystemNotification() {
//        NotificationCenter.default.publisher(
//            for: .volumeChanged,
//               object: nil
//        )
//            .sink { value in
//                print(value.userInfo)
//            }
//            .store(in: &self.cancelBag)
        // MPPlayer의 재생 상태가 바뀌면 반영
        NotificationCenter.default.publisher(
            for: .MPMusicPlayerControllerPlaybackStateDidChange,
               object: nil
        )
            .sink { [weak self] _ in
                self?.syncPlayBackState()
                self?.syncTimerState()
            }
            .store(in: &self.cancelBag)
    }
}
