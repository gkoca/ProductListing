//
//  ProductCollectionViewCell.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
