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

    // MARK: Internal
    func viewDidLoad() {

    }

    func playButtonTapped() {
        guard let album = self.mediaAlbum else {
            return
        }
        print(album.tracks)
    }

    func randomPlayButtonTapped() {
        guard let album = self.mediaAlbum else {
            return
        }
        print(album.tracks.shuffled())
    }

    // MARK: Private
    private var cancelBag = Set<AnyCancellable>()

    private func bindEvent() {

    }
}
