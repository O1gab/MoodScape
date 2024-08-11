//
//  BaseView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 12.08.24.
//

import UIKit
import Gifu

class BaseView: UIViewController {
    
    let label = UILabel()
    let gifImageView = GIFImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGIFBackground()
        setupLabel()
        setupConstraints()
    }
    
    private func setupGIFBackground() {
        gifImageView.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)
        view.sendSubviewToBack(gifImageView)
    }

    private func setupLabel() {
        label.text = "MoodScape"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
