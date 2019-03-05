//
//  IntentHandler.swift
//  SiriIntent
//
//  Created by Konstantin on 3/4/19.
//  Copyright © 2019 sks. All rights reserved.
//

import Intents

class IntentHandler: INExtension, FindFactsAboutNumberIntentHandling {
    let numbersApiService = NumbersApiService()
    let groupDefaults = UserDefaults(suiteName: Constants.groupsUserDefaultsDomain)

    func confirm(intent: FindFactsAboutNumberIntent, completion: @escaping (FindFactsAboutNumberIntentResponse) -> Void) {
        if let number = groupDefaults?.string(forKey: Constants.lastSearchNumberDefaultsKey) {
            completion(FindFactsAboutNumberIntentResponse.confirmation(number: number))
        } else {
            completion(FindFactsAboutNumberIntentResponse(code: FindFactsAboutNumberIntentResponseCode.failure, userActivity: nil))
        }
    }

    func handle(intent: FindFactsAboutNumberIntent, completion: @escaping (FindFactsAboutNumberIntentResponse) -> Void) {
        if let number = groupDefaults?.string(forKey: Constants.lastSearchNumberDefaultsKey) {
            numbersApiService.findFactsAbout(number: number) { facts, error in
                if let error = error {
                    completion(FindFactsAboutNumberIntentResponse.failueWithError(error.localizedDescription))
                } else if let facts = facts {
                    completion(FindFactsAboutNumberIntentResponse.success(fact: facts))
                }
            }
        } else {
            completion(FindFactsAboutNumberIntentResponse(code: FindFactsAboutNumberIntentResponseCode.failure, userActivity: nil))
        }
    }
}
