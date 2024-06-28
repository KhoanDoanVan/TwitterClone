//
//  CacheManager.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 23/04/2024.
//

import SwiftUI

class CacheManager {
    
    static var shared = CacheManager()
    
    private init(){}
    
    var imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    var tweetLikedCache: NSCache<NSString, NSString> = NSCache<NSString, NSString>()
    var commentLikedCache: NSCache<NSString, NSString> = NSCache<NSString, NSString>()
    
    // image
    func addImage(imageUrl: String, values: UIImage){
        imageCache.setObject(values, forKey: imageUrl as NSString)
    }
    func removeImage(imageUrl: String) {
        imageCache.removeObject(forKey: imageUrl as NSString)
    }
    func getImage(imageUrl: String) -> UIImage? {
        imageCache.object(forKey: imageUrl as NSString)
    }
    
    // tweet liked
    func addTweetLiked(uidTweet : String, values : String){
        tweetLikedCache.setObject(values as NSString, forKey: uidTweet as NSString)
    }
    func getTweetLiked(uidTweet : String) -> Bool {
        return tweetLikedCache.object(forKey: uidTweet as NSString) != nil ? true : false
    }
    func removeTweetLiked(uidTweet : String) {
        tweetLikedCache.removeObject(forKey: uidTweet as NSString)
    }
    
    // comment liked
    func addCommentLiked(uidComment : String, values : String){
        tweetLikedCache.setObject(values as NSString, forKey: uidComment as NSString)
    }
    func getCommentLiked(uidComment : String) -> Bool {
        return tweetLikedCache.object(forKey: uidComment as NSString) != nil ? true : false
    }
    func removeCommentLiked(uidComment : String) {
        tweetLikedCache.removeObject(forKey: uidComment as NSString)
    }
    
    // clear
    func clearAllData() {
        imageCache.removeAllObjects()
        tweetLikedCache.removeAllObjects()
        commentLikedCache.removeAllObjects()
    }
}
