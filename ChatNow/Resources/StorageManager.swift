//
//  StorageManager.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-06-17.
//

import Foundation
import FirebaseStorage

final class StorgeManager {
    
    static let shared = StorgeManager()
    
    private let storage = Storage.storage().reference()
   
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(with data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
    
    
    public func uploadProductPicture(with data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion){
        storage.child("productImages/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("productImages/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
    public enum StorageErrors: Error{
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void){
        let reference = storage.child(path)
        
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            completion(.success(url))
        })
    }
}
