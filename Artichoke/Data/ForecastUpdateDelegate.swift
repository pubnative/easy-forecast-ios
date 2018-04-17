//
//  ForecastUpdateDelegate.swift
//  Artichoke
//
//  Created by Eros Garcia Ponte on 20.02.18.
//  Copyright © 2018 ErosTech Solutions. All rights reserved.
//

import UIKit

protocol ForecastUpdateDelegate {
    mutating func requestForecastDidSucceed(withData: ForecastResponse)
    mutating func requestForecastDidFail(withError: Error)
}
