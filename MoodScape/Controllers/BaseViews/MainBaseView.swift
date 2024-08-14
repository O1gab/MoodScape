//
//  MainBaseView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 14.08.24.
//

import UIKit
import Gifu

class MainBaseView: UIViewController {
    
    let gifImageView = GIFImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGIFBackground()
        setupConstraints()
    }
    
    private func setupGIFBackground() {
        gifImageView.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)
        view.sendSubviewToBack(gifImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
