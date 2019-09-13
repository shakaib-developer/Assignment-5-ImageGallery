//
//  ImageGalleryViewController.swift
//  ImageGallery-Assignment4
//
//  Created by Shakaib Akhtar on 12/09/2019.
//  Copyright © 2019 iParagons. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate, UICollectionViewDragDelegate
{
    
    var flowLayout: UICollectionViewFlowLayout? {
        return GalleryCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    @IBAction func PinchGesture(_ sender: UIPinchGestureRecognizer) {
//        var newCellWidth: CGFloat = flowLayout!.itemSize.width
//        var newCellHeight: CGFloat = flowLayout!.itemSize.height
        
        if sender.scale < 1 {
            flowLayout!.itemSize.width += 100
            flowLayout!.itemSize.height += 100
        }
        else {
            flowLayout!.itemSize.width -= 100
            flowLayout!.itemSize.height -= 100
        }
        
        flowLayout?.invalidateLayout()
//        let cellSize = CGSize(width: newCellWidth, height: newCellHeight)
//        currentCellSize = cellSize
    }
    
//    var currentCellSize: CGSize! {
//        didSet {
//            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .vertical
//            layout.itemSize = currentCellSize
//            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//            layout.minimumLineSpacing = 1.0
//            layout.minimumInteritemSpacing = 1.0
//            GalleryCollectionView.setCollectionViewLayout(layout, animated: false)
//        }
//    }
    
    var GalleryImages:[UIImage] = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GalleryImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.imageViewInCell.image = GalleryImages[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageWidth = flowLayout!.itemSize.width
        let imageHeight = flowLayout!.itemSize.height

        let cellWidth: CGFloat = view.frame.size.width / 4
        let aspectRatio: CGFloat = imageWidth / imageHeight

        return CGSize(width: cellWidth, height: aspectRatio * cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return (session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: URL.self)) || (session.canLoadObjects(ofClass: UIImage.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let img = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates({
                        GalleryImages.remove(at: sourceIndexPath.item)
                        GalleryImages.insert(img, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
            else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceHolderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let img = provider as? UIImage {

                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.GalleryImages.insert(img, at: insertionIndexPath.item)
                            })
                        }
                        else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let img = (GalleryCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageViewInCell.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: img))
            dragItem.localObject = img
            return [dragItem]
        }
        else {
            return []
        }
    }
    
    @IBOutlet weak var GalleryCollectionView: UICollectionView! {
        didSet {
            GalleryCollectionView.dataSource = self
            GalleryCollectionView.delegate = self
            GalleryCollectionView.dragDelegate = self
            GalleryCollectionView.dropDelegate = self
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
