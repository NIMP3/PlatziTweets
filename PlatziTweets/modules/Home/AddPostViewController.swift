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
import FirebaseStorage

class AddPostViewController: UIViewController {
    
    //MARK: - Properties
    private var imagePicker: UIImagePickerController?
    
    //MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    //MARK: - IBActions
    @IBAction func AddPostAction() {
        uploadPhotoToFirebase()
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
        imagePicker?.sourceType = .photoLibrary
        //imagePicker?.cameraFlashMode = .off
        //imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    private func uploadPhotoToFirebase() {
        // 1. Aseguramos de que la foto exista
        // 2. Comprimir la imagen y convertirla en Data
        
        guard let imageSaved = previewImageView.image,
              let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else {
                  return
              }
        
        SVProgressHUD.show()
        
        // 3. Configuracción para guardar la foto en Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        // 4. Referencia al storage de firebase
        let storage = Storage.storage()
        
        // 5. Crear nombre de la imagen a subir
        let imageName = Int.random(in: 100...1000)
        
        // 6. Referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "fotos-tweets/\(imageName).jpg")
        
        // 7. Subir la foto a firebase
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(imageSavedData, metadata: metaDataConfig) { metaData, error in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        SVProgressHUD.dismiss()
                        NotificationBanner(title: "ERROR", subtitle: "¡Lo sentimos!, se presento un error \(error.localizedDescription)", style: .danger).show()
                        return
                    }
                    
                    // Obtener la URL de descarga
                    folderReference.downloadURL { url, error in
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: downloadUrl)
                    }
                }
            }
        }
    }

    private func savePost(imageUrl: String?) {
        guard let postText = postTextView.text, !postText.isEmpty else {
            NotificationBanner(title: "Error en Formulario", subtitle: "Por favor ingresa un texto para publicar el tweet", style: .warning).show()
            return
        }
        
        // Creamos el request
        let request = PostRequest(text: postText, imageUrl: imageUrl, videoUrl: nil, location: nil)
        
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
