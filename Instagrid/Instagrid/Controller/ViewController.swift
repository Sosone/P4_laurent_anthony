//
//  ViewController.swift
//  Instagrid
//
//  Created by Anthony Laurent on 03/08/2021.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var swipeLabel: UILabel!
    var currentImageButton: UIButton!
    @IBOutlet weak var pictureView: UIView!
    
    @IBOutlet weak var layout1XConstraint: NSLayoutConstraint!
    @IBOutlet weak var layout1YConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var layout2YConstraint: NSLayoutConstraint!
    @IBOutlet weak var layout2XConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var layout3XConstraint: NSLayoutConstraint!
    @IBOutlet weak var layout3YConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTop: UIButton!
    @IBOutlet weak var rightTop: UIButton!
    @IBOutlet weak var leftBottom: UIButton!
    @IBOutlet weak var rightBottom: UIButton!
    
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTop.isHidden = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragPictureView(sender:)))
        pictureView.addGestureRecognizer(panGestureRecognizer)
    }

     @objc func dragPictureView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began , .changed :
            transformPictureViewWith(gesture: sender)
        case .cancelled , .ended:
            let translation = sender.translation(in: pictureView)
            let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
            if traitCollection.horizontalSizeClass == .compact
                , traitCollection.verticalSizeClass == .regular
               , translation.y < 0
            {
                sharedImage()
            } else if traitCollection.horizontalSizeClass == .regular
                      , traitCollection.verticalSizeClass == .compact
                      , translation.x < 0
            {
                sharedImage()
            }
            pictureView.transform = .identity
        default:
            break
        }
        
    }
    
    @IBAction func tapLayout1(_ sender: Any) {
        layout3XConstraint.isActive = false
        layout3YConstraint.isActive = false
        layout2XConstraint.isActive = false
        layout2YConstraint.isActive = false
        layout1XConstraint.isActive = true
        layout1YConstraint.isActive = true
        leftTop.isHidden = true
        rightTop.isHidden = false
        leftBottom.isHidden = false
        rightBottom.isHidden = false
    }

    @IBAction func tapLayout2(_ sender: Any) {
        layout3XConstraint.isActive = false
        layout3YConstraint.isActive = false
        layout1XConstraint.isActive = false
        layout1YConstraint.isActive = false
        layout2XConstraint.isActive = true
        layout2YConstraint.isActive = true
        leftTop.isHidden = false
        rightTop.isHidden = false
        leftBottom.isHidden = true
        rightBottom.isHidden = false
    }
    
    @IBAction func tapLayout3(_ sender: Any) {
        layout2XConstraint.isActive = false
        layout2YConstraint.isActive = false
        layout1XConstraint.isActive = false
        layout1YConstraint.isActive = false
        layout3XConstraint.isActive = true
        layout3YConstraint.isActive = true
        leftTop.isHidden = false
        rightTop.isHidden = false
        leftBottom.isHidden = false
        rightBottom.isHidden = false
    }
    
    @IBAction func addPicture1(_ sender: Any) {
        chooseImage()
        currentImageButton = leftTop
    }
  
    @IBAction func addPicture2(_ sender: Any) {
        chooseImage()
        currentImageButton = rightTop
    }
    
    @IBAction func addPicture3(_ sender: Any) {
        chooseImage()
        currentImageButton = leftBottom
    }
    
    @IBAction func addPicture4(_ sender: Any) {
        chooseImage()
        currentImageButton = rightBottom
    }

    
    private func chooseImage()
    {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            let actionSheet = UIAlertController(title: "Photo source", message: "choose a source", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func newButtonBackground(img: UIImage, btn: UIButton)
    {
        let mainImageView = UIImageView(image:img)
        mainImageView.contentMode = .scaleAspectFill
        btn.setBackgroundImage(mainImageView.image, for: .normal)
        btn.setTitle("", for: .normal)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        newButtonBackground(img: image, btn: currentImageButton)
        picker.dismiss(animated: true, completion: nil)
        
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.horizontalSizeClass == .compact
           , traitCollection.verticalSizeClass == .regular
        {
            swipeLabel.text = "swipe up to share"
        }
        else
        {
            swipeLabel.text = "swipe left to share"
        }
    }
        
        
    private func transformPictureViewWith(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: pictureView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        if traitCollection.horizontalSizeClass == .compact
            , traitCollection.verticalSizeClass == .regular
           , translation.y < 0
        {
            let screenHeight = UIScreen.main.bounds.height
            let translationPercent = translation.y / (screenHeight / 2)
            let rotationAngle = (CGFloat.pi / 6) * translationPercent
            
            let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
            
            let transform = translationTransform.concatenating(rotationTransform)
            pictureView.transform = transform
            
        } else if traitCollection.horizontalSizeClass == .regular
                  , traitCollection.verticalSizeClass == .compact
                  , translation.x < 0
        {
            let screenWidth = UIScreen.main.bounds.width
            let translationPercent = translation.x / (screenWidth / 2)
            let rotationAngle = (CGFloat.pi / 6) * translationPercent
                
            let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
                
            let transform = translationTransform.concatenating(rotationTransform)
            pictureView.transform = transform
        }
    }
        
     private func recupImage(view: UIView) -> UIImage
     {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
     }
    
     private func sharedImage()
     {
        let image = recupImage(view: pictureView)
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
     }
}
    




