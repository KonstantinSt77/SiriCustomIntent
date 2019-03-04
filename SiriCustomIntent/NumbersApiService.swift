//
//  NumbersApiService.swift
//  SiriCustomIntent
//
//  Created by Konstantin on 3/4/19.
//  Copyright © 2019 sks. All rights reserved.
//

import Foundation

class NumbersApiService {
    // MARK: - Private Properties
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    // MARK: - Public methods
    public func findFactsAbout(number: String, completion: @escaping ((_ responce: String?,_ error: Error?) -> Void)) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "http://numbersapi.com/\(number)") {
            guard let url = urlComponents.url else {
                return
            }

            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer {
                    self.dataTask = nil
                }

                if let error = error {
                    completion(nil, error)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let factsString = String(data: data, encoding: String.Encoding.utf8)
                    DispatchQueue.main.async {
                        completion(factsString, nil)
                    }
                }
            }
            dataTask?.resume()
        }
    }
}
