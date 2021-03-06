//
//  MediaPlayButtonView.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import UIKit

import SnapKit

protocol MediaPlayButtonDelegate: AnyObject {
    func playButtonTapped()
    func randomPlayButtonTapped()
}

class MediaPlayButtonView: UIView {
    enum PlayButtonType: Int {
        case play = 1, randomPlay
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    // MARK: Internal
    weak var delegate: MediaPlayButtonDelegate?

    // MARK: UI Property
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ResourceKey.play), for: .normal)
        button.tintColor = .init(named: ResourceKey.primaryTint)
        button.backgroundColor = .init(named: ResourceKey.primaryTint)?.withAlphaComponent(0.3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.tag = PlayButtonType.play.rawValue
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var randomPlayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ResourceKey.shuffleMode), for: .normal)
        button.tintColor = .init(named: ResourceKey.primaryTint)
        button.backgroundColor = .init(named: ResourceKey.primaryTint)?.withAlphaComponent(0.3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.tag = PlayButtonType.randomPlay.rawValue
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: Private
    private func configure() {
        self.drawUI()
    }

    private func drawUI() {
        self.addSubview(self.playButton)
        self.playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.trailing.equalTo(self.snp.centerX).offset(-8)
        }
        self.addSubview(self.randomPlayButton)
        self.randomPlayButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.trailing.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(self.snp.centerX).offset(8)
        }
    }

    @objc
    private func buttonTapped(_ sender: UIButton) {
        guard let playType = PlayButtonType(rawValue: sender.tag) else {
            return
        }
        switch playType {
        case .play:
            self.delegate?.playButtonTapped()
        case .randomPlay:
            self.delegate?.randomPlayButtonTapped()
        }
    }
}
