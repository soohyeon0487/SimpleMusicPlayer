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
        self.bindEvent()
    }

    // MARK: Output
    @Published var nowPlayingItem: MPMediaItem?
    @Published var currentPlaybackTime: TimeInterval = 0
    @Published var playbackDuration: TimeInterval = 0
    @Published var isPlaying: MPMusicPlaybackState = .stopped
    @Published var repeatMode: RepeatMode = .none
    @Published var shuffleMode: ShuffleMode = .off

    // MARK: Internal
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
    private let playerManager = MediaPlayerManager.shared
    private var cancelBag = Set<AnyCancellable>()

    private func bindEvent() {
        self.playerManager.$nowPlayingItem
            .removeDuplicates()
            .assign(to: \.nowPlayingItem, on: self)
            .store(in: &self.cancelBag)
        self.playerManager.$currentPlaybackTime
            .assign(to: \.currentPlaybackTime, on: self)
            .store(in: &self.cancelBag)
        self.playerManager.$playbackDuration
            .removeDuplicates()
            .assign(to: \.playbackDuration, on: self)
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
    }
}
