//
//  TestViewController.swift
//  Notes
//
//  Created by Nirav Bavishi on 2018-08-06.
//  Copyright © 2018 Nirav Bavishi. All rights reserved.
//

import UIKit
import MobileCoreServices

class TestViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var openCameraBtn: UIButton!
    
    @IBOutlet weak var imagePicked: UIImageView!
    private var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openCameraBtnTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
            self.present(imagePicker, animated: true, completion: nil)
                
            }
        }
        
        
        
        
    }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("in Fuction1")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
  

}
