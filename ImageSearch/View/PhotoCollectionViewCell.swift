//
//  PhotoCollectionViewCell.swift
//  PhotoSearchGallary
//
//  Created by Daniel 18/04/22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImageView.image = nil
    }
    
}
