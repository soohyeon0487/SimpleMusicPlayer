//
//  ModalSymbolTopView.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/23.
//

import UIKit

import SnapKit

class ModalSymbolTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    // MARK: UI Property
    private lazy var roundRectView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()

    // MARK: Private
    private func configure() {
        self.isUserInteractionEnabled = false
        self.drawUI()
    }

    private func drawUI() {
        self.addSubview(self.roundRectView)
        self.roundRectView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
    }
}
