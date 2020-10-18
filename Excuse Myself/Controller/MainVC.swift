//
//  MainVC.swift
//  Excuse Myself
//
//  Created by Mattias Törnqvist on 2020-09-21.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
//    MARK: - Properties
    private let mainView = MainView()
    private var messageDirectory = Messages()
    private var selectedSeriousity = Seriosity.serious

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
    }
    
//    MARK: - Helper functions
    
    private func configureView() {
        view = mainView
        mainView.delegate = self
        mainView.seriousityDelegate = self
        mainView.copyToClipBoardDelegate = self
    }
    

}

extension MainVC: RandomizeButtonDelegate {
    func handleButtonPressed(_ button: UIButton) {
        
        let message = messageDirectory.generateMessage(with: selectedSeriousity)
        mainView.presentMessage(message)
    }
}

extension MainVC: SeriousityPickerDelegate {
    func handleSeriousityPicked(_ sender: UISegmentedControl, seriousity: Seriosity) {
        
        selectedSeriousity = seriousity
        
        let restartMessage = messageDirectory.generateStartMessage()
        mainView.presentMessage(restartMessage)
    }
}

extension MainVC: CopyToClipBoardDelegate {
    func handleCopyToClipBoard(_ sender: UIButton, string: String) {
        UIPasteboard.general.string = string
    }
}
