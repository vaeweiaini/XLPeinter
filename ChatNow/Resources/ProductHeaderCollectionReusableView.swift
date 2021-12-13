//
//  ProductHeaderCollectionReusableView.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-07-07.
//

import UIKit

class ProductHeaderCollectionReusableView: UICollectionReusableView {
        
    static let indentifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "header"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    public func configure(){
        backgroundColor = .green
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}

class ProductFooterCollectionReusableView: UICollectionReusableView {
        
    static let indentifier = "FooterCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "footer"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    public func configure(){
        backgroundColor = .green
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
