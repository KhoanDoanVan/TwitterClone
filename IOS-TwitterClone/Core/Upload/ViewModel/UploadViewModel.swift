//
//  UploadViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import Firebase
import Photos
import SwiftUI
import AVKit

class UploadViewModel : NSObject, ObservableObject, PHPhotoLibraryChangeObserver, Observable {
    
    @Published var content : String = ""
    @Published var imagePreview : UIImage?
    @Published var videoPreview : URL?
    @Published var isWrite : Bool = false
    
    // handle Picker Image and Video
    @Published var showPickerFrame : Bool = false
    @Published var libraryStatus : LibraryStatus = .denied
    @Published var fetchPhotos : [Asset] = []
    @Published var allPhotos : PHFetchResult<PHAsset>!
    
    // realtime firebase
    @Published var ref : DatabaseReference! = Database.database().reference()
    
    func openImagePicker() {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        if fetchPhotos.isEmpty {
            fetchPhotosFromLibrary()
        }
        
        withAnimation {
            self.showPickerFrame.toggle()
        }
    }
    
    func setUp() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {[self] status in
            DispatchQueue.main.async {
                switch status {
                case .denied: self.libraryStatus = .denied
                case .authorized: self.libraryStatus = .authorized
                case .limited: self.libraryStatus = .limited
                default : self.libraryStatus = .denied
                }
            }
        }
        
        PHPhotoLibrary.shared().register(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let _ = allPhotos else { return }
        
        if let updates = changeInstance.changeDetails(for: allPhotos) {
            
            let updatePhoto = updates.fetchResultAfterChanges
            
            updatePhoto.enumerateObjects { [self] asset, index, _ in
                if !allPhotos.contains(asset) {
                    getImageFromAsset(asset: asset, size: CGSize(width: 150, height: 150)) { image in
                        DispatchQueue.main.async {
                            self.fetchPhotos.append(Asset(asset: asset, image: image))
                        }
                    }
                }
            }
            
            allPhotos.enumerateObjects { asset, index, _ in
                if !updatePhoto.contains(asset) {
                    DispatchQueue.main.async {
                        self.fetchPhotos.removeAll { result -> Bool in
                            return asset == result.asset
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.allPhotos = updatePhoto
            }
        }
    }

    
    func fetchPhotosFromLibrary() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        options.includeHiddenAssets = false
        
        let results = PHAsset.fetchAssets(with: options)
        
        allPhotos = results
        
        results.enumerateObjects {[self] asset, index, _ in
            getImageFromAsset(asset: asset, size: CGSize(width: 150, height: 150)) { image in
                self.fetchPhotos.append(Asset(asset: asset, image: image))
            }
        }
    }

    
    func getImageFromAsset(asset : PHAsset, size : CGSize, completion : @escaping (UIImage) -> ()) {
        let imageManage = PHCachingImageManager()
        imageManage.allowsCachingHighQualityImages = true
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
        imageManage.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageOptions) { image, _ in
            guard let resizeImage = image else { return }
            completion(resizeImage)
        }
    }
    
    func getVideoFromAsset(asset: PHAsset, completion: @escaping (URL?) -> ()) {
        let videoManager = PHCachingImageManager()
        let videoOptions = PHVideoRequestOptions()
        videoOptions.version = .original
        videoOptions.deliveryMode = .highQualityFormat
        
        videoManager.requestAVAsset(forVideo: asset, options: videoOptions) { (avAsset, _, _) in
            guard let avAsset = avAsset as? AVURLAsset else {
                completion(nil)
                return
            }
            
            completion(avAsset.url)
        }
        
        getImageFromAsset(asset: asset, size: CGSize(width: 150, height: 150), completion: { videoThumb in
            self.imagePreview = videoThumb
        })
    }
    
    func createNewTweet() async throws {
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else { return }
        
        let uuid = UUID().uuidString
        
        if imagePreview != nil {
            try await uploadTweetWithImage(uid: uuid, ownerUid : uidCurrentUser)
        } else if videoPreview != nil {
            try await uploadTweetWithVideo(uid: uuid, ownerUid: uidCurrentUser)
        } else {
            let tweet = Tweet(id: uuid, content: content, createDate: Date(), ownerUid: uidCurrentUser)
            try await TweetService.uploadTweet(tweet: tweet)
        }
        
        // set realtime database firebase
        setRealtimeForPost(idPost: uuid)
    }
    
    func uploadTweetWithImage(uid : String, ownerUid : String) async throws {
        guard let image = self.imagePreview else { return }
        
        guard let imageUrl = try await ImageUploader.uploadMedia(media: image, type: .imageTweet) else { return }
        
        let tweet = Tweet(id: uid, content: content, createDate: Date(), imageUrl: imageUrl, ownerUid: ownerUid)
        try await TweetService.uploadTweet(tweet: tweet)
    }
    
    func uploadTweetWithVideo(uid : String, ownerUid : String) async throws {
        guard let video = self.videoPreview else { return }
        
        guard let videoUrl = try await ImageUploader.uploadMedia(media: video, type: .videoTweet) else { return }
        
        let tweet = Tweet(id: uid, content: content, createDate: Date(), videoUrl: videoUrl, ownerUid: ownerUid)
        try await TweetService.uploadTweet(tweet: tweet)
    }
    
    func setRealtimeForPost(idPost : String) {
        let postRef = ref.child("posts").child(idPost)
        
        let objectPost = [
            "likes" : 0,
            "comments" : 0,
            "reupload" : 0
        ] as [String : Any]
        
        postRef.setValue(objectPost)
    }
}

enum LibraryStatus {
    case authorized, denied, limited
}

