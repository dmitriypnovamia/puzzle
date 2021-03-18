//
//  FAImageCropperVC.swift
//  FAImageCropper
//
//  Created by Fahid Attique on 11/02/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit
import Photos

class FAImageCropperVC: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: FAScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnZoom: UIButton!
    @IBOutlet weak var btnCrop: UIButton!
    @IBAction func zoom(_ sender: Any) {
        scrollView.zoom()
    }
    
    let primaryColor = #colorLiteral(red: 0.6271930337, green: 0.3653797209, blue: 0.8019730449, alpha: 1)
    let primaryColorDark = #colorLiteral(red: 0.5373370051, green: 0.2116269171, blue: 0.7118118405, alpha: 1)
    
    func openPuzzleWith(puzzleImage:UIImage, size: Int)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.puzzleText = "Congratulation, Puzzle solved"
        viewController.puzzleImage = puzzleImage
        viewController.gridSize = Int32(size)
        viewController.puzzleId = ""
        
        self.navigationController?.pushFadeViewController(viewController)
        
    }
    
    
    @IBAction func back() {
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func crop(_ sender: Any) {
        croppedImage = captureVisibleRect()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chooseGameTypeViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseGameTypeViewController") as! ChooseGameTypeViewController
        
        chooseGameTypeViewController.img = croppedImage
        
        self.navigationController?.pushFadeViewController(chooseGameTypeViewController)
        
        //self.askToPlayOrShare(image: croppedImage!)
    }
    
    func askGridSize()  {
        let dialogController = AZDialogViewController(title: "Select Grid Size", message: "")
        dialogController.dismissDirection = .none
        //dialogController.dismissWithOutsideTouch = false
        
        dialogController.addAction(AZDialogAction(title: "3X3", handler: { (dialog) -> (Void) in
            dialog.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.openPuzzleWith(puzzleImage: self.croppedImage!, size: 3)
                })
            })
        }))
        
        dialogController.addAction(AZDialogAction(title: "4X4", handler: { (dialog) -> (Void) in
            dialog.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.openPuzzleWith(puzzleImage: self.croppedImage!, size: 4)
                })
            })
        }))
        
        dialogController.addAction(AZDialogAction(title: "5X5", handler: { (dialog) -> (Void) in
            dialog.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.openPuzzleWith(puzzleImage: self.croppedImage!, size: 5)
                })
                
            })
        }))
        
        
        dialogController.titleColor = .white
        dialogController.buttonStyle = { (button,height,position) in
            //button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            //            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        dialogController.show(in: self)
    }
    
    
    
    // MARK: Public Properties
    
    var photos:[PHAsset]!
    var imageViewToDrag: UIImageView!
    var indexPathOfImageViewToDrag: IndexPath!
    
    let cellWidth = ((UIScreen.main.bounds.size.width)/3)-1
    
    
    // MARK: Private Properties
    
    private let imageLoader = FAImageLoader()
    private var croppedImage: UIImage? = nil

    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        viewConfigurations()
        checkForPhotosPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FADetailViewSegue" {
            
            let detailVC = segue.destination as? FADetailVC
            detailVC?.croppedImage = croppedImage
        }
    }
    
    // MARK: Private Functions
    
    private func checkForPhotosPermission(){
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            loadPhotos()
        }
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                    DispatchQueue.main.async {
                        self.loadPhotos()
                    }
                }
                else {
                    // Access has been denied.
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    private func viewConfigurations() {
        
        navigationBarConfigurations()
        //btnCrop.layer.cornerRadius = btnCrop.frame.size.width/2
        //btnZoom.layer.cornerRadius = btnZoom.frame.size.width/2
    }
    
    private func navigationBarConfigurations() {
    
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .black), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(color: .clear)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }

    
    private func loadPhotos(){

        imageLoader.loadPhotos { (assets) in
            self.configureImageCropper(assets: assets)
        }
    }
    
    private func configureImageCropper(assets:[PHAsset]){

        if assets.count != 0{
            photos = assets
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            selectDefaultImage()
        }
    }

    private func selectDefaultImage(){
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
        selectImageFromAssetAtIndex(index: 0)
    }
    
    
    private func captureVisibleRect() -> UIImage{
        
        var croprect = CGRect.zero
        let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
        let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
        
        croprect.origin.x = scrollView.contentOffset.x * xOffset;
        croprect.origin.y = scrollView.contentOffset.y * yOffset;
        
        let normalizedWidth = (scrollView?.frame.width)! / (scrollView?.contentSize.width)!
        let normalizedHeight = (scrollView?.frame.height)! / (scrollView?.contentSize.height)!
        
        croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
        croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollView.imageView.image?.fixImageOrientation()
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        let cropped = UIImage(cgImage: cr!)
        
        return cropped

    }
    private func isSquareImage() -> Bool{
        let image = scrollView.imageToDisplay
        if image?.size.width == image?.size.height { return true }
        else { return false }
    }

    
    // MARK: Public Functions

    func selectImageFromAssetAtIndex(index:NSInteger){
        
        FAImageLoader.imageFrom(asset: photos[index], size: PHImageManagerMaximumSize) { (image) in
            DispatchQueue.main.async {
                self.displayImageInScrollView(image: image)
            }
        }
    }
    
    func displayImageInScrollView(image:UIImage){
        self.scrollView.imageToDisplay = image
        /*
        if isSquareImage() {
            btnZoom.isHidden = true
            
        }
        else {
            btnZoom.isHidden = false
            
        }
 */
    }
    
    func replicate(_ image:UIImage) -> UIImage? {
        
        guard let cgImage = image.cgImage?.copy() else {
            return nil
        }

        return UIImage(cgImage: cgImage,
                               scale: image.scale,
                               orientation: image.imageOrientation)
    }
    

    @objc func handleLongPressGesture(recognizer: UILongPressGestureRecognizer) {

        let location = recognizer.location(in: view)

        if recognizer.state == .began {

            let cell: FAImageCell = recognizer.view as! FAImageCell
            indexPathOfImageViewToDrag = collectionView.indexPath(for: cell)
            imageViewToDrag = UIImageView(image: replicate(cell.imageView.image!))
            imageViewToDrag.frame = CGRect(x: location.x - cellWidth/2, y: location.y - cellWidth/2, width: cellWidth, height: cellWidth)
            view.addSubview(imageViewToDrag!)
            view.bringSubviewToFront(imageViewToDrag!)
        }
        else if recognizer.state == .ended {
            
            if scrollView.frame.contains(location) {
                collectionView.selectItem(at: indexPathOfImageViewToDrag, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
              selectImageFromAssetAtIndex(index: indexPathOfImageViewToDrag.item)
            }
            
            imageViewToDrag.removeFromSuperview()
            imageViewToDrag = nil
            indexPathOfImageViewToDrag = nil
        }
        else{
            imageViewToDrag.center = location
        }
    }
}





extension FAImageCropperVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell:FAImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FAImageCell", for: indexPath) as! FAImageCell
        cell.populateDataWith(asset: photos[indexPath.item])
        cell.configureGestureWithTarget(target: self, action: #selector(FAImageCropperVC.handleLongPressGesture))
        
        return cell
    }
}


extension FAImageCropperVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:FAImageCell = collectionView.cellForItem(at: indexPath) as! FAImageCell
        cell.isSelected = true
        selectImageFromAssetAtIndex(index: indexPath.item)
    }
}


extension FAImageCropperVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
