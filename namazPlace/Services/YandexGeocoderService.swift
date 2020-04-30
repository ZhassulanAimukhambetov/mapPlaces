//
//  YandexGeocoderService.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit
import YandexMapKitSearch

class YandexGeocoderService {
    static let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    static var session: YMKSearchSession?
    
    class func search(point: YMKPoint, completion: @escaping (_ response: String?) -> ()) {
        session = searchManager.submit(with: point, zoom: nil, searchOptions: YMKSearchOptions()) { (searchResponse, error) in
            if let response = searchResponse {
                let title = response.collection.children.first?.obj?.name
                completion(title)
            } else if let error = error {
                let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
                var errorMessage = "Unknown error"
                if searchError.isKind(of: YRTNetworkError.self) {
                    errorMessage = "Network error"
                } else if searchError.isKind(of: YRTRemoteError.self) {
                    errorMessage = "Remote server error"
                }
                completion(errorMessage)
            }
        }
    }
}
