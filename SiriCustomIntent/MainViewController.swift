//
//  ViewController.swift
//  SiriCustomIntent
//
//  Created by Konstantin on 3/4/19.
//  Copyright © 2019 sks. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var findButton: UIButton!

    // MARK: - Private Properties
    private let numbersApiService = NumbersApiService()

    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSettings()
        fetchSettings()
    }

    // MARK: - Actions
    @IBAction func findFactsAction(_ sender: Any) {
        if let number = textField.text {
            textField.resignFirstResponder()
            getFactsAbout(number: number)
        }
    }

    // MARK: - Private methods
    private func setupView() {
        findButton.layer.cornerRadius = findButton.frame.height / 2
        findButton.clipsToBounds = true
    }

    private func setupSettings() {
        textField.delegate = self
    }

    private func fetchSettings() {
        if let lastNumber = UserDefaults.standard.string(forKey: Constants.lastSearchNumberDefaultsKey) {
            textField.text = lastNumber
            getFactsAbout(number: lastNumber)
        }
    }
    
    private func getFactsAbout(number: String) {
        numbersApiService.findFactsAbout(number: number) { facts, error in
            if let error = error {
                self.resultLabel.text = error.localizedDescription
            } else if let facts = facts {
                self.resultLabel.text = facts
                UserDefaults(suiteName: Constants.groupsUserDefaultsDomain)!.set(number, forKey: Constants.lastSearchNumberDefaultsKey)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let number = textField.text {
            getFactsAbout(number: number)
        }

        return true
    }
}
