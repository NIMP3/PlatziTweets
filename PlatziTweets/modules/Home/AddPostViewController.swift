//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 22/02/22.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBanner

class AddPostViewController: UIViewController {
    
    //MARK: - Properties
    private var imagePicker: UIImagePickerController?
    
    //MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    //MARK: - IBActions
    @IBAction func AddPostAction() {
        savePost()
    }
    
    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCameraAction() {
        openCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        postTextView.layer.borderColor = UIColor.gray.cgColor
        postTextView.layer.borderWidth = 0.5
        postTextView.layer.cornerRadius = 5.0
    }
    
    private func openCamera() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)

    }

    private func savePost() {
        guard let postText = postTextView.text, !postText.isEmpty else {
            NotificationBanner(title: "Error en Formulario", subtitle: "Por favor ingresa un texto para publicar el tweet", style: .warning).show()
            return
        }
        
        // Creamos el request
        let request = PostRequest(text: postText, imageUrl: nil, videoUrl: nil, location: nil)
        
        // Iniciamos el progressbar
        SVProgressHUD.show()
        
        // Configuramos y consumimos el servicio
        SN.post(endpoint: Endpoints.posts, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
            
            // Detenemos el progressbar
            SVProgressHUD.dismiss()
            
            switch response {
            case .success:
                self.dismissAction()
            case .error(let error):
                NotificationBanner(title: "ERROR", subtitle: "¡Lo sentimos!, se presento un error \(error.localizedDescription)", style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "ERROR", subtitle: entity.error, style: .warning).show()
            }
        }
        
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Cerrar cámara
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage) {
            previewImageView.isHidden = false
            // Obtenemos la imagen tomada
            previewImageView.image = info[.originalImage] as? UIImage
        }
    }
}
