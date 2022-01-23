//
//  BaseViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import UIKit

class BaseViewController: UIViewController {
    enum ViewProps {
        static let miniPlayerHeight: CGFloat = 80
    }

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.drawUI()
    }

    // MARK: UI Property
    // 라이브러리, 앨범 내용을 담을 ViewController
    private lazy var contentVC: UINavigationController = {
        let navigationController = UINavigationController(
            rootViewController: MediaLibraryViewController()
        )
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    // 현재 재생 중인 음원 정보를 표시하는 하단 ViewController
    private lazy var miniPlayerVC: UIViewController = {
        let viewController = MiniPlayerViewController()
        viewController.delegate = self
        viewController.setViewModel(viewModel: self.playerViewModel)
        return viewController
    }()
    // 현재 재생 중인 음원 정보를 표시하는 Modal ViewController
    private lazy var mainPlayerVC: UIViewController = {
        let viewController = MainPlayerViewController()
        viewController.setViewModel(viewModel: self.playerViewModel)
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        return viewController
    }()

    // MARK: Private
    private let playerViewModel = MediaPlayerViewModel()

    private func drawUI() {
        self.view.backgroundColor = .white
        self.addChild(miniPlayerVC)
        self.view.addSubview(miniPlayerVC.view)
        self.miniPlayerVC.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottomMargin).offset(-ViewProps.miniPlayerHeight)
        }
        self.addChild(contentVC)
        self.view.addSubview(contentVC.view)
        self.contentVC.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.miniPlayerVC.view.snp.top)
        }
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .init(named: ResourceKey.primaryTint)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MiniPlayer를 탭했을 때
extension BaseViewController: MiniPlayerActionDelegate {
    func miniPlayerTapped() {
        self.present(mainPlayerVC, animated: true)
    }
}

// 새로운 Modal을 적절한 높이만큼 Presenting하기 위한
extension BaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        HalfPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
