//
//  PhotoDetailsTableViewCell.swift
//  PhotoSearchGallary
//
//  Created by  Daniel 18/04/22..
//

import Foundation
import UIKit

class PhotoDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flickImage: UIImageView!
    @IBOutlet weak var imgDesc: UILabel!
    
    override func prepareForReuse() {
        self.flickImage.image = nil
    }
    
    func setData(_ photoDetail: PhotoDetail) {
        imgDesc.text = photoDetail.title
//        let url = URL(string: photoDetail.url)
//        flickImage.kf.setImage(with:url)
    }

}
