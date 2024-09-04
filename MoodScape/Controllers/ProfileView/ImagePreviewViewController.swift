//
//  ImagePreviewViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 05.09.24.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupView()
    }

    private func setupView() {
        view.addSubview(imageView)
        imageView.image = image
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 300),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 300)
        ])
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
