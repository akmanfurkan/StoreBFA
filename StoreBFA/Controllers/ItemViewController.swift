//
//  ItemViewController.swift
//  StoreBFA
//
//  Created by Furkan Akman on 17.01.2023.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!


    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Vars
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight: CGFloat = 196.0
    private let itemsPerRow: CGFloat = 1
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures()

    }
    //MARK: Download picture
    
    private func downloadPictures() {
        if item != nil && item.imageLinks != nil {
            
            downloadImages(imageUrls: item.imageLinks) { (allImages)in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARk: Setup uı
    
    private func setupUI() {
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
    }
    
    //MARk: IBAction
    
    
  
    @IBAction func AddToBasketPressed(_ sender: Any) {
        downloadBasketFromFirestore("1234") { (basket)in
            if basket == nil {
                self.createNewBasket()
                    
                } else {
                    basket.itemIds.append(self.item.id)
                    self.updateBasket(basket: basket, withValues: [kITEMIDS:basket.itemIds])
                }
        }
        
    }
    
    
//MARK: add to basket
    func createNewBasket() {
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = "1234"
        newBasket.itemIds = [self.item.id]
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Sepete eklendi"
        self.hud.indicatorView = JGProgressHUDIndicatorView()
        self.hud.dismiss(afterDelay: 2.0)
        self.hud.show(in: self.view)
        
    }
    private func updateBasket(basket: Basket, withValues: [String: Any]) {
        updateBasketInFirestore(basket, withValues: withValues) { (error ) in
            if error != nil {
                self.hud.textLabel.text = "Sepete eklendi"
                self.hud.indicatorView = JGProgressHUDIndicatorView()
                self.hud.dismiss(afterDelay: 2.0)
                self.hud.show(in: self.view)
            }else {
                    self.hud.textLabel.text = "Sepete eklendi"
                    self.hud.indicatorView = JGProgressHUDIndicatorView()
                    self.hud.dismiss(afterDelay: 2.0)
                    self.hud.show(in: self.view)
            }
        }
        
    }

}
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 :itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hucre", for: indexPath) as! ImageCollectionViewCell
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        
        return cell

    }
}
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
