//
//  MediaAlbum.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Foundation
import MediaPlayer

struct MediaAlbum: Hashable {
    init(
        title: String,
        artwork: MPMediaItemArtwork?,
        artist: String,
        releaseDate: Date
    ) {
        self.title = title
        self.artwork = artwork
        self.artist = artist
        self.releaseDate = releaseDate
    }

    static func == (lhs: MediaAlbum, rhs: MediaAlbum) -> Bool {
        return lhs.title == rhs.title
    }

    // MARK: Internal
    let title: String
    let artwork: MPMediaItemArtwork?
    let artist: String
    let releaseDate: Date

    var tracks: [MPMediaItem] {
        return _tracks.sorted { lhs, rhs in
            lhs.albumTrackNumber < rhs.albumTrackNumber
        }
    }
    var count: Int {
        return _tracks.count
    }

    mutating func add(_ track: MPMediaItem) {
        _tracks.append(track)
    }

    // MARK: Private
    private var _tracks: [MPMediaItem] = []
}
