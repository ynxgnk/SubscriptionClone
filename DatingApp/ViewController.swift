//
//  ViewController.swift
//  DatingApp
//
//  Created by Nazar Kopeika on 28.06.2023.
//

import SwiftUI
import UIKit

class ViewController: UIViewController, PaywallViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let payWallVC = UIHostingController(rootView: PaywallView(viewModel: .init(title: "Dating App", subtitle: "Gold Membership", delegate: self)))
        addChild(payWallVC)
        
        view.addSubview(payWallVC.view)
        payWallVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            payWallVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            payWallVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            payWallVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            payWallVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        payWallVC.didMove(toParent: self)
    }

    func didTapRestorePurchase() {
        print("Should restore")
    }
    
    func didTapPurchase(plan: PremiumPlan) {
        print("Start trial with plan \(plan)")
    }
}

