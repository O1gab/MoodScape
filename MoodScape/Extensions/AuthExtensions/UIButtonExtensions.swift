import UIKit

extension UIButton {
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.35
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}
