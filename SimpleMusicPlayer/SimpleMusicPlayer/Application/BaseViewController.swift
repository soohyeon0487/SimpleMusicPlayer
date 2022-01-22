//
//  BaseViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.drawUI()
    }

    private lazy var contentVC: UINavigationController = {
        let navigationController = UINavigationController(
            rootViewController: MediaLibraryViewController()
        )
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        return navigationController
    }()
    private lazy var miniPlayerVC: UIViewController = {
        let viewController = MiniPlayerViewController()
        viewController.delegate = self
        return viewController
    }()
    private lazy var mainPlayerVC: UIViewController = {
        let viewController = MainPlayerViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        return viewController
    }()

    private func drawUI() {
        self.view.backgroundColor = .white
        self.addChild(miniPlayerVC)
        self.view.addSubview(miniPlayerVC.view)
        self.miniPlayerVC.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottomMargin).offset(-80)
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
        appearance.backgroundColor = .init(named: "color.primaryTint")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension BaseViewController: MiniPlayerActionDelegate {
    func miniPlayerTapped() {
        self.present(mainPlayerVC, animated: true)
    }
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        HalfPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
