//
//  TrackListTableViewCell.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import UIKit

import MediaPlayer
import SnapKit

class TrackListTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    // MARK: Internal
    func setTrack(_ track: MPMediaItem) {
        self.trackNumberLabel.text = "\(track.albumTrackNumber)"
        self.trackTitleLabel.text = track.title
    }

    // MARK: UI Property
    private lazy var trackNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        return label
    }()
    private lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private lazy var trackInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ResourceKey.ellipsis), for: .normal)
        return button
    }()

    // MARK: Life Cycle Function
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trackNumberLabel.text = nil
        self.trackTitleLabel.text = nil
    }

    // MARK: Class Method
    private func configure() {
        self.drawUI()
    }

    private func drawUI() {
        self.backgroundColor = .white
        self.addSubview(self.trackNumberLabel)
        self.trackNumberLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        self.addSubview(self.trackInfoButton)
        self.trackInfoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        self.addSubview(self.trackTitleLabel)
        self.trackTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.trackNumberLabel.snp.trailing).offset(16)
            $0.trailing.equalTo(self.trackInfoButton.snp.leading).offset(16)
        }
    }
}
