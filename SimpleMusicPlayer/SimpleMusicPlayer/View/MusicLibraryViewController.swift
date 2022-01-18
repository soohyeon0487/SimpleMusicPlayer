//
//  ViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import UIKit

import SnapKit

class MusicLibraryViewController: UIViewController {
    // MARK: UI Property
    private lazy var albumCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        viewLayout.minimumLineSpacing = 8
        viewLayout.minimumInteritemSpacing = 8
        let insets = viewLayout.sectionInset.left + viewLayout.sectionInset.right
        let spaces = viewLayout.minimumInteritemSpacing
        let itemWidth = UIScreen.main.bounds.width - insets - spaces
        viewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .gray.withAlphaComponent(0.3)
        return collectionView
    }()

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
    }

    // MARK: Class Method
    private func drawUI() {
        self.view.backgroundColor = .white
        self.drawCollectionView()
    }

    private func drawCollectionView() {
        self.view.addSubview(self.albumCollectionView)
        self.albumCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.topMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
