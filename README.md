# Siri Shortcuts Custom Intent

For demonstration siri custom intents i choosed open api Numbers that provide facts about searched number.
Main App have a textField where user can write a numbers and label where facts shows.
Siri Extension work with phrase "Find facts about number" after that siri asked you to confirm you request and after that show and tell the found facts about last searched number from main app.

Firs of all you need to create 2 files:
```
SiriCustomIntent.entitlements
```
and
```
NumberFactsIntent.intentdefinition
```

And dont forget about 
```
Privacy - Siri Usage Description
```

I used a Intents Framework for Siri Intent:
```
import Intents
```
Also we need a group defaults if you want to pass data from main app to extension

```
let groupDefaults = UserDefaults(suiteName: Constants.groupsUserDefaultsDomain)
```
In this example I request Siri Authorization
```
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
```
After request authorization we need to donate intent
```
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
```
Also i save bool value for the initial setup for siri and save first number to search
```
func saveSiriSettings() {
    groupDefaults?.set(true, forKey: Constants.siriSetupSuccessDefaultsKey)
}

func setDefaultNumber() {
    groupDefaults?.set("18", forKey: Constants.lastSearchNumberDefaultsKey)
}
```

I create API Service for getting facts about number from open api
```
class NumbersApiService
```

I used URLSession because its simple way to perform basic requests and also one more plus to not use third-party libraries for siri extension
```
class NumbersApiService {
    // MARK: - Private Properties
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    // MARK: - Public methods
    public func findFactsAbout(number: String, completion: @escaping ((_ responce: String?,_ error: Error?) -> Void)) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "\(Constants.apiBasePathString)\(number)") {
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
```
The most interesting is now in the extension for Siri, it has 2 methods

```
func confirm(intent: FindFactsAboutNumberIntent, completion: @escaping (FindFactsAboutNumberIntentResponse) -> Void)
```
and

```
func handle(intent: FindFactsAboutNumberIntent, completion: @escaping (FindFactsAboutNumberIntentResponse) -> Void) 
```

After creating your own intent, Xcode generates the class itself with your intent as well as the accompanying methods for working with it
After creating your custom completions you need to write logic in this methods

```
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
```
