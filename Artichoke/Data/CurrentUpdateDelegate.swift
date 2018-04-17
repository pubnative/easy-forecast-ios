//
//  CurrentUpdateDelegate.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 20.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit

protocol CurrentUpdateDelegate {
    mutating func requestCurrentDidSucceed(withData: CurrentResponse)
    mutating func requestCurrentDidFail(withError: Error)
}
