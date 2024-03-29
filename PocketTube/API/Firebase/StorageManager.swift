//
//  StorageManager.swift
//  Messenger
//
//  Created by LoganMacMini on 2024/1/28.
//

import Foundation
import FirebaseStorage

/// Allows you to get, fetch, and upload files to firebase storage
final class StorageManager {
    
    public static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    /*
     /profile_images/6jt25SXgvDUoVIPFZzHawQLSxBa2-pic.png
     */
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    //Uploads picture to fireboase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("profile_images/\(fileName)").putData(data, metadata: nil) { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
                        
            strongSelf.storage.child("profile_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        }
    }
        
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            
            completion(.success(url))
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}


