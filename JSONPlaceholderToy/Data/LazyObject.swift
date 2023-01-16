//
//  LazyObject.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-12.
//

import Foundation

@objc enum FetchStatus: Int, Codable {
    case loaded, loading, failed, idle
}

class LazyObject<O: Codable>: NSObject, Codable {
    
    // Codable vars
    var itemId: Int? = nil
    var value: O? = nil
    var urlString: String
    @objc dynamic var status: FetchStatus = .idle
    
    // Non codable vars
    var id = UUID()
    
    enum CodingKeys: CodingKey {
        case itemId
        case value
        case urlString
        case status
    }
    
    init(urlString: String, itemId: Int? = nil) {
        self.urlString = urlString
        self.itemId = itemId
    }
    
    func fetch(forceFetch: Bool = false) async {
        
        guard status != .loading || forceFetch == true else { return }
        
        let url = URL(string: urlString)!
        status = .loading
        
        // TODO: do proper error handling here
        let (data, response) = try! await URLSession.shared.data(from: url)
        guard (response as! HTTPURLResponse).statusCode == 200 else {
            status = .failed
            return
        }
        // TODO: do proper error handling here
        let decodedModel = try! JSONDecoder().decode(O.self, from: data)
        
        value = decodedModel
        status = .loaded
    }
}
