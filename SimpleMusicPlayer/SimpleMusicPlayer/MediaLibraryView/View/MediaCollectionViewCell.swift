//
//  MediaCollectionViewCell.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import UIKit

import SnapKit

class MediaCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    // MARK: Internal
    func setAlbum(_ album: MediaAlbum) {
        self.artworkImageView.image = album.artwork?.image(
            at: CGSize(width: self.bounds.width, height: self.bounds.width)
        )
        self.albumTitleLabel.text = album.title
        self.albumArtistLabel.text = album.artist
    }

    // MARK: Life Cycle Function
    override func prepareForReuse() {
        super.prepareForReuse()
        self.artworkImageView.image = nil
        self.albumTitleLabel.text = nil
        self.albumArtistLabel.text = nil
    }

    // MARK: UI Property
    private lazy var shadowBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
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

    // MARK: Private
    private func configure() {
        self.drawUI()
    }

    private func drawUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3

        self.addSubview(self.shadowBaseView)
        self.shadowBaseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.shadowBaseView.addSubview(self.artworkImageView)
        self.artworkImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.artworkImageView.snp.width)
        }
        self.shadowBaseView.addSubview(self.albumTitleLabel)
        self.albumTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.artworkImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        self.shadowBaseView.addSubview(self.albumArtistLabel)
        self.albumArtistLabel.snp.makeConstraints {
            $0.top.equalTo(self.albumTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}
