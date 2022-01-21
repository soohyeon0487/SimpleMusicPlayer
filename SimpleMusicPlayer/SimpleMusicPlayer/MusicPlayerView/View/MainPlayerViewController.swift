//
//  MainPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import UIKit

import SnapKit

class MainPlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
    }

    private lazy var topBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()

    private func drawUI() {
        self.view.backgroundColor = .white
        self.drawNavigationBar()
    }

    private func drawNavigationBar() {
        self.view.addSubview(topBar)
        self.topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
