//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ksionek, Karol on 12/08/2021.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let biggerSize = max(view.frame.size.height, view.frame.size.width)
        let space:CGFloat = 3.0
        let dimension = (biggerSize - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeCollectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        vc.meme = appDelegate.memes[indexPath.row]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionItem", for: indexPath) as! MemeCollectionItem
        
        cell.image.image = appDelegate.memes[indexPath.row].memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
}
