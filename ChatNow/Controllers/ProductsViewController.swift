//
//  ProductsViewController.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-07-05.
//

import UIKit

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    
        
    struct productInfo{
        let id: String
        let name: String
        let price: String
        let category: String
        
    }
    
     var collectionView: UICollectionView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right:  5)
        layout.itemSize = CGSize(width: view.frame.size.width/2.2, height: view.frame.size.width/2.2)
       
        
        
        
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        
        collectionView?.register(ProductsCollectionViewCell.nib(),
                                 forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        
        collectionView?.register(ProductHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductHeaderCollectionReusableView.indentifier)
        collectionView?.register(ProductFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProductFooterCollectionReusableView.indentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        view.addSubview(collectionView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
        if !isAdmin{
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Add",
                style: .done,
                target: self,
                action: #selector(didTapAdd))
        }
        // let nav = UINavigationController(rootViewController: )
    }
    
    
    @objc private func didTapAdd(){
        print("in")
        let vc = RrgisterProductsViewController()
        vc.title = "Add Product"
        navigationController?.pushViewController(vc, animated: true)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 1 {
            
        }
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProductFooterCollectionReusableView.indentifier, for: indexPath) as! ProductFooterCollectionReusableView
            
            footer.configure()
            return footer
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductHeaderCollectionReusableView.indentifier, for: indexPath) as! ProductHeaderCollectionReusableView
        
        header.configure()
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
}
