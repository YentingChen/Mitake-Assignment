//
//  Double+.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/13.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    static func convertToChartViewYCoordinate(view: UIView, yValue: Double, tp: Double, bp: Double) -> Double {
        let viewHeight = Double(view.frame.height)
        let result = viewHeight - (yValue-bp)*viewHeight/(tp-bp)
        return result
    }
    
}
