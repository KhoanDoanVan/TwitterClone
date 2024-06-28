//
//  ImageUploader.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import SwiftUI
import FirebaseStorage
import Firebase


struct ImageUploader {

    static func uploadMedia(media: Any, type: TypeUpload) async throws -> String? {
        let filename = UUID().uuidString
        
        var contentType: String = ""
        var data: Data?
        let storageRef: StorageReference
        
        switch type {
        case .backgroundProfile:
            if let image = media as? UIImage {
                storageRef = Storage.storage().reference(withPath: "/profile_background_image/\(filename)")
                data = image.jpegData(compressionQuality: 1)
            } else {
                return nil
            }
        case .imageProfile:
            if let image = media as? UIImage {
                storageRef = Storage.storage().reference(withPath: "/profile_user_image/\(filename)")
                data = image.jpegData(compressionQuality: 0.25)
            } else {
                return nil
            }
        case .imageTweet:
            if let image = media as? UIImage {
                storageRef = Storage.storage().reference(withPath: "/tweet_image/\(filename)")
                data = image.jpegData(compressionQuality: 1)
            } else {
                return nil
            }
        case .videoTweet:
            if let videoURL = media as? URL {
                storageRef = Storage.storage().reference(withPath: "/tweet_video/\(filename)")
                contentType = "video/quicktime"
                
                do {
                    data = try Data(contentsOf: videoURL)
                } catch {
                    print("Error converting video to Data: \(error.localizedDescription)")
                    return nil
                }
            } else {
                return nil
            }
            
        case .imageMessage:
            print("correctly case")
            if let image = media as? UIImage {
                storageRef = Storage.storage().reference(withPath: "/image_message/\(filename)")
                data = image.jpegData(compressionQuality: 1)
            } else {
                return nil
            }
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = contentType
        
        do {
            if let data = data {
                let _ = try await storageRef.putDataAsync(data, metadata: metadata)
                let url = try await storageRef.downloadURL()
                return url.absoluteString
            } else {
                return nil
            }
        } catch {
            print("Error uploading media: \(error.localizedDescription)")
            return nil
        }
    }
    
    private static func getImageData(from image: UIImage) -> Data? {
            // Convert the image to JPEG or PNG data based on its format
        if let jpegData = image.jpegData(compressionQuality: 0.25) {
            return jpegData
        } else if let pngData = image.pngData() {
            return pngData
        }
        return nil
    }
    
    private static func getImageContentType(from imageData: Data) -> String {
        // Determine the content type based on the image data
        if let source = CGImageSourceCreateWithData(imageData as CFData, nil),
           let type = CGImageSourceGetType(source) {
            return type as String
        }
        // Default to JPEG if content type cannot be determined
        return "image/jpeg"
    }
}

