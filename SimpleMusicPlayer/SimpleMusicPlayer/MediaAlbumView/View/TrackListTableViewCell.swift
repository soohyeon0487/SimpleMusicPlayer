//
//  TrackListTableViewCell.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import MediaPlayer
import UIKit

import SnapKit

protocol TrackListTableViewCellDelegate: AnyObject {
    func accessoryButtonTapped(playCount: Int)
}

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
    weak var delegate: TrackListTableViewCellDelegate?
    
    var track: MPMediaItem? {
        didSet {
            if let track = track {
                self.setTrack(track)
            }
        }
    }

    // MARK: Life Cycle Function
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trackNumberLabel.text = nil
        self.trackTitleLabel.text = nil
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
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        button.setImage(UIImage(systemName: ResourceKey.ellipsis), for: .normal)
        button.addTarget(
            self,
            action: #selector(self.accessoryButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: Private
    private func configure() {
        self.drawUI()
        self.accessoryView = self.trackInfoButton
    }

    private func drawUI() {
        self.backgroundColor = .white
        self.addSubview(self.trackNumberLabel)
        self.trackNumberLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        self.addSubview(self.trackTitleLabel)
        self.trackTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.trackNumberLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-48)
        }
    }

    private func setTrack(_ track: MPMediaItem) {
        self.trackNumberLabel.text = "\(track.albumTrackNumber)"
        self.trackTitleLabel.text = track.title
    }

    @objc
    private func accessoryButtonTapped(_ sender: UIButton) {
        self.delegate?.accessoryButtonTapped(playCount: track?.playCount ?? 0)
    }
}
