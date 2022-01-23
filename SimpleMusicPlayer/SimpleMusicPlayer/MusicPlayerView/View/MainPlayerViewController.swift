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
        static let mediaControlStackViewHeight = 60
        static let mediaControlModeButtonHeight = 40
        static let mediaControlMoveButtonHeight = 50
        static let mediaControlPlayButtonHeight = 60
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
    private lazy var albumInfoView = MediaAlbumInfoView()
    private lazy var timeProgressView = MediaPlaybackTimeProgressView(type: .withText)
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
        self.view.addSubview(self.albumInfoView)
        self.albumInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.albumInfoView.snp.width)
        }
        self.view.addSubview(self.timeProgressView)
        self.timeProgressView.snp.makeConstraints {
            $0.top.equalTo(self.albumInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(32)
        }
        self.view.addSubview(self.mediaControlStackView)
        self.mediaControlStackView.snp.makeConstraints {
            $0.top.equalTo(self.timeProgressView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(ViewProps.mediaControlStackViewHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.repeatModeButton)
        self.repeatModeButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlModeButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.backwardButton)
        self.backwardButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlMoveButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.playingButton)
        self.playingButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlPlayButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.forwardButton)
        self.forwardButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlMoveButtonHeight)
        }
        self.mediaControlStackView.addArrangedSubview(self.shuffleModeButton)
        self.shuffleModeButton.snp.makeConstraints {
            $0.width.height.equalTo(ViewProps.mediaControlModeButtonHeight)
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
                self?.timeProgressView.progress = 0
                self?.albumInfoView.setAlbum(item)
            }
            .store(in: &self.cancelBag)
        viewModel.$playbackTimeSet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeSet in
                self?.timeProgressView.setTimeProgressView(timeSet)
            }
            .store(in: &self.cancelBag)
        viewModel.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.applyPlaybackState(state)
            }
            .store(in: &self.cancelBag)
        viewModel.$repeatMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.applyRepeatMode(mode)
            }
            .store(in: &self.cancelBag)
        viewModel.$shuffleMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.applyShuffleMode(mode)
            }
            .store(in: &self.cancelBag)
    }

    private func applyPlaybackState(_ state: MPMusicPlaybackState) {
        switch state {
        case .playing:
            self.playingButton.setImage(
                UIImage(systemName: ResourceKey.pause),
                for: .normal
            )
        default:
            self.playingButton.setImage(
                UIImage(systemName: ResourceKey.play),
                for: .normal
            )
        }
    }

    private func applyRepeatMode(_ mode: RepeatMode) {
        switch mode {
        case .none:
            self.repeatModeButton.setImage(
                UIImage(systemName: ResourceKey.repeatDefault),
                for: .normal
            )
            self.repeatModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )?.withAlphaComponent(0.3)
        case .one:
            self.repeatModeButton.setImage(
                UIImage(systemName: ResourceKey.repeatOnlyOne),
                for: .normal
            )
            self.repeatModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )
        case .all:
            self.repeatModeButton.setImage(
                UIImage(systemName: ResourceKey.repeatDefault),
                for: .normal
            )
            self.repeatModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )
        }
    }

    private func applyShuffleMode(_ mode: ShuffleMode) {
        switch mode {
        case .off:
            self.shuffleModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )?.withAlphaComponent(0.3)
        case .songs:
            self.shuffleModeButton.tintColor = .init(
                named: ResourceKey.primaryTint
            )
        }
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
