//
//  MainPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import Combine
import UIKit
import MediaPlayer

import SnapKit

// TODO: 스와이프 다운으로 창 닫기

class MainPlayerViewController: UIViewController {
    enum MediaControlType: Int {
        case repeatMode = 1, backward, playing, forward, shuffleMode
    }
    enum ViewProps {
        static let mediaControlButtonHeight = 40
    }

    // MARK: Internal
    func setViewModel(viewModel: MediaPlayerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
        self.bindUI()
    }

    // MARK: UI Property
    private lazy var shadowBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        return view
    }()
    private lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private lazy var albumTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    private lazy var albumArtistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    private lazy var playingProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = .gray.withAlphaComponent(0.5)
        progressView.tintColor = .init(named: ResourceKey.primaryTint)
        progressView.progressViewStyle = .bar
        return progressView
    }()
    // TODO: CustomView로 전환하기
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
        button.setImage(UIImage(systemName: ResourceKey.backward), for: .normal)
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
        button.setImage(UIImage(systemName: ResourceKey.play), for: .normal)
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
        button.setImage(UIImage(systemName: ResourceKey.forward), for: .normal)
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
        button.setImage(UIImage(systemName: ResourceKey.shuffleMode), for: .normal)
        button.tag = MediaControlType.shuffleMode.rawValue
        button.addTarget(
            self,
            action: #selector(self.mediaControlButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var volumeView: MPVolumeView = {
        let view = MPVolumeView()
        view.tintColor = .init(named: ResourceKey.primaryTint)
        view.setValue(false, forKey: "showsRouteButton")
        return view
    }()

    // MARK: Private
    private var viewModel: MediaPlayerViewModel?
    private var cancelBag = Set<AnyCancellable>()

    private func drawUI() {
        self.view.backgroundColor = .white
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 16
        self.view.addSubview(self.shadowBaseView)
        self.shadowBaseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(self.shadowBaseView.snp.width)
        }
        self.shadowBaseView.addSubview(self.artworkImageView)
        self.artworkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.view.addSubview(self.albumTitleLabel)
        self.albumTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.shadowBaseView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        self.view.addSubview(self.albumArtistLabel)
        self.albumArtistLabel.snp.makeConstraints {
            $0.top.equalTo(self.albumTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        self.view.addSubview(self.playingProgressView)
        self.playingProgressView.snp.makeConstraints {
            $0.top.equalTo(self.albumArtistLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(3)
        }
        self.view.addSubview(self.currentPlayBackTimeLabel)
        self.currentPlayBackTimeLabel.snp.makeConstraints {
            $0.top.equalTo(self.playingProgressView.snp.bottom).offset(8)
            $0.leading.equalTo(self.playingProgressView)
        }
        self.view.addSubview(self.extraPlaybackTimeLabel)
        self.extraPlaybackTimeLabel.snp.makeConstraints {
            $0.top.equalTo(self.playingProgressView.snp.bottom).offset(8)
            $0.trailing.equalTo(self.playingProgressView)
        }
        self.view.addSubview(self.mediaControlStackView)
        self.mediaControlStackView.snp.makeConstraints {
            $0.top.equalTo(self.playingProgressView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(ViewProps.mediaControlButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.repeatModeButton)
        self.repeatModeButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.backwardButton)
        self.backwardButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.playingButton)
        self.playingButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.forwardButton)
        self.forwardButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.shuffleModeButton)
        self.shuffleModeButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlButtonHeight)
        }
        self.view.addSubview(self.volumeView)
        self.volumeView.snp.makeConstraints {
            $0.top.equalTo(self.mediaControlStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(self.view.snp.bottomMargin)
        }
    }

    private func bindUI() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.$nowPlayingItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.playingProgressView.progress = 0
                self?.albumTitleLabel.text = item?.title
                self?.albumArtistLabel.text = item?.artist
                if let item = item {
                    self?.artworkImageView.image = item.artwork?.image(
                        at: self?.artworkImageView.bounds.size ?? .zero
                    )
                } else {
                    self?.artworkImageView.image = UIImage(
                        systemName: ResourceKey.musicNote
                    )
                }
            }
            .store(in: &self.cancelBag)
        viewModel.$currentPlaybackTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] current in
                self?.currentPlayBackTimeLabel.text = current.toTimeString()
            }
            .store(in: &self.cancelBag)
        viewModel.$extraPlaybackTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] extra in
                self?.extraPlaybackTimeLabel.text = "-" + extra.toTimeString()
            }
            .store(in: &self.cancelBag)
        viewModel.$playbackProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.playingProgressView.progress = progress
            }
            .store(in: &self.cancelBag)
        viewModel.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .playing:
                    self?.playingButton.setImage(
                        UIImage(systemName: ResourceKey.pause),
                        for: .normal
                    )
                default:
                    self?.playingButton.setImage(
                        UIImage(systemName: ResourceKey.play),
                        for: .normal
                    )
                }
            }
            .store(in: &self.cancelBag)
        viewModel.$repeatMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                switch mode {
                case .none:
                    self?.repeatModeButton.setImage(
                        UIImage(systemName: ResourceKey.repeatDefault),
                        for: .normal
                    )
                    self?.repeatModeButton.tintColor = .init(
                        named: ResourceKey.primaryTint
                    )?.withAlphaComponent(0.3)
                case .one:
                    self?.repeatModeButton.setImage(
                        UIImage(systemName: ResourceKey.repeatOnlyOne),
                        for: .normal
                    )
                    self?.repeatModeButton.tintColor = .init(
                        named: ResourceKey.primaryTint
                    )
                case .all:
                    self?.repeatModeButton.setImage(
                        UIImage(systemName: ResourceKey.repeatDefault),
                        for: .normal
                    )
                    self?.repeatModeButton.tintColor = .init(
                        named: ResourceKey.primaryTint
                    )
                }
            }
            .store(in: &self.cancelBag)
        viewModel.$shuffleMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                switch mode {
                case .off:
                    self?.shuffleModeButton.tintColor = .init(
                        named: ResourceKey.primaryTint
                    )?.withAlphaComponent(0.3)
                case .songs:
                    self?.shuffleModeButton.tintColor = .init(
                        named: ResourceKey.primaryTint
                    )
                }
            }
            .store(in: &self.cancelBag)
    }

    @objc
    private func mediaControlButtonTapped(_ sender: UIButton) {
        guard let buttonType = MediaControlType.init(rawValue: sender.tag) else {
            return
        }
        switch buttonType {
        case .repeatMode:
            self.viewModel?.repeatModeButtonTapped()
        case .backward:
            self.viewModel?.backwardButtonTapped()
        case .playing:
            self.viewModel?.playingButtonTapped()
        case .forward:
            self.viewModel?.forwardButtonTapped()
        case .shuffleMode:
            self.viewModel?.shuffleModeButtonTapped()
        }
    }
}
