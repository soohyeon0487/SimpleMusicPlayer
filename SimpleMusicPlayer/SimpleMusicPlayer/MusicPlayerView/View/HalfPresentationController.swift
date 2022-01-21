//
//  HalfPresentationController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import UIKit

class HalfPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = UIScreen.main.bounds
        return CGRect(
            x: 0,
            y: bounds.height / 2,
            width: bounds.width,
            height: bounds.height / 2
        )
    }

    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.modalBackgroundView)
        self.modalBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.modalBackgroundView.alpha = 0.5
            },
            completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.modalBackgroundView.alpha = 0
            },
            completion: { _ in
                self.modalBackgroundView.removeFromSuperview()
            }
        )
    }

    private lazy var modalBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissView(_:))
            )
        )
        return view
    }()

    @objc
    private func dismissView(_ sender: UITapGestureRecognizer) {
        self.presentedViewController.dismiss(animated: true)
    }
}
