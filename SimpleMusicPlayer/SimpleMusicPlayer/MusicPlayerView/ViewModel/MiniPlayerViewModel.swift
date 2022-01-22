//
//  MiniPlayerViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Combine
import Foundation

import MediaPlayer

class MiniPlayerViewModel {
    init() {
        self.bindEvent()
    }

    // MARK: Output
    @Published var currentPlayTrack: MPMediaItem?
    @Published var isPlaying: MPMusicPlaybackState = .stopped

    // MARK: Internal
    func playingButtonTapped() {
        if self.isPlaying == .playing {
            self.playerManager.pause()
        } else {
            self.playerManager.play()
        }
    }

    // MARK: Private
    private let playerManager = MediaPlayerManager.shared
    private var cancelBag = Set<AnyCancellable>()

    private func bindEvent() {
        self.playerManager.$currentPlayTrack
            .assign(to: \.currentPlayTrack, on: self)
            .store(in: &self.cancelBag)
        self.playerManager.$isPlaying
            .assign(to: \.isPlaying, on: self)
            .store(in: &self.cancelBag)
    }
}
