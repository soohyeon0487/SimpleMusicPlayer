//
//  MediaTrack.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Foundation

struct MediaTrack: Hashable, Comparable {
    static func < (lhs: MediaTrack, rhs: MediaTrack) -> Bool {
        lhs.number < rhs.number
    }

    // MARK: Internal
    let number: Int
    let title: String
}
