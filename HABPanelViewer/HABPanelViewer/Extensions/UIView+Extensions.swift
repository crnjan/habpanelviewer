//
//  UIView+Extensions.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import UIKit

extension UIView {
    
    func fillUsingAutoLayout(insets: UIEdgeInsets = .zero) {
        autoLayout {[
            topAnchor.constraint(equalTo: $0.topAnchor, constant: insets.top),
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom),
            leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: insets.left),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right)
        ]}
    }

    func centerUsingAutoLayout() {
        autoLayout {[
            $0.centerYAnchor.constraint(equalTo: centerYAnchor),
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]}
    }
    
    private func autoLayout(layoutProvider: (UIView) -> [NSLayoutConstraint]) {
        guard let superview = self.superview else {
            fatalError("add to superview first")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(layoutProvider(superview))
    }
    
}
