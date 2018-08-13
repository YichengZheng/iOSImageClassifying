//
//  ViewController.swift
//  SeeFood
//
//  Created by Yicheng Zheng on 8/13/18.
//  Copyright © 2018 Yicheng Zheng. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // original unedited image selected by user

        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{

            imageView.image = userPickedImage
            SVProgressHUD .show()
            guard let ciimage = CIImage(image : userPickedImage) else{
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    func detect(image: CIImage){

        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Loading CoreML Model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process image")
            }
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier

            }
        }
        

        let handler = VNImageRequestHandler(ciImage: image)
        
        do{

            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

