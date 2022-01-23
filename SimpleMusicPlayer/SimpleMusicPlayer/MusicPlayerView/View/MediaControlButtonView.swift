//
//  MediaControlButtonView.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/23.
//

import UIKit

import SnapKit
import MediaPlayer

protocol MediaControlButtonDelegate: AnyObject {
    func mediaControlButtonTapped(type: MediaControlType)
}

typealias MediaControlType = MediaControlButtonView.MediaControlType

class MediaControlButtonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    enum MediaControlType: Int {
        case repeatMode = 1, backward, playing, forward, shuffleMode
    }
    enum ViewProps {
        static let mediaControlStackViewHeight: CGFloat = 60
        static let mediaControlModePointSize: CGFloat = 18
        static let mediaControlMovePointSize: CGFloat = 22
        static let mediaControlPlayPointSize: CGFloat = 30
    }

    // MARK: Internal
    weak var delegate: MediaControlButtonDelegate?

    func applyPlaybackState(_ state: MPMusicPlaybackState) {
        switch state {
        case .playing:
            self.playingButton.setImage(
                UIImage(systemName: ResourceKey.pause)?.withConfiguration(playConfigure),
                for: .normal
            )
        default:
            self.playingButton.setImage(
                UIImage(systemName: ResourceKey.play)?.withConfiguration(playConfigure),
                for: .normal
            )
        }
    }

    func applyRepeatMode(_ mode: RepeatMode) {
        switch mode {
        case .none:
            self.repeatModeButton.setImage(
                UIImage(systemName: ResourceKey.repeatDefault)?.withConfiguration(modeConfigure),
                for: .normal
            )
            self.repeatModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )?.withAlphaComponent(0.3)
        case .one:
            self.repeatModeButton.setImage(
                UIImage(systemName: ResourceKey.repeatOnlyOne)?.withConfiguration(modeConfigure),
                for: .normal
            )
            self.repeatModeButton.tintColor = .init(named: ResourceKey.primaryTint)
        case .all:
            self.repeatModeButton.setImage(
                UIImage(systemName: ResourceKey.repeatDefault)?.withConfiguration(modeConfigure),
                for: .normal
            )
            self.repeatModeButton.tintColor = .init(named: ResourceKey.primaryTint)
        }
    }

    func applyShuffleMode(_ mode: ShuffleMode) {
        switch mode {
        case .off:
            self.shuffleModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )?.withAlphaComponent(0.3)
        case .songs:
            self.shuffleModeButton.tintColor = .init(named: ResourceKey.primaryTint)
        }
    }

    // MARK: UI Property
    private lazy var mediaControlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private lazy var repeatModeButton: UIButton = {
        let button = UIButton()
        button.tag = MediaControlType.repeatMode.rawValue
        button.addTarget(
            self,
            action: #selector(self.mediaControlButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: ResourceKey.backward)?.withConfiguration(moveConfigure),
            for: .normal
        )
        button.tintColor = .init(named: ResourceKey.primaryTint)
        button.tag = MediaControlType.backward.rawValue
        button.addTarget(
            self,
            action: #selector(self.mediaControlButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var playingButton: UIButton = {
        let button = UIButton()
        button.tintColor = .init(named: ResourceKey.primaryTint)
        button.tag = MediaControlType.playing.rawValue
        button.addTarget(
            self,
            action: #selector(self.mediaControlButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: ResourceKey.forward)?.withConfiguration(moveConfigure),
            for: .normal
        )
        button.tintColor = .init(named: ResourceKey.primaryTint)
        button.tag = MediaControlType.forward.rawValue
        button.addTarget(
            self,
            action: #selector(self.mediaControlButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var shuffleModeButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: ResourceKey.shuffleMode)?.withConfiguration(modeConfigure),
            for: .normal
        )
        button.tag = MediaControlType.shuffleMode.rawValue
        button.addTarget(
            self,
            action: #selector(self.mediaControlButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: Private
    private let modeConfigure = UIImage.SymbolConfiguration(
        pointSize: ViewProps.mediaControlModePointSize,
        weight: .regular
    )
    private let moveConfigure = UIImage.SymbolConfiguration(
        pointSize: ViewProps.mediaControlMovePointSize,
        weight: .regular
    )
    private let playConfigure = UIImage.SymbolConfiguration(
        pointSize: ViewProps.mediaControlPlayPointSize,
        weight: .regular
    )

    private func configure() {
        self.drawUI()
    }

    private func drawUI() {
        self.addSubview(self.mediaControlStackView)
        self.mediaControlStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.mediaControlStackView.addArrangedSubview(self.repeatModeButton)
        self.repeatModeButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlStackViewHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.backwardButton)
        self.backwardButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlStackViewHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.playingButton)
        self.playingButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlStackViewHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.forwardButton)
        self.forwardButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlStackViewHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.shuffleModeButton)
        self.shuffleModeButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlStackViewHeight)
        }
    }

    @objc
    private func mediaControlButtonTapped(_ sender: UIButton) {
        guard let buttonType = MediaControlType.init(rawValue: sender.tag) else {
            return
        }
        self.delegate?.mediaControlButtonTapped(type: buttonType)
    }
}
