//
//  MediaLibrary.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Foundation
import MediaPlayer

class MediaLibrary {
    // MARK: Internal
    var albums: [MediaAlbum] {
        return innerAlbums.values.sorted {
            if $0.releaseDate < $1.releaseDate {
                return true
            } else if $0.releaseDate > $1.releaseDate {
                return false
            } else {
                return $0.title < $1.title
            }
        }
    }

    func add(track: MPMediaItem) {
        if var album = innerAlbums[track.albumPersistentID] {
            album.insert(track.title ?? "unknown", at: track.albumTrackCount)
        } else {
            var newAlbum = MediaAlbum(
                title: track.albumTitle ?? "unknown",
                artwork: track.artwork, // track.artwork.,
                artist: track.artist ?? "unknown",
                releaseDate: track.releaseDate ?? Date()
            )
            newAlbum.insert(track.title ?? "unknown", at: track.albumTrackCount)
            self.innerAlbums[track.albumPersistentID] = newAlbum
        }
    }
    
    // MARK: Private
    private var innerAlbums: [UInt64: MediaAlbum] = [:]
}
