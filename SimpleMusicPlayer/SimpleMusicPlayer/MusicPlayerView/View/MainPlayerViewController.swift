//
//  MainPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import Combine
import MediaPlayer
import UIKit

import SnapKit

class MainPlayerViewController: UIViewController {
    enum ViewProps {
        static let mediaControlButtonViewHeight: CGFloat = 60
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
        self.addPanGesture()
    }

    // MARK: UI Property
    private lazy var modalSymbolTopView = ModalSymbolTopView()
    private lazy var albumInfoView = MediaAlbumInfoView()
    private lazy var timeProgressView = MediaPlaybackTimeProgressView(type: .withText)
    private lazy var mediaControlButtonView: MediaControlButtonView = {
        let view = MediaControlButtonView()
        view.delegate = self
        return view
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
    private var initialOffset: CGPoint = .zero

    private func drawUI() {
        self.view.backgroundColor = .white
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 16
        self.view.addSubview(self.modalSymbolTopView)
        self.modalSymbolTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(16)
        }
        self.view.addSubview(self.albumInfoView)
        self.albumInfoView.snp.makeConstraints {
            $0.top.equalTo(self.modalSymbolTopView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.albumInfoView.snp.width)
        }
        self.view.addSubview(self.timeProgressView)
        self.timeProgressView.snp.makeConstraints {
            $0.top.equalTo(self.albumInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(32)
        }
        self.view.addSubview(self.mediaControlButtonView)
        self.mediaControlButtonView.snp.makeConstraints {
            $0.top.equalTo(self.timeProgressView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(ViewProps.mediaControlButtonViewHeight)
        }
        self.view.addSubview(self.volumeView)
        self.volumeView.snp.makeConstraints {
            $0.top.equalTo(self.mediaControlButtonView.snp.bottom).offset(32)
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
                self?.mediaControlButtonView.applyPlaybackState(state)
            }
            .store(in: &self.cancelBag)
        viewModel.$repeatMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.mediaControlButtonView.applyRepeatMode(mode)
            }
            .store(in: &self.cancelBag)
        viewModel.$shuffleMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.mediaControlButtonView.applyShuffleMode(mode)
            }
            .store(in: &self.cancelBag)
    }

    private func addPanGesture() {
        print(#function, self.view.frame.origin)
        self.view.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(self.viewPanned(_:))
            )
        )
    }

    @objc
    private func viewPanned(_ sender: UIPanGestureRecognizer) {
        let moveDistanceY = sender.translation(in: self.view).y
        switch sender.state {
        case .began:
            self.initialOffset = self.view.frame.origin
        case .changed:
            self.view.frame.origin = CGPoint(
                x: self.initialOffset.x,
                y: self.initialOffset.y + max(0, moveDistanceY)
            )
        default:
            if moveDistanceY > 150 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.view.frame.origin = self.initialOffset
                }
            }
        }
    }
}

extension MainPlayerViewController: MediaControlButtonDelegate {
    func mediaControlButtonTapped(type: MediaControlType) {
        switch type {
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
