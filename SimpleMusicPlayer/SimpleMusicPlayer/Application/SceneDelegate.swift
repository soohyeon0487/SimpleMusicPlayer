//
//  SceneDelegate.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationViewController = UINavigationController(
            rootViewController: MusicLibraryViewController()
        )
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.navigationBar.topItem?.title = "라이브러리"
        navigationViewController.navigationItem.largeTitleDisplayMode = .always
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
