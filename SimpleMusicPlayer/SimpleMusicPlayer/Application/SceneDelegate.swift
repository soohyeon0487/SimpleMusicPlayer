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
        let baseViewController = BaseViewController()
        window.rootViewController = baseViewController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Background에서 Foreground로 전환 시, 권한 및 AppleMusic PlayMode 동기화
        NotificationCenter.default.post(name: .checkAuthorization, object: nil)
        NotificationCenter.default.post(name: .syncSystemPlayerMode, object: nil)
    }
}
