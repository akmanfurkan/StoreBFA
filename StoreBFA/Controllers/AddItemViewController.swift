//
//  AddItemViewController.swift
//  StoreBFA
//
//  Created by Furkan Akman on 17.01.2023.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    //MARK: IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var priceTextField: UITextField!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    //MARK: Vars
    var category: Category!
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?
    
    
    var itemImages: [UIImage?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category.id)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60 ), type: .ballPulse, color: #colorLiteral(red:0.9998469949,green: 0.4941213727,blue:0.4734867811,alpha:1),padding: nil)
    }
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        
        if fieldsAreCompleted(){
            saveToFirebase()
        }
        else {
            print("Tüm boşluklar dolu değil!")
            self.hud.textLabel.text = "Tüm boşluklar dolu değil"
            self.hud.indicatorView = JGProgressHUDIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        
        showImageGAllery()
    }
    
    
    
    //MARK:Helper func
    private func fieldsAreCompleted() -> Bool {
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    //MARK:Back to items
    //MARK:Önceki vcye dönmek için
    private func popTheView(){
        self.navigationController?.popViewController(animated: true)
        
    }
    //MARK: Save Item
    private func saveToFirebase() {
        
        showLoadingIndicator()
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryId = category.id
        item.description = descriptionTextView.text
        item.price = Double(priceTextField.text!)
        
        if itemImages.count > 0 {
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray)
                in
                item.imageLinks = imageLinkArray
                
                saveItemToFirestore(item)
                
                self.hideLoadingIndicator()
                self.popTheView()
                
                
            }
            
            
        } else {
            saveItemToFirestore(item)
            popTheView()
        }
        
    }
    
    
    //MARK: Activty Indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
        
    }
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    
    //MARK: Show Gallery
    private func showImageGAllery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
        
    }
}




extension AddItemViewController: GalleryControllerDelegate {
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages)in
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
}
