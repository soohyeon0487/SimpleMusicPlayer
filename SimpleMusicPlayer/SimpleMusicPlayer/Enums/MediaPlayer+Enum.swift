//
//  MediaPlayer+Enum.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/23.
//

import Foundation

enum RepeatMode: Int, CaseIterable {
    case none = 1, one, all

    func getNextMode() -> Self? {
        let rawValue = (self.rawValue) % RepeatMode.allCases.count + 1
        return RepeatMode.init(rawValue: rawValue)
    }
}

enum ShuffleMode: Int, CaseIterable {
    case off = 1, songs

    func getNextMode() -> Self? {
        let rawValue = (self.rawValue) % ShuffleMode.allCases.count + 1
        return ShuffleMode.init(rawValue: rawValue)
    }
}
