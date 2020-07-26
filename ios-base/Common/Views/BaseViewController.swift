//
//  BaseViewController.swift
//  ios-base
//
//  Created by Rakesh Kumar Sharma on 26/07/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit
import FluentDarkModeKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        //Set DarkMode Colors
        view.backgroundColor = HandleColors.viewBackgroundColor
        // --------
        
        // Localization Keys Handle---
        self.updateLabels()
        NotificationCenterHandle.shared.registerLocalisationBroadcast(observerOn: self)
        // -----------
    }
    
}
