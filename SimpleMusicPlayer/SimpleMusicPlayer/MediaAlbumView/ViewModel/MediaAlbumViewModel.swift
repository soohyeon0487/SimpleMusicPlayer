//
//  MediaAlbumViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Combine
import Foundation

class MediaAlbumViewModel {
    init() {
        self.bindEvent()
    }

    // MARK: Output
    @Published var mediaAlbum: MediaAlbum?

    func playButtonTapped() {
        guard let album = self.mediaAlbum else {
            return
        }
        self.playerManager.setPlayList(album.tracks, shuffled: false)
    }

    func randomPlayButtonTapped() {
        guard let album = self.mediaAlbum else {
            return
        }
        self.playerManager.setPlayList(album.tracks, shuffled: true)
    }

    // MARK: Private
    private let playerManager = MediaPlayerManager.shared
    private var cancelBag = Set<AnyCancellable>()

    private func bindEvent() {

    }
}
