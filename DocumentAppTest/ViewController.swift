//
//  ViewController.swift
//  DocumentAppTest
//
//  Created by anoop mohanan on 02/07/18.
//  Copyright © 2018 anoop mohanan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var isCameraAvailable = true
    var isPhotolibraryAvailable = true
    enum ImageSource {
        case Photolibrary
        case Camera
    }
    var `imagePickerController`:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.delegate = self
        // Check if camera, library etc are available, accordingly show the options
        validateSources()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Function to check if sources are available
    func `validateSources`() {

        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            isCameraAvailable = false
        }
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            isPhotolibraryAvailable = false
        }
    }
    
    // Show the action sheet
    @IBAction func pickPressed() {

        pick()
    }
    
    // Show the action sheet
    func pick() {

        showActionSheet()
    }

    func showActionSheet() {

        let alertController = UIAlertController(title: "Choose", message: "", preferredStyle: .actionSheet)

        if (isCameraAvailable) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) {[weak self] (_) in
                self?.showImagePickerWith(source: .Camera)
            }
            alertController.addAction(cameraAction)
        }

        if (isPhotolibraryAvailable) {
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) {[weak self] (_) in
                self?.`showImagePickerWith`(source: .Photolibrary)
            }
            alertController.addAction(photoLibrary)
        }

        let previewImageAction = UIAlertAction(title: "PreviewImage", style: .default) {[weak self] (_) in
            self?.previewImage()
        }
        let document = UIAlertAction(title: "Document", style: .default) { [weak self](_) in
            self?.pickDocument()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Cancel")
        }

        alertController.addAction(document)
        alertController.addAction(previewImageAction)
        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)
    }

    // Show an image picker with either camera or photo library as source
    func showImagePickerWith(source: ImageSource) {

        switch source {
        case .Camera:
            imagePickerController.sourceType = .camera
        case .Photolibrary:
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(imagePickerController, animated: true, completion: nil)
    }

    // Load an image from the resource and show it as preview.
    func previewImage() {

        guard let imageURL = Bundle.main.url(forResource: "sample", withExtension: "png")else {
            return
        }
        let documentController = UIDocumentInteractionController(url: imageURL)
        documentController.delegate = self
        documentController.presentPreview(animated: true)
    }

    // Pick a document using DocumentPicker
    func pickDocument() {

        let picker = UIDocumentPickerViewController(documentTypes: ["public.image", "public.movie", "com.adobe.pdf"], in: .open)
        picker.delegate = self
        self.show(picker, sender: self)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension ViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

    }
}
