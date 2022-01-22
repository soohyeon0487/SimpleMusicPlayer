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
    @Published var currentPlayBackRate: TimeInterval = 0
    @Published var isPlaying: MPMusicPlaybackState = .stopped

    // 음악 목록을 받으면 player Queue에 적용
    func setPlayList(_ queue: [MPMediaItem], shuffled: Bool) {
        self.player.setQueue(with: MPMediaItemCollection(items: queue))
        self.player.shuffleMode = shuffled ? .songs : .off
        self.player.repeatMode = .all
        self.play()
    }

    func play() {
        guard self.player.nowPlayingItem != nil else {
            return
        }
        self.player.prepareToPlay { [weak self] error in
            if let error = error as? MPError {
                print(error)
            } else {
                self?.player.play()
            }
        }
    }

    func pause() {
        self.player.pause()
    }

    // MARK: Class Property
    private var cancelBag = Set<AnyCancellable>()
    private var connectedTimer: Cancellable?
    private var timer = Timer.publish(every: 1, on: .main, in: .common)

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

    private func startTimer() {
        self.connectedTimer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let currentTime = self?.player.currentPlaybackTime,
                      let total = self?.player.nowPlayingItem?.playbackDuration
                else {
                    return
                }
                self?.currentPlayBackRate = currentTime / total
            }
    }

    private func bindEvent() {
        self.bindInAppEvent()
        self.bindInAppNotification()
        self.bindSystemNotification()
    }

    private func bindInAppEvent() {

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
