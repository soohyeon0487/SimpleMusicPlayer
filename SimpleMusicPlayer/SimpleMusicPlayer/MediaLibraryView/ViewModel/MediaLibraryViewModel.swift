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
        self.addNotificationObserver()
    }

    // MARK: Internal
    @Published var authorizationState: Bool?
    @Published var mediaLibrary: MediaLibrary?

    func viewDidLoad() {
        self.requestAuthorization()
    }

    // MARK: Private
    private var cancelBag = Set<AnyCancellable>()
    
    private let mediaPlayerManager = MediaFetchManager.shared

    private func bindEvent() {
        self.$authorizationState
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.fetchMediaQueryItems()
            }
            .store(in: &cancelBag)
    }

    private func addNotificationObserver() {
        // 앱이 foreground로 돌아왔을 경우, 권한 재확인 및 Library 목록 갱신
        NotificationCenter.default.publisher(for: .checkAuthorization, object: nil)
            .sink { [weak self] _ in
                self?.requestAuthorization()
            }
            .store(in: &self.cancelBag)
    }

    private func requestAuthorization() {
        self.mediaPlayerManager.requestAuthorization()
            .sink { [weak self] state in
                self?.authorizationState = state
            }
            .store(in: &cancelBag)
    }

    private func fetchMediaQueryItems() {
        let newMediaLibrary = MediaLibrary()
        let items = self.mediaPlayerManager.fetchMediaQueryItems()
        for item in items {
            newMediaLibrary.add(track: item)
        }
        self.mediaLibrary = newMediaLibrary
    }
}
