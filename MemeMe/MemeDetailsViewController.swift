//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Ksionek, Karol on 13/08/2021.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    var meme: Meme? = nil
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImage.image = meme!.memedImage
    }
}
