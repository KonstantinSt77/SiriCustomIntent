//
//  AppDelegate.swift
//  SiriCustomIntent
//
//  Created by Konstantin on 3/4/19.
//  Copyright © 2019 sks. All rights reserved.
//

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let groupDefaults = UserDefaults(suiteName: Constants.groupsUserDefaultsDomain)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setDefaultNumber()
        initSiriShortcuts()

        return true
    }

    func initSiriShortcuts() {
        if let isSiriSetupSuccessfully = groupDefaults?.bool(forKey: Constants.siriSetupSuccessDefaultsKey), !isSiriSetupSuccessfully {
            setupSiri()
        }
    }

    func setupSiri() {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .authorized:
                self.donateIntent()
                break
            case .notDetermined:
                debugPrint("INPreferences requestSiriAuthorization status: notDetermined")
                break
            case .restricted:
                debugPrint("INPreferences requestSiriAuthorization status: restricted")
                break
            case .denied:
                debugPrint("INPreferences requestSiriAuthorization status: denied")
                break
            }
        }
    }

    func donateIntent() {
        if #available(iOS 12.0, *) {
            let intent = FindFactsAboutNumberIntent()
            intent.suggestedInvocationPhrase = "Find facts about number"
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate { error in
                if let receivedError = error {
                    debugPrint("FindFactsAboutNumberIntent Donate Error \(receivedError)")
                } else {
                    debugPrint("FindFactsAboutNumberIntent Donate Success")
                    self.openSiriSettingsForRecordShoertcut()
                    self.saveSiriSettings()
                }
            }
        }
    }

    func saveSiriSettings() {
        groupDefaults?.set(true, forKey: Constants.siriSetupSuccessDefaultsKey)
    }

    func setDefaultNumber() {
        groupDefaults?.set("18", forKey: Constants.lastSearchNumberDefaultsKey)
    }

    func openSiriSettingsForRecordShoertcut() {
        DispatchQueue.main.async {
            let alertController = UIAlertController (title: "Siri needs record new shortcut command", message: "Open Settings -> Siri & Search, for record new Siri Shortcut", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: "App-Prefs:root=Siri") else {
                    return
                }

                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
            
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
