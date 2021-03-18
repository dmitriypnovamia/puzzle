//
//  NetworkManager.swift
//  BoXoB
//
//  Created by Dmitriy on 16.03.2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    var webViewOpenDelegate: WebViewOpenDelegate?
    
    func curlPostRequest() {
        guard let url = URL(string: "https://yyy-net.com/ajax.php?__sid=1eb58f54-7e82-67b8-b433-ac1f6b95a853"),
            let payload = "{\"testID\": \"testValue\"}".data(using: .utf8) else
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("yor_api_key", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }

            if let result = String(data: data, encoding: .utf8) {
                print("\ncurl RESULT")
                print(result)
                print("curl RESULT\n")
                if result != "0" {
                    self.webViewOpenDelegate?.openWebView(url: result)
                }
            }
        }.resume()
    }
}
