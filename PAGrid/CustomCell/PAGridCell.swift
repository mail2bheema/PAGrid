//
//  PAGridCell.swift
//  PAGrid
//
//  Created BheemaBadri on 15/04/24.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    private func setupImageView() {
        guard imageView == nil else { return }
        
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = 10.0
        contentView.addSubview(imageView)
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = imageView.center
        activityIndicator.startAnimating()
        imageView.addSubview(activityIndicator)
    }

    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
