//
//  MediaAlbum.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Foundation

struct MediaAlbum {
    init(
        title: String,
        artwork: Data,
        artist: String,
        releaseDate: Date,
        tracks: [Int: MediaTrack] = [:]
    ) {
        self.title = title
        self.artwork = artwork
        self.artist = artist
        self.releaseDate = releaseDate
        self.tracks = tracks
    }

    // MARK: Internal
    let title: String
    let artwork: Data
    let artist: String
    let releaseDate: Date

    var count: Int {
        return tracks.values.count
    }

    mutating func insert(_ title: String, at number: Int) {
        tracks[number] = MediaTrack(title: title)
    }

    subscript(_ index: Int) -> MediaTrack? {
        return tracks[index]
    }

    // MARK: Private
    private var tracks: [Int: MediaTrack]
}
