//
//  LocalStorage.swift
//  Sonnen
//
//  Created by Peter Werner on 03.03.23.
//

import Foundation

struct LocalStorageAuthChunk: Decodable {
    var hasLoggedInOnce: String
    var retryCount: String
    var accessToken: String
    var refreshToken: String
    var tokenType: String
    var tokenForAction: String
    var getReverseChannelTokenQuery: String
    var getTokensQuery: String
}
