//
//  CustomRangeSeekSlider.swift
//  TestTokped
//
//  Created by Adie on 02/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import UIKit
import RangeSeekSlider
@IBDesignable final class CustomRangeSeekSlider: RangeSeekSlider {
    
    override func setupStyle() {
        
        minValue = 100.0
        maxValue = 10000000
        selectedMinValue = 100.0
        selectedMaxValue = 10000000
        step = 100000
        enableStep = true
        handleDiameter = 20
        handleBorderColor = green
        handleColor = green
        minLabelColor = UIColor.darkGray
        maxLabelColor = UIColor.darkGray
        colorBetweenHandles = green
        tintColor = gray
        
        numberFormatter.locale = Locale(identifier: "id_ID")
        numberFormatter.numberStyle = .currency
        labelsFixed = true
        
        
        
    }
    
    func resetVal(){
        selectedMinValue = 100.0
        selectedMaxValue = 10000000
        // if you got some issue refresh is inaccessible due to 'fileprivate' protection level refresh() func change access modifiers refresh() func to open from pod file RangeSeekSlider.swift
        refresh()
    }
    
}
