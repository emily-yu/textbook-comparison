//
//  ViewController.swift
//  textbook-app
//
//  Created by Emily on 2/3/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit
//import SwiftOCR
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var chosenImage: UIImage! = nil
    
    @IBAction func send(_ sender: Any) {
        print("fired")
        let binaryImageData = base64EncodeImage(chosenImage)
        createRequest(with: binaryImageData)
    }
    
    @IBOutlet var book_name: UITextField!
    @IBOutlet var wanted_version: UITextField!
    @IBOutlet var page_number: UITextField!
//    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    let ngrok = "https://3ac67831.ngrok.io"
    var responseString = ""
    
    var googleAPIKey = "AIzaSyDURLZAzmPCb3czzN2ZwtmjogeiJPB1Wjs"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
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
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        imageView.image = chosenImage;
        let imageData: Data! = UIImageJPEGRepresentation(chosenImage, 0.1)
        
        
        let base64String = (imageData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        
        
//        let binaryImageData = base64EncodeImage(#imageLiteral(resourceName: "test_image.png"))
//        createRequest(with: binaryImageData)
//
        
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
//        sendRequest()
//        let swiftOCRInstance = SwiftOCR()
//        
//        swiftOCRInstance.recognize(image) { recognizedString in
//            print("ASDF")
//            print(recognizedString)
//        }
    }
    
    func sendRequest(response: String) {
        if (book_name.text != "" && wanted_version.text != "" && page_number.text != "") {
            let url = URL(string: "\(ngrok)/compare")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            //        let postString = "id=13&name=Jack"
            let postString = "textbook=\(book_name.text!)&text=\(response)&version=\(wanted_version.text!)&pg=\(page_number.text!)"
            
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                self.responseString = String(data: data, encoding: .utf8)!
                print("responseString = \(self.responseString)")
            }
            task.resume()
//            self.sendRequest(response: responseString)
        }
        else {
            let alertController = UIAlertController(title: "Missing Field", message: "Please provide a valid entry for each of the provided fields.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        print(book_name.text)
        print(wanted_version.text)
        print(page_number.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var test_image = #imageLiteral(resourceName: "test_image.png")
//        extractText(image: test_image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


/// Image processing

extension ViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        print("fired part 4")
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            print("fired part 5")
            // Use SwiftyJSON to parse results
            let json = try! JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
//            self.spinner.stopAnimating()
//            self.imageView.isHidden = true
//            self.labelResults.isHidden = false
//            self.faceResults.isHidden = false
//            self.faceResults.text = ""
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
//                self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                let responses: JSON = json["responses"][0]
                print(responses["fullTextAnnotation"]["text"])
                self.responseString = responses["fullTextAnnotation"]["text"].string!
                self.sendRequest(response: self.responseString)
                
                // Get face annotations
//                let faceAnnotations: JSON = responses["faceAnnotations"]
//                if faceAnnotations != nil {
//                    let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
//
//                    let numPeopleDetected:Int = faceAnnotations.count
//
////                    self.faceResults.text = "People detected: \(numPeopleDetected)\n\nEmotions detected:\n"
//
//                    var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
//                    var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
//
//                    for index in 0..<numPeopleDetected {
//                        let personData:JSON = faceAnnotations[index]
//
//                        // Sum all the detected emotions
//                        for emotion in emotions {
//                            let lookup = emotion + "Likelihood"
//                            let result:String = personData[lookup].stringValue
//                            emotionTotals[emotion]! += emotionLikelihoods[result]!
//                        }
//                    }
//                    // Get emotion likelihood as a % and display in UI
//                    for (emotion, total) in emotionTotals {
//                        let likelihood:Double = total / Double(numPeopleDetected)
//                        let percent: Int = Int(round(likelihood * 100))
////                        self.faceResults.text! += "\(emotion): \(percent)%\n"
//                    }
//                } else {
////                    self.faceResults.text = "No faces found"
//                }
                
//                // Get label annotations
//                let labelAnnotations: JSON = responses["labelAnnotations"]
//                let numLabels: Int = labelAnnotations.count
//                var labels: Array<String> = []
//                if numLabels > 0 {
//                    var labelResultsText:String = "Labels found: "
//                    for index in 0..<numLabels {
//                        let label = labelAnnotations[index]["description"].stringValue
//                        labels.append(label)
//                    }
//                    for label in labels {
//                        // if it's not the last item add a comma
//                        if labels[labels.count - 1] != label {
//                            labelResultsText += "\(label), "
//                        } else {
//                            labelResultsText += "\(label)"
//                        }
//                    }
////                    self.labelResults.text = labelResultsText
//                } else {
////                    self.labelResults.text = "No labels found"
//                    print("no lables foudn")
//                }
            }
        })
        
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .scaleAspectFit
//            imageView.isHidden = true // You could optionally display the image here by setting imageView.image = pickedImage
//            spinner.startAnimating()
//            faceResults.isHidden = true
//            labelResults.isHidden = true
//
//            // Base64 encode the image and create the request
//            //            let binaryImageData = base64EncodeImage(pickedImage)
//            let binaryImageData = base64EncodeImage(#imageLiteral(resourceName: "test.png"))
//            createRequest(with: binaryImageData)
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


/// Networking

extension ViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        print("fired part 2")
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        print("fired part 3")
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            print(data)
            print(response)
            guard let data = data, error == nil else {
                print("ASDFASDFASDFSDAFAD")
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

