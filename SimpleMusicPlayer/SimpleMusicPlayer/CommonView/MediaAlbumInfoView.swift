//
//  MediaAlbumInfoView.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import UIKit

import SnapKit
import MediaPlayer

class MediaAlbumInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    // MARK: Internal
    func setAlbum(_ album: MediaAlbum?) {
        guard let album = album else {
            return
        }
        self.artworkImageView.image = album.artwork?.image(
            at: CGSize(width: self.bounds.width, height: self.bounds.width)
        )
        self.albumTitleLabel.text = album.title
        self.albumArtistLabel.text = album.artist
    }

    func setAlbum(_ track: MPMediaItem?) {
        guard let track = track else {
            return
        }
        self.artworkImageView.image = track.artwork?.image(
            at: CGSize(width: self.bounds.width, height: self.bounds.width)
        )
        self.albumTitleLabel.text = track.title
        self.albumArtistLabel.text = track.artist
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
        imageView.contentMode = .scaleAspectFill
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

    // MARK: Private
    private func configure() {
        self.drawUI()
    }

    private func drawUI() {
        self.addSubview(self.shadowBaseView)
        self.shadowBaseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(self.shadowBaseView.snp.width)
        }
        self.shadowBaseView.addSubview(self.artworkImageView)
        self.artworkImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview()
        }
        self.addSubview(self.albumTitleLabel)
        self.albumTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.shadowBaseView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        self.addSubview(self.albumArtistLabel)
        self.albumArtistLabel.snp.makeConstraints {
            $0.top.equalTo(self.albumTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
