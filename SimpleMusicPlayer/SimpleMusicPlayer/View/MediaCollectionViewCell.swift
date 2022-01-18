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

    // MARK: UI Property
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

    // MARK: Life Cycle Function
    override func prepareForReuse() {
        super.prepareForReuse()
        self.artworkImageView.image = nil
        self.albumTitleLabel.text = nil
        self.albumArtistLabel.text = nil
    }

    // MARK: Class Method
    private func configure() {
        self.drawUI()
    }

    private func drawUI() {
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8

        self.addSubview(self.artworkImageView)
        self.artworkImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.artworkImageView.snp.width)
        }
        self.addSubview(self.albumTitleLabel)
        self.albumTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.artworkImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        self.addSubview(self.albumArtistLabel)
        self.albumArtistLabel.snp.makeConstraints {
            $0.top.equalTo(self.albumTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}
