//
//  ImageUploader.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import Foundation
import Firebase
import FirebaseStorage

enum UploadType {
    case profile
    case media
    
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        case .media:
            return Storage.storage().reference(withPath: "/media_images/\(filename)")
        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, type: UploadType) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let ref = type.filePath
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadImage(image: UIImage, type: UploadType, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let ref = type.filePath
        
        ref.putData(imageData) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                completion(nil, error)
            } else {
                ref.downloadURL { url, error in
                    guard let downloadUrl = url?.absoluteString, error == nil else {
                        completion(nil, error)
                        return
                    }
                    completion(downloadUrl, nil)
                }
            }
            
        }
    }
}
