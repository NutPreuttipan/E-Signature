//
//  SignatureViewController.swift
//  E-Signature
//
//  Created by NUTiOS on 4/2/2564 BE.
//

import UIKit


class SignatureViewController: UIViewController {
    
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewSignature: UIViewSignature!
    @IBOutlet weak var buttonTakePhoto: UIButton!
    @IBOutlet weak var buttonSavePhoto: UIButton!
    
    var isSignSignature:Bool = false
    var isTakePhoto:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSignature.backgroundColor = .clear
        viewSignature.delegate = self
        viewSignature.isUserInteractionEnabled = false
    }
    
    func viewToImage(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    func showAlert(title:String, message:String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "ตกลง", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        switch sender {
        case buttonTakePhoto:
            openCamera()
        case buttonSavePhoto:
            guard isTakePhoto else {
                showAlert(title: "แจ้งเตือน", message: "กรุณาถ่ายรูป")
                return
            }
            
            guard isSignSignature else {
                showAlert(title: "แจ้งเตือน", message: "กรุณาเซ็นลายเซ็น")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(viewToImage(with: viewContent)!, nil, nil, nil)
        default:
            break;
        }
    }
}

extension SignatureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.availableCaptureModes(for: .front) != nil {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.sourceType = .camera
            pickerController.modalPresentationStyle = .fullScreen
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        isTakePhoto = true
        viewSignature.isUserInteractionEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SignatureViewController: UIViewSignatureProtocol {
    func didFinishSign() {
        isSignSignature = true
    }
}
