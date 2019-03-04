//
//  NumbersApiService.swift
//  SiriCustomIntent
//
//  Created by Konstantin on 3/4/19.
//  Copyright © 2019 sks. All rights reserved.
//

import Foundation

class NumbersApiService {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    func findFactsAbout(number: String, completion: @escaping ((_ responce: String?,_ error: Error?) -> Void)) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "http://numbersapi.com") {
            urlComponents.query = "\(number)"
            guard let url = urlComponents.url else {
                return
            }

            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer {
                    self.dataTask = nil
                }

                if let error = error {
                    completion("2341243", error)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion("2341243", nil)
                    }
                }
            }
            dataTask?.resume()
        }
    }
}
