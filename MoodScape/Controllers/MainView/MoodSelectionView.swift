//
//  MoodSelectionView.swift
//  MoodScape
//
//

import UIKit

class PopUpViewController: UIViewController {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(PopUpViewController.self, action: #selector(closePopUp), for: .touchUpInside)
        return closeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(contentView)
        contentView.addSubview(closeButton)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            animateShow()
        }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 720),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    @objc func closePopUp() {
            animateHide()
        }
    
    func animateShow() {
           contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
           UIView.animate(withDuration: 0.3, animations: {
               self.contentView.transform = .identity
           })
       }
       
       func animateHide() {
           UIView.animate(withDuration: 0.3, animations: {
               self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
           }) { _ in
               self.dismiss(animated: false, completion: nil)
           }
       }
}
