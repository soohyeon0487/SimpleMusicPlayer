//
//  MediaLibraryViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Combine
import Foundation

class MediaLibraryViewModel {
    init() {
        self.bindEvent()
    }

    // MARK: Output
    let authorizationState = CurrentValueSubject<Bool?, Never>(nil)
    let mediaLibrary = CurrentValueSubject<MediaLibrary?, Never>(nil)

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
        let mediaLibrary = MediaLibrary()
        let items = self.mediaPlayerManager.fetchMediaQueryItems()
        for item in items {
            mediaLibrary.add(track: item)
        }
        self.mediaLibrary.send(mediaLibrary)
    }
}