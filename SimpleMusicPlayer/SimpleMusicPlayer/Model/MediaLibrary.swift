//
//  MediaLibrary.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Foundation
import MediaPlayer

class MediaLibrary: Equatable {
    static func == (lhs: MediaLibrary, rhs: MediaLibrary) -> Bool {
        lhs._albums == rhs._albums
    }

    // MARK: Internal
    var albums: [MediaAlbum] {
        return _albums.values.sorted {
            if $0.releaseDate > $1.releaseDate {
                return true
            } else if $0.releaseDate < $1.releaseDate {
                return false
            } else {
                return $0.title < $1.title
            }
        }
    }

    func add(track: MPMediaItem) {
        if var album = _albums[track.albumPersistentID] {
            album.add(track)
            self._albums[track.albumPersistentID] = album
        } else {
            var newAlbum = MediaAlbum(
                title: track.albumTitle ?? RawString.unknown,
                artwork: track.artwork,
                artist: track.artist ?? RawString.unknown,
                releaseDate: track.releaseDate ?? Date()
            )
            newAlbum.add(track)
            self._albums[track.albumPersistentID] = newAlbum
        }
    }
    
    // MARK: Private
    private var _albums: [UInt64: MediaAlbum] = [:]
}
