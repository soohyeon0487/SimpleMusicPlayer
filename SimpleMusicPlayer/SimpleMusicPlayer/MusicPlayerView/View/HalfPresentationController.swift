//
//  HalfPresentationController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/21.
//

import UIKit

class HalfPresentationController: UIPresentationController {
    enum PresentingValue: CGFloat {
        case ratio = 1.5
        case backgroundMinAlpha = 0.0
        case backgroundMaxAlpha = 0.5
    }
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = UIScreen.main.bounds
        let targetHeight = bounds.width * PresentingValue.ratio.rawValue
        return CGRect(
            x: 0,
            y: bounds.height - targetHeight,
            width: bounds.width,
            height: targetHeight
        )
    }

    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.modalBackgroundView)
        self.modalBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.modalBackgroundView.alpha = PresentingValue.backgroundMaxAlpha.rawValue
            },
            completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.modalBackgroundView.alpha = PresentingValue.backgroundMinAlpha.rawValue
            },
            completion: { _ in
                self.modalBackgroundView.removeFromSuperview()
            }
        )
    }

    private lazy var modalBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = PresentingValue.backgroundMaxAlpha.rawValue
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
