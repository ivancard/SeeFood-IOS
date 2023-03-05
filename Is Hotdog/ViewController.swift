//
//  ViewController.swift
//  Is Hotdog
//
//  Created by ivan cardenas on 05/03/2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imagePlaceHolder: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraAction(_ sender: Any) {
        present(imagePicker, animated: true)
    }
}

//MARK: - ImagePickerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let pickedImage = info[UIImagePickerController.InfoKey.originalImage]

        guard let image = pickedImage as? UIImage else {return}

        imagePlaceHolder.image = image

        imagePicker.dismiss(animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate {

}

