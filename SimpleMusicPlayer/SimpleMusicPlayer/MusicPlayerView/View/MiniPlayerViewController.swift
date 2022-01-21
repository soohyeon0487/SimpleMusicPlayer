//
//  MiniPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import UIKit

protocol MiniPlayerActionDelegate: AnyObject {
    func miniPlayerTapped()
}

class MiniPlayerViewController: UIViewController {
    weak var delegate: MiniPlayerActionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
    }

    private func drawUI() {
        self.view.backgroundColor = .white
        self.view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(viewTapped(_:))
            )
        )
    }

    @objc
    private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.miniPlayerTapped()
    }
}
