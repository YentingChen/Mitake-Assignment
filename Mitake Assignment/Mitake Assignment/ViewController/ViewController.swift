//
//  ViewController.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dataManager = DataManager()
    
    @IBOutlet weak var lineChart: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.readJson { (trend) in
            var maxTick: TickDoubleType?
            var minTick: TickDoubleType?
            
            dataManager.makeLineArray(view: lineChart, trend: trend, handler: { (array) in
                
            }, hadler2: { (cgArray) in
                lineChart.dataPoints = cgArray
            })
            
            dataManager.findMaxAndMin(view: lineChart, trend: trend, hadler: { (max, min) in
                maxTick = max
                minTick = min
            }, handler2: { (max, min) in
                lineChart.maxPoint = max
                lineChart.minPoint = min
                lineChart.maxValue = maxTick!.h
                lineChart.minValue = minTick!.l
            })
            
        }
       
    }
    
    
    
}


