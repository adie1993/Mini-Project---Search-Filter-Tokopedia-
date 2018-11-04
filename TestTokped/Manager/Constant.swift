//
//  Constant.swift
//  TestTokped
//
//  Created by Adie on 01/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> ()
typealias JSON = [String: AnyObject]

let green: UIColor = #colorLiteral(red: 0.2778957486, green: 0.7004953027, blue: 0.3121809065, alpha: 1)
let gray: UIColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)

let baseUrl = "https://ace.tokopedia.com/search/v2.5/"
