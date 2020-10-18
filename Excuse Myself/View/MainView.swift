//
//  MainView.swift
//  Excuse Myself
//
//  Created by Mattias Törnqvist on 2020-09-21.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

protocol RandomizeButtonDelegate {
    func handleButtonPressed(_ button: UIButton)
}

protocol SeriousityPickerDelegate {
    func handleSeriousityPicked(_ sender: UISegmentedControl, seriousity: Seriosity)
}

protocol CopyToClipBoardDelegate {
    func handleCopyToClipBoard(_ sender: UIButton, string: String)
}

class MainView: UIView {
    
//MARK: - Properties
    
    var message: Message? {
        didSet {
            messageLabel.text = message?.text
        }
    }
    
    private var seriousityPicker: UISegmentedControl = {
        let items: [String] = {
            var array = [String]()
            for seriousity in Seriosity.allCases {
                if seriousity != .none {
                    array.append(seriousity.rawValue)
                }
            }
            return array
        }()
        
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightText
        control.addTarget(self, action: #selector(handleSelectSeriousity(_:)), for: .valueChanged)
        return control
    }()
    
    private var textView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var messageLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.text = "Press generate for excuse"
        return label
    }()
    
    private lazy var copyToClipBoardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.layer.cornerRadius = 5
        button.backgroundColor = .darkGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleCopyToClipBoardPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var randomizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(handleRandomizeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let popUpView: UIView = {
        let popUpView = UIView()
        popUpView.alpha = 0
        popUpView.backgroundColor = .clear
        
        let blurView = UIView.blurEffect()
        popUpView.addSubview(blurView)
        blurView.pinEdgesToSuperView()
        
        let vLabel = UILabel()
        vLabel.text = "✓"
        vLabel.font = UIFont.systemFont(ofSize: 120)
        vLabel.textColor = .darkText
        
        popUpView.addSubview(vLabel)
        vLabel.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        vLabel.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor).isActive = true
        vLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = "Copied to clipboard"
        textLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        textLabel.textColor = .darkText
        popUpView.addSubview(textLabel)
        textLabel.anchor(bottom: popUpView.bottomAnchor, paddingBottom: 22)
        textLabel.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        
        return popUpView
    }()
    
    var delegate: RandomizeButtonDelegate?
    var seriousityDelegate: SeriousityPickerDelegate?
    var copyToClipBoardDelegate: CopyToClipBoardDelegate?
    
    private var enableCopyToClipBoard = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
//    MARK: - Helper functions
    
    private func configureUI() {
        
        backgroundColor = .systemGray
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: leftAnchor,
                        right: rightAnchor, paddingTop: 160,
                        paddingLeft: 40, paddingRight: 40,
                        height: 260)
        
        textView.addSubview(messageLabel)
        messageLabel.anchor(top: textView.topAnchor, left: textView.leftAnchor,
            bottom: textView.bottomAnchor, right: textView.rightAnchor)
        messageLabel.preferredMaxLayoutWidth = textView.frame.width
        messageLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
        
        addSubview(copyToClipBoardButton)
        copyToClipBoardButton.anchor(top: textView.bottomAnchor, left: leftAnchor,
                                    right: rightAnchor, paddingTop: 4,
                                    paddingLeft: 140, paddingRight: 140)
        copyToClipBoardButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        addSubview(seriousityPicker)
        seriousityPicker.anchor(top: textView.bottomAnchor, left: leftAnchor,
                                right: rightAnchor, paddingTop: 160,
                                paddingLeft: 40, paddingRight: 40)
        seriousityPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(randomizeButton)
        randomizeButton.anchor(left: leftAnchor, bottom: bottomAnchor,
                               right: rightAnchor, paddingLeft: 40,
                               paddingBottom: 120, paddingRight: 40,
                               height: 44)
        randomizeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    public func presentMessage(_ message: Message) {
        self.message = message
        
        checkIfCopyIsEnabled(message: message)
    }
    
    private func checkIfCopyIsEnabled(message: Message) {
        
        switch message.isSystemMessage {
        case true:
            copyToClipBoardButton.isEnabled = false
            copyToClipBoardButton.backgroundColor = .darkGray
        case false:
            copyToClipBoardButton.isEnabled = true
            copyToClipBoardButton.backgroundColor = .systemBlue

        }
    }
    
    private func showCopiedToClipboardPopUp() {
        
        addSubview(popUpView)
        popUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -80).isActive = true
        popUpView.setWidth(to: self.frame.width - 120)
        popUpView.setHeight(to: self.frame.width - 120)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.popUpView.alpha = 0.85
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
                self.popUpView.alpha = 0
                
            }) { (_) in
                self.popUpView.removeFromSuperview()
            }
        }
    }
    
    @objc private func handleCopyToClipBoardPressed(_ sender: UIButton) {
        
        guard let text = messageLabel.text else {
            return
        }
        
        copyToClipBoardDelegate?.handleCopyToClipBoard(sender, string: text)
        
        showCopiedToClipboardPopUp()
    }
    
    @objc private func handleRandomizeButtonPressed() {
        delegate?.handleButtonPressed(randomizeButton)
    }
    
    @objc private func handleSelectSeriousity(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            seriousityDelegate?.handleSeriousityPicked(sender, seriousity: .serious)
        case 1:
            seriousityDelegate?.handleSeriousityPicked(sender, seriousity: .funny)
        default:
            print("None selected")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
