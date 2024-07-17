//
//  TweetService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

class TweetService {
    static func uploadTweet(tweet : Tweet) async throws {
        guard let tweetData = try? Firestore.Encoder().encode(tweet) else { return }
        try await Firestore.firestore().collection("tweets").addDocument(data: tweetData)
    }
        
    static var lastDocumentSnapshot: DocumentSnapshot?
    
    static func fetchTweets(limit: Int) async throws -> [Tweet] {
        var query = Firestore.firestore().collection("tweets")
            .limit(to: limit)

        if let lastDocumentSnapshot = lastDocumentSnapshot {
            query = query.start(afterDocument: lastDocumentSnapshot)
        }

        let snapshot = try await query.getDocuments()
        lastDocumentSnapshot = snapshot.documents.last

        return snapshot.documents.compactMap { document in
            try? document.data(as: Tweet.self)
        }
    }
    
    static func getAmountDocumentsOfCollection(arrayUid : [String]) async throws -> Int {
        if arrayUid.isEmpty {
            return 0
        } else {
            let query = Firestore.firestore().collection("tweets").whereField("ownerUid", in: arrayUid).count
            
            do {
                let snapshot = try await query.getAggregation(source: .server)
                return snapshot.count.intValue
            } catch {
                print(error.localizedDescription)
                return 0
            }
        }
    }
    
    static func getAmountDocumentsOfCollectionByUid(uid : String) async throws -> Int {
        let query = Firestore.firestore().collection("tweets").whereField("ownerUid", in: [uid]).count
        
        do {
            let snapshot = try await query.getAggregation(source: .server)
            return snapshot.count.intValue
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    static func fetchTweetsByUserOwnedUid(uid : String, limit : Int) async throws -> [Tweet] {
        
        var query = Firestore.firestore().collection("tweets")
            .whereField("ownerUid", in: [uid])
            .limit(to: limit)
            
        if let lastDocumentSnapshot = lastDocumentSnapshot {
            query = query.start(afterDocument: lastDocumentSnapshot)
        }
        
        let snapshot = try await query.getDocuments()
        lastDocumentSnapshot = snapshot.documents.last
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Tweet.self)
        }
    }
    
    static func fetchTweetsByUserUids(arrayUid : [String], limit : Int) async throws -> [Tweet] {
        
        if arrayUid.isEmpty {
            return []
        } else {
            var query = Firestore.firestore().collection("tweets")
                .whereField("ownerUid", in: arrayUid)
                .limit(to: limit)
            
            if let lastDocumentSnapshot = lastDocumentSnapshot {
                query = query.start(afterDocument: lastDocumentSnapshot)
            }
            
            let snapshot = try await query.getDocuments()

            lastDocumentSnapshot = snapshot.documents.last
            
            return snapshot.documents.compactMap { doc in
                try? doc.data(as: Tweet.self)
            }
        }
    }
    
    static func fetchTweetsById(tweetId: String) async throws -> Tweet? {
        print(tweetId)
        let snapshot = try await Firestore.firestore().collection("tweets").whereField("id", in: [tweetId]).getDocuments()
        print(snapshot.documents)
        let tweetData = try snapshot.documents.first?.data(as: Tweet.self)
        return tweetData
    }
}
