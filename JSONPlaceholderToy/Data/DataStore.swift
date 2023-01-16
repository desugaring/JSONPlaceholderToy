//
//  DataStore.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-11.
//

import Foundation

class DataStore: Codable {
    
    static var shared = DataStore()
    
    private(set) var posts: LazyObject<[Post]>
    private var comments: [Int: LazyObject<[Comment]>] = [:]
    private(set) var authors: LazyObject<[User]>
    
    // [post.id: comments]
    private(set) var favoritePostIds: [Int] = []
    
    // posts shown in TableVC
    var sortedPosts: [Post] {
        (posts.value ?? []).sorted { post1, post2 in
            let contains1 = favoritePostIds.contains(post1.id)
            let contains2 = favoritePostIds.contains(post2.id)
            if contains1 == contains2 {
                return post1.title > post2.title
            }
            else {
                return contains1 == true
            }
        }
    }
    
    init() {
        // check for existing data store
        if let data = UserDefaults.standard.value(forKey: "data_store") as? Data {
            
            let decoder = JSONDecoder()
            let dataStore = try! decoder.decode(DataStore.self, from: data)
            self.posts = dataStore.posts
            self.comments = dataStore.comments
            self.favoritePostIds = dataStore.favoritePostIds
            self.authors = dataStore.authors
        }
        else {
            self.posts = LazyObject<[Post]>(urlString: "https://jsonplaceholder.typicode.com/posts")
            self.authors = LazyObject<[User]>(urlString: "https://jsonplaceholder.typicode.com/users")
            
            Task {
                await self.posts.fetch()
                await self.authors.fetch()
            }
        }
    }
    
    // comments shown in DetailVC
    func commentsForPost(postId: Int) -> LazyObject<[Comment]> {
        if let existingComments = comments[postId] {
            return existingComments
        }
        else {
            let newComments = LazyObject<[Comment]>(urlString: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments", itemId: postId)
            comments[postId] = newComments
            
            return newComments
        }
    }
    
    // author shown in DetailVC
    func authorForPost(postId: Int) -> User? {
        let post = posts.value!.first(where: { $0.id == postId })!
        
        if let existingAuthor = authors.value?.first(where: { $0.id == post.userId }) {
            return existingAuthor
        }
        else {
            return nil
        }
    }
    
    func favorPost(postId: Int) {
        favoritePostIds.append(postId)
    }
    
    func unfavorPost(postId: Int) {
        favoritePostIds.removeAll(where: { $0 == postId })
    }
    
    func removeUnfavoredPosts() {
        posts.value?.removeAll(where: { favoritePostIds.contains($0.id) == false })
    }
    
    func saveToUserDefaults() {
        let jsonEncoder = JSONEncoder()
        let data = try! jsonEncoder.encode(self)
        UserDefaults.standard.set(data, forKey: "data_store")
    }
}
