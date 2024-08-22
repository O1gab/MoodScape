//
//  ProfileSetup.swift
//  MoodScape
//
//

import UIKit

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // - MARK: ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           // profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDataSource and UIPickerViewDelegate
extension ProfileSetupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location.text = countries[row]
    }
}
