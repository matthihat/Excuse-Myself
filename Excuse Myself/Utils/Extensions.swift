//
//  Extensions.swift
//  Excuse Myself
//
//  Created by Mattias Törnqvist on 2020-09-21.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    static let textColor = rgb(red: 217, green: 250, blue: 255)
    static let bgColorDark = rgb(red: 0, green: 32, blue: 74)
    static let bgColorLight = rgb(red: 0, green: 87, blue: 146)
    static let highLightColor = rgb(red: 0, green: 187, blue: 240)
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    func anchor(top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingRight: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func setHeight(to height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setWidth(to width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    func centerX(inView: UIView) {
        centerXAnchor.constraint(equalTo: inView.centerXAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    func centerY(inView: UIView) {
        centerYAnchor.constraint(equalTo: inView.centerYAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    static func blurEffect() -> UIView {
        let visualEffect: UIVisualEffectView = {
            let visualEffect = UIBlurEffect(style: .systemMaterialLight)
            let view = UIVisualEffectView(effect: visualEffect)
            
            return view
        }()
        
        return visualEffect
    }
}
