//
//  MusicLibraryViewModel.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Combine
import Foundation

class MusicLibraryViewModel {
    // MARK: Output
    let mediaAlbumInfos = CurrentValueSubject<[MediaAlbumInfo], Never>([])
    // MARK: Internal
    func viewDidLoad() {

    }
    // MARK: Private
    private func requestAuthorization() {
        
    }
}
