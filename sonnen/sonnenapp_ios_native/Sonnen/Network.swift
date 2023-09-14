//
//  Network.swift
//  Sonnen
//
//  Created by Peter Werner on 03.03.23.
//

import Foundation
import SwiftUI

struct URLS {
    static let LIVEDATA = "https://my-api.sonnen.de/v1/sites/c5a777a7-8296-4ae2-808a-db0173d20c93/live-state"
    static let LOGIN = "https://account.sonnen.de/users/sign_in"
}

class Network: ObservableObject {
    @Published var TOKEN = "*"
    @Published var liveData: SonnenLiveData?
    
    func getLiveData() {
        guard let url = URL(string: URLS.LIVEDATA) else { fatalError("Missing URL") }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(TOKEN)", forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let responseJSON = try JSONDecoder().decode(SonnenLiveData.self, from: data)
                        //print(responseJSON)
                        self.liveData = responseJSON
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            } else if response.statusCode == 401 {
                // show login view
//                DispatchQueue.main.async {
//                    self.responseStatusCode = response.statusCode
//                }
            }
        }

        dataTask.resume()
    }
}
