//
//  NotificationCenterHandle.swift
//  Lystn
//
//  Created by Rakesh Kumar Sharma on 18/05/20.
//  Copyright © 2020 Rakesh Kumar Sharma. All rights reserved.
//

import Foundation

protocol ManageLocalization {
    func updateLabels()
}

class NotificationCenterHandle: NSObject {
    static let shared = NotificationCenterHandle()
    private override init() {}
    
    func registerLocalisationBroadcast(observerOn: NSObject) {
        Broadcaster.register(ManageLocalization.self, observer: observerOn)
    }
    
    func postLocalization() {
        Broadcaster.notify(ManageLocalization.self) {
            $0.updateLabels()
        }
    }

}

extension NSObject: ManageLocalization {
    @objc func updateLabels() {}
}
