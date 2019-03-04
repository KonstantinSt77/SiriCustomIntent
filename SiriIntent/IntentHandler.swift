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


    func confirm(intent: FindFactsAboutNumberIntent, completion: @escaping (FindFactsAboutNumberIntentResponse) -> Void) {

    }

    func handle(intent: FindFactsAboutNumberIntent, completion: @escaping (FindFactsAboutNumberIntentResponse) -> Void) {

    }


//    func confirm(intent: UnlockScooterIntent, completion: @escaping (UnlockScooterIntentResponse) -> Void) {
//        siriService.findScooter { qrCode, error in
//            if let receivedQRCode = qrCode {
//                completion(UnlockScooterIntentResponse.success(qrCode: receivedQRCode))
//            } else if let receivedError = error {
//                completion(UnlockScooterIntentResponse.failure(error: receivedError.localizedDescription))
//            } else {
//                completion(UnlockScooterIntentResponse(code: .failure, userActivity: nil))
//            }
//        }
//    }
//
//    func handle(intent: UnlockScooterIntent, completion: @escaping (UnlockScooterIntentResponse) -> Void) {
//        siriService.rentScooter { success, error in
//            if let _ = success {
//                completion(UnlockScooterIntentResponse(code: .successUnlock, userActivity: nil))
//            } else if let receivedError = error {
//                completion(UnlockScooterIntentResponse.failure(error: receivedError.localizedDescription))
//            } else {
//                completion(UnlockScooterIntentResponse(code: .failure, userActivity: nil))
//            }
//        }
//    }
}
