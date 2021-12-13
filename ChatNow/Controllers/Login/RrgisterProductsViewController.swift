//
//  RrgisterProductsViewController.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-07-05.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import DropDown

class RrgisterProductsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.fill.badge.plus")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    private let ProductIDField: UITextField = {
       let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "ProductID"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    private let productCategoryField: UITextField = {
       let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "PproductCategory"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    private let ProductNameField: UITextField = {
       let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
         field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "ProductName"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    private let ProductPriceField: UITextField = {
       let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
         field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "$CAD"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()// productCategory
    private let ProductDescriptionField: UITextField = {
       let field = UITextField()
//field.autocorrectionType = .no
        //field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "ProductDescription"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: -240))
        //field. = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
       // CGRect(origin: CGPoint(x: 5,y: 0),size: CGSize(from: 0 as! Decoder))
        //field.textRect(forBounds:5,0)
        
        field.backgroundColor = .white
        
        return field
    }()
    
    
    private let AddButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add"
        
        view.backgroundColor = .white

        AddButton.addTarget(self,
                              action:#selector(AddButtonTapped),
                              for: .touchUpInside)
        
        ProductIDField.delegate = self
        ProductDescriptionField.delegate = self

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(ProductIDField)
        scrollView.addSubview(productCategoryField)
        scrollView.addSubview(ProductNameField)
        scrollView.addSubview(ProductPriceField)
        scrollView.addSubview(ProductDescriptionField)
        
        scrollView.addSubview(AddButton)
       
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddPic))
        
        imageView.addGestureRecognizer(gesture)
    }
   
    @objc private func didTapAddPic(){
        print("Change pic called")
        presentPhotoActionSheet()
         
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       scrollView.frame = view.bounds
        let size = scrollView.width/3
    
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/4.0
        ProductIDField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width - 60,
                                      height: 52)//productCategory
        productCategoryField.frame = CGRect(x: 30,
                                      y: ProductIDField.bottom+10,
                                      width: scrollView.width - 60,
                                      height: 52)
        ProductNameField.frame = CGRect(x: 30,
                                     y: productCategoryField.bottom+10,
                                     width: scrollView.width - 60,
                                     height: 52)
        ProductPriceField.frame = CGRect(x: 30,
                                     y: ProductNameField.bottom+10,
                                     width: scrollView.width - 60,
                                     height: 52)
        ProductDescriptionField.frame = CGRect(x: 30,
                                  y: ProductPriceField.bottom+10,
                                  width: scrollView.width - 60,
                                  height: 150)
//        passwordField.frame = CGRect(x: 30,
//                                     y: emailField.bottom+10,
//                                     width: scrollView.width - 60,
//                                     height: 52)
        AddButton.frame = CGRect(x: 30,
                                      y: ProductDescriptionField.bottom+10,
                                      width: scrollView.width - 60,
                                      height: 52)
    }
    
    
    func alertAddProductError(message: String =  "Please enter all information to create a new account"){
        let alert = UIAlertController(title: "Woops", message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
   
    @objc private func AddButtonTapped(){
        
        ProductIDField.resignFirstResponder()
        ProductNameField.resignFirstResponder()
        guard let ProductID = ProductIDField.text,
              let productCategory = productCategoryField.text,
              let ProductName = ProductNameField.text,
            let ProductPrice = ProductPriceField.text,
            let ProductDescription = ProductDescriptionField.text,
            !ProductID.isEmpty,
            !productCategory.isEmpty,
            !ProductName.isEmpty,
            !ProductPrice.isEmpty,
            !ProductDescription.isEmpty
            else {
                alertAddProductError()
                return
        }// database
    
        spinner.show(in: view)
        
        DatabaseManager.shared.productExists(with: ProductID, comletion: {[weak self]exists in
            guard let strongSelf = self else {
                print("////////////")
                print(exists)
                return
            }
            //print("////////////")
            print(exists)
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else{
                strongSelf.alertAddProductError(message: "User exits")
                return
            }
            
            let newProduct = Product(productID: ProductID, productName: ProductName, productCategory: productCategory, productPrice: ProductPrice, productDescription: ProductDescription)
            
            DatabaseManager.shared.insertProduct(with: newProduct, completion: {
                success in
                if success{
                    guard let image = strongSelf.imageView.image, let data = image.pngData() else {
                        return
                    }
                    
                    let filename = newProduct.productPictureFileName
                    // uplode item pic
                    StorgeManager.shared.uploadProductPicture(
                        with: data,
                        fileName: filename,
                        completion: { result in
                            switch result{
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "product_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage manager error: \(error)")
                            }
                        })
                }
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
        })   
    }
}

extension RrgisterProductsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ProductIDField {
            ProductDescriptionField.becomeFirstResponder()
        }
        else if textField == ProductDescriptionField {
            AddButtonTapped()
        }
        
        return true
    }
    
}

extension RrgisterProductsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancal",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self]_ in
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: {[weak self]_ in
                                                self?.presentPhotoPicker()
                                                
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
  
