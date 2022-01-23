//
//  TimeInterval+Extension.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Foundation

extension TimeInterval {
    func toTimeString() -> String {
        return String.init(format: "%d:%02d", Int(self / 60), Int(self) % 60)
    }
}
