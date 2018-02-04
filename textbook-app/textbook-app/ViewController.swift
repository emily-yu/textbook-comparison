//
//  ViewController.swift
//  textbook-app
//
//  Created by Emily on 2/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit
import SwiftOCR

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var input_version: UITextField!
    @IBOutlet var wanted_version: UITextField!
    @IBOutlet var page_number: UITextField!
    
    @IBAction func upload(_ sender: Any) {
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker.allowsEditing = true;
        self.present(imagePicker, animated: true, completion: nil);
    }
    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        imageView.image = chosenImage;
        let imageData: Data! = UIImageJPEGRepresentation(chosenImage, 0.1)
        
        
        let base64String = (imageData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
//     do stuff with image
        dismiss(animated: true, completion: nil);
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil);
    }
    
    func extractText(image: UIImage) {
        print("asdf")
        sendRequest()
        let swiftOCRInstance = SwiftOCR()
        
        swiftOCRInstance.recognize(image) { recognizedString in
            print("ASDF")
            print(recognizedString)
        }
    }
    
    func sendRequest() {
        print(input_version.text)
        print(wanted_version.text)
        print(page_number.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var test_image = #imageLiteral(resourceName: "test_image.png")
        extractText(image: test_image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

