//
//  MediaPlaybackTimeProgressView.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/23.
//

import UIKit

import SnapKit

class MediaPlaybackTimeProgressView: UIView {
    init(type: ProgressType) {
        super.init(frame: .zero)
        self.configure(with: type)
        self.progress = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    enum ProgressType {
        case onlyBar
        case withText
    }

    // MARK: Internal
    var progress: Float {
        get {
            return self.playingProgressView.progress
        }
        set {
            self.playingProgressView.progress = newValue.isNormal ? newValue : 0
        }
    }

    func setTimeProgressView(_ timeSet: (current: TimeInterval, total: TimeInterval)) {
        self.currentPlayBackTimeLabel.text = timeSet.current.toTimeString()
        self.extraPlaybackTimeLabel.text = "-" + (timeSet.total - timeSet.current).toTimeString()
        self.progress = Float(timeSet.current / timeSet.total)
    }

    // MARK: UI Property
    private lazy var playingProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = .gray.withAlphaComponent(0.5)
        progressView.tintColor = .init(named: ResourceKey.primaryTint)
        progressView.progressViewStyle = .bar
        progressView.progress = 0
        return progressView
    }()
    private lazy var currentPlayBackTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private lazy var extraPlaybackTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    // MARK: Private
    private func configure(with type: ProgressType) {
        switch type {
        case .onlyBar:
            self.drawOnlyBar()
        case .withText:
            self.drawWithText()
        }

    }

    private func drawOnlyBar() {
        self.addSubview(self.playingProgressView)
        self.playingProgressView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func drawWithText() {
        self.addSubview(self.playingProgressView)
        self.playingProgressView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        self.addSubview(self.currentPlayBackTimeLabel)
        self.currentPlayBackTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(self.playingProgressView)
            $0.bottom.equalToSuperview()
        }
        self.addSubview(self.extraPlaybackTimeLabel)
        self.extraPlaybackTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.playingProgressView)
            $0.bottom.equalToSuperview()
        }
    }
}
