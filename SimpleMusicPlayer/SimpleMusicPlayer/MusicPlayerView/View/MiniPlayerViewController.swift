//
//  MiniPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import Combine
import UIKit

protocol MiniPlayerActionDelegate: AnyObject {
    func miniPlayerTapped()
}

class MiniPlayerViewController: UIViewController {
    // MARK: Internal
    weak var delegate: MiniPlayerActionDelegate?

    func setViewModel(viewModel: MediaPlayerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: UI Property
    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(viewTapped(_:))
            )
        )
        return view
    }()
    private lazy var playingProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = .gray.withAlphaComponent(0.5)
        progressView.tintColor = .init(named: ResourceKey.primaryTint.rawValue)
        progressView.progressViewStyle = .bar
        return progressView
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
        label.font = .preferredFont(forTextStyle: .headline)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private lazy var albumArtistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private lazy var playingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ResourceKey.play.rawValue), for: .normal)
        button.addTarget(self, action: #selector(self.playingButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var emptyPlayerLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 재생 중인 노래가 없습니다"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: Class Property
    private var viewModel: MediaPlayerViewModel?
    private var cancelBag = Set<AnyCancellable>()

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
        self.bindUI()
    }

    // MARK: Class Method
    private func drawUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.baseView)
        self.baseView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }

        self.baseView.addSubview(self.playingProgressView)
        self.playingProgressView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        self.baseView.addSubview(self.artworkImageView)
        self.artworkImageView.snp.makeConstraints {
            $0.top.equalTo(self.playingProgressView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(self.artworkImageView.snp.height)
        }
        self.baseView.addSubview(self.playingButton)
        self.playingButton.snp.makeConstraints {
            $0.top.equalTo(self.playingProgressView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(self.playingButton.snp.height).multipliedBy(0.8)
        }
        self.baseView.addSubview(self.albumTitleLabel)
        self.albumTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.artworkImageView.snp.centerY).offset(-2)
            $0.leading.equalTo(self.artworkImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(self.playingButton.snp.leading).offset(-16)
        }
        self.baseView.addSubview(self.albumArtistLabel)
        self.albumArtistLabel.snp.makeConstraints {
            $0.top.equalTo(self.artworkImageView.snp.centerY).offset(2)
            $0.leading.equalTo(self.artworkImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(self.playingButton.snp.leading).offset(-16)
        }
        self.baseView.addSubview(self.emptyPlayerLabel)
        self.emptyPlayerLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.artworkImageView)
            $0.leading.equalTo(self.artworkImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(self.playingButton.snp.leading).offset(-16)
        }
    }

    private func bindUI() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.$nowPlayingItem
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.playingProgressView.progress = 0
                self?.baseView.isUserInteractionEnabled = item != nil
                self?.emptyPlayerLabel.isHidden = item != nil
                self?.albumTitleLabel.text = item?.title
                self?.albumArtistLabel.text = item?.artist
                if let item = item {
                    self?.artworkImageView.image = item.artwork?.image(
                        at: self?.artworkImageView.bounds.size ?? .zero
                    )
                } else {
                    self?.artworkImageView.image = UIImage(
                        systemName: ResourceKey.musicNote.rawValue
                    )
                }
            }
            .store(in: &self.cancelBag)
        viewModel.$playbackProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.playingProgressView.progress = progress
            }
            .store(in: &self.cancelBag)
        viewModel.$isPlaying
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .playing:
                    self?.playingButton.setImage(
                        UIImage(systemName: ResourceKey.pause.rawValue),
                        for: .normal
                    )
                default:
                    self?.playingButton.setImage(
                        UIImage(systemName: ResourceKey.play.rawValue),
                        for: .normal
                    )
                }
            }
            .store(in: &self.cancelBag)
    }

    @objc
    private func playingButtonTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.playingButtonTapped()
    }

    @objc
    private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.miniPlayerTapped()
    }
}
