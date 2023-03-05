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
    @IBOutlet weak var isHotDogView: UIView!
    @IBOutlet weak var notHotDogView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraAction(_ sender: Any) {
        self.notHotDogView.isHidden = true
        self.isHotDogView.isHidden = true
        present(imagePicker, animated: true)
    }
}

//MARK: - ImagePickerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let pickedImage = info[UIImagePickerController.InfoKey.originalImage]

        guard let image = pickedImage as? UIImage else {return}

        imagePlaceHolder.image = image

        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not convert to ciImage")
        }
        detect(image: ciImage)
        imagePicker.dismiss(animated: true)
    }

    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            fatalError("Can't load ML model no")
        }

        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process the image")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.notHotDogView.isHidden = true
                    self.isHotDogView.isHidden = false
                } else {
                    self.notHotDogView.isHidden = false
                    self.isHotDogView.isHidden = true
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

extension ViewController: UINavigationControllerDelegate {

}

