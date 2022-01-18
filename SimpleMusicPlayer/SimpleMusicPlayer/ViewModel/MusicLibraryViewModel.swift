//
//  MusicLibraryViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Combine
import Foundation

class MusicLibraryViewModel {
    init() {
        self.bindEvent()
    }

    // MARK: Output
    let authorizationState = CurrentValueSubject<Bool?, Never>(nil)
    let mediaAlbumInfos = CurrentValueSubject<[MediaAlbumInfo], Never>([])

    // MARK: Internal
    func viewDidLoad() {
        self.mediaPlayerManager.requestAuthorization()
            .sink { [weak self] state in
                self?.authorizationState.send(state)
            }
            .store(in: &cancelBag)
    }

    // MARK: Private
    private var cancelBag = Set<AnyCancellable>()
    
    private let mediaPlayerManager = MediaPlayerManager.shared

    private func bindEvent() {
        self.authorizationState
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.fetchMediaQueryItems()
            }
            .store(in: &cancelBag)
    }

    private func fetchMediaQueryItems() {
        let items = self.mediaPlayerManager.fetchMediaQueryItems()
        print("items", items.count)
    }
}
