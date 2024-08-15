//
//  GreenDot.swift
//  MoodScape
//
//

import UIKit

class CircleItem: UITabBarItem {
    
    init(title: String?, tag: Int) {
        super.init()
        
        self.title = title
        self.tag = tag
        setupView()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.image = UIImage(systemName: "circle")
    }
    
}
