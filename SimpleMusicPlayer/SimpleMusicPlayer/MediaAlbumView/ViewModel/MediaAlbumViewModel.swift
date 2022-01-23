//
//  MediaAlbumViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Combine
import Foundation

class MediaAlbumViewModel {
    // MARK: Internal
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

    func cellTapped(row: Int) {
        guard let album = self.mediaAlbum else {
            return
        }
        self.playerManager.setPlayList(
            Array(album.tracks[(row..<album.count)]),
            shuffled: false
        )
    }

    // MARK: Private
    private let playerManager = MediaPlayerManager.shared
    private var cancelBag = Set<AnyCancellable>()
}
