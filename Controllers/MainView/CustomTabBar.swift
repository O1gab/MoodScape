//
//  CustomTabBar.swift
//  MoodScape
//
//  Created by Olga Batiunia on 27.08.24.
//

import UIKit

class CustomTabBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBar()
    }

    private func setupTabBar() {
        // image
        let curveImageView = UIImageView(image: UIImage(named: "custom_tabbar"))
        curveImageView.contentMode = .scaleAspectFit
        curveImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(curveImageView)
        
        NSLayoutConstraint.activate([
            curveImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            curveImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            curveImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            curveImageView.heightAnchor.constraint(equalToConstant: 100)// Adjust if needed
        ])
    }
}
