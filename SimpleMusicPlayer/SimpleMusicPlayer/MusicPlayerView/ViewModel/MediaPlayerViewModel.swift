//
//  MediaPlayerViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Combine
import Foundation

import MediaPlayer

class MediaPlayerViewModel {
    init() {
        self.assignValues()
        self.bindEvent()
        self.addNotificationObserver()
    }

    // MARK: Internal
    @Published var nowPlayingItem: MPMediaItem?
    @Published var currentPlaybackTime: TimeInterval = 0
    @Published var extraPlaybackTime: TimeInterval = 0
    @Published var playbackProgress: Float = 0
    @Published var isPlaying: MPMusicPlaybackState = .stopped
    @Published var repeatMode: RepeatMode = .none
    @Published var shuffleMode: ShuffleMode = .off

    func repeatModeButtonTapped() {
        self.playerManager.nextRepeatMode()
    }

    func backwardButtonTapped() {
        self.playerManager.backward()
    }

    func playingButtonTapped() {
        if self.isPlaying == .playing {
            self.playerManager.pause()
        } else {
            self.playerManager.play()
        }
    }

    func forwardButtonTapped() {
        self.playerManager.forward()
    }

    func shuffleModeButtonTapped() {
        self.playerManager.nextShuffleMode()
    }

    // MARK: Private
    @Published private var playbackDuration: TimeInterval = 0

    private let playerManager = MediaPlayerManager.shared

    private var cancelBag = Set<AnyCancellable>()
    private var connectedTimer: Cancellable?
    private var timer = Timer.publish(every: 1, tolerance: 0.2, on: .main, in: .common)

    private func assignValues() {
        self.playerManager.$nowPlayingItem
            .removeDuplicates()
            .assign(to: \.nowPlayingItem, on: self)
            .store(in: &self.cancelBag)
        self.playerManager.$isPlaying
            .removeDuplicates()
            .assign(to: \.isPlaying, on: self)
            .store(in: &self.cancelBag)
        self.playerManager.$repeatMode
            .removeDuplicates()
            .assign(to: \.repeatMode, on: self)
            .store(in: &self.cancelBag)
        self.playerManager.$shuffleMode
            .removeDuplicates()
            .assign(to: \.shuffleMode, on: self)
            .store(in: &self.cancelBag)
        let playbackValues =  self.$currentPlaybackTime
            .combineLatest(self.$playbackDuration)
            .filter { $0 < $1 }
        playbackValues
            .map { Float($0 / $1) }
            .assign(to: \.self.playbackProgress, on: self)
            .store(in: &self.cancelBag)
        playbackValues
            .map { $1 - $0 }
            .assign(to: \.self.extraPlaybackTime, on: self)
            .store(in: &self.cancelBag)
    }

    private func bindEvent() {
        self.$isPlaying
            .sink { [weak self] state in
                if state == .playing {
                    self?.restartTimer()
                } else {
                    self?.connectedTimer?.cancel()
                }
            }
            .store(in: &self.cancelBag)
    }

    private func addNotificationObserver() {
        // 앱이 다시 Foreground에 돌아 왔을 때 Player 동기화
        NotificationCenter.default.publisher(
            for: .syncSystemPlayerMode,
               object: nil
        )
            .sink { [weak self] _ in
                self?.playerManager.syncPlayerMode()
            }
            .store(in: &self.cancelBag)
        // Player의 재생 item이 바뀌면 반영
        NotificationCenter.default.publisher(
            for: .MPMusicPlayerControllerNowPlayingItemDidChange,
               object: nil
        )
            .sink { [weak self] _ in
                self?.playerManager.syncNowPlayingItem()
                self?.playerManager.syncPlayBackState()
            }
            .store(in: &self.cancelBag)
        // Player의 재생 상태가 바뀌면 반영
        NotificationCenter.default.publisher(
            for: .MPMusicPlayerControllerPlaybackStateDidChange,
               object: nil
        )
            .sink { [weak self] _ in
                self?.playerManager.syncPlayBackState()
            }
            .store(in: &self.cancelBag)
    }

    private func restartTimer() {
        self.connectedTimer = Timer.publish(every: 1, tolerance: 0.2, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let currentPlaybackTime = self?.playerManager.getCurrentPlaybackTime(),
                      let playbackDuration = self?.playerManager.getPlaybackDuration()
                else {
                    return
                }
                self?.currentPlaybackTime = currentPlaybackTime
                self?.playbackDuration = playbackDuration
            }
    }
}
