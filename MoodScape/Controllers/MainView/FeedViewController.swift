//
//  FeedViewController.swift
//  MoodScape
//
//

import UIKit

class FeedViewController: MainBaseView {
    
    private let topLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        topLabel.text = "Recently"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 31, weight: .bold)
        topLabel.textAlignment = .left
    }
    
    private func setupConstraints() {
        
    }
}
