//
//  ProductsCollectionViewCell.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-07-07.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductsCollectionViewCell"
    
    static func nib() -> UINib {
         return UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .link
        // Initialization code
    }
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    private let productPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    func viewDidLoad() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPrice)
        
    }
//    override init(style: UICollectionView.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(userImageView)
//        contentView.addSubview(userNameLabel)
//        contentView.addSubview(userMessageLabel)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func layoutSubviews() {
        super.layoutSubviews()

        productImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)

        productNameLabel.frame = CGRect(x: productImageView.right + 10,
                                     y: 10,
                                     width: contentView.width - 20 - productImageView.width,
                                     height: (contentView.height-20)/2)

        productPrice.frame = CGRect(x: productImageView.right + 10,
                                    y: productImageView.bottom + 10,
                                    width: contentView.width - 20 - productImageView.width,
                                        height: (contentView.height-20)/2)

    }
    public func configure(with model: Product) {
        self.productNameLabel.text = model.productName
        self.productPrice.text = model.productPrice

        let path = "productimages/\(model.productID)_picture.png"
        StorgeManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):

                DispatchQueue.main.async {
                    self?.productImageView.sd_setImage(with: url, completed: nil)
                    //self?.downloadImage(imageView: imageView, url: url)
                }

            case .failure(let error):
               // self?.userImageView.sd_setImage(with: url, completed: nil)

                print("failed to get image url: \(error)")
            }
        })
    }
}
