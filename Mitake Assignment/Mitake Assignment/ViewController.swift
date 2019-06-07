//
//  ViewController.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var xPosition:CGFloat = 0
    lazy var yPosition:CGFloat = self.view.frame.maxY
    
    let dataManager = DataManager()
    var trend: Trend?
    var centerPoint: Double?
    var centerPointY: CGFloat?
    var topPoint: Double?
    var bottomPoint: Double?
    
    let linePath = UIBezierPath()
    let lineShapeLayer = CAShapeLayer()
    
    var chartScrollView:UIScrollView!
    var chartView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrendData()
        
        // Create chart scroll view & chart view
        chartView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3))
        chartView.backgroundColor = UIColor.clear
        
        chartScrollView = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.height/4, width: self.view.frame.width, height: self.view.frame.height/3))
        chartScrollView.backgroundColor = UIColor.black
        chartScrollView.contentSize = chartView.frame.size
        chartScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        chartScrollView.addSubview(chartView)
        view.addSubview(chartScrollView)
        
        centerPointY = self.chartView.frame.height - (self.chartView.frame.height*(23.1-20.8)/(25.4-20.8))
        
    }
    
    fileprivate func getTrendData() {
        dataManager.readJson { (trend) in
            self.trend = trend
            self.centerPoint = Double(trend.root.c)
            self.topPoint = Double(trend.root.tp)
            self.bottomPoint = Double(trend.root.bp)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //markPoint()
        
        //init point
        xPosition = 40
        yPosition = self.chartView.frame.height/2-15
        linePath.move(to: CGPoint(x: xPosition, y: yPosition))
        
        
        for i in self.trend!.root.tick {
            xPosition = CGFloat(Double(i.t)!)+40
            print(self.chartView.frame.height)
            yPosition = self.chartView.frame.height-(self.chartView.frame.height * CGFloat((Double(i.c)!-20.8)/(25.4-20.8)))
            
            print(xPosition, i.c)
            updateChart()
        }
        
        let viewHeight = Int(chartView.frame.height)
        
        drawYScaleLabel(x: 0, y: Double(self.chartView.frame.height/2) - 20, value: self.centerPoint!)
        drawYScaleLabel(x: 0, y: 0, value: self.topPoint!)
        drawYScaleLabel(x: 0, y: Double(self.chartView.frame.height) - 40, value: self.bottomPoint!)
        
        
        linePath.addLine(to: CGPoint(x: 311, y: self.chartView.frame.height/2-15))
        lineShapeLayer.path = linePath.cgPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - LineChart functions
    
    func updateChart() {
        updateChartViewFrame()
        linePath.addLine(to: CGPoint(x: xPosition, y: yPosition))
        lineShapeLayer.path = linePath.cgPath
        lineShapeLayer.fillColor = UIColor.clear.cgColor
        if yPosition > centerPointY!{
            lineShapeLayer.strokeColor = UIColor.red.cgColor
        }else{
            lineShapeLayer.strokeColor = UIColor.green.cgColor
        }
        lineShapeLayer.lineWidth = 1
        print(linePath)
        chartView.layer.addSublayer(lineShapeLayer)
    }
    
    func markPoint() {
        let circlePoint = UIView()
        circlePoint.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        circlePoint.layer.cornerRadius = circlePoint.frame.height / 2
        circlePoint.clipsToBounds = true
        circlePoint.center = CGPoint(x: xPosition, y: yPosition)
        circlePoint.backgroundColor = UIColor.green
        
        let coordinateLabel = UILabel()
        coordinateLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        coordinateLabel.text = "(\(Int(xPosition)),\(Int(chartView.frame.height - yPosition)))"
        coordinateLabel.center = CGPoint(x: xPosition, y: yPosition - 20)
        coordinateLabel.textColor = UIColor.green
        
        let xScaleLabel = UILabel()
        xScaleLabel.frame = CGRect(x: 0, y: 0 , width: 100, height: 20)
        xScaleLabel.center = CGPoint(x: xPosition + 50 , y: view.frame.maxY - 20)
        xScaleLabel.text = "\(Int(xPosition))"
        xScaleLabel.textColor = UIColor.green
        
        chartView.addSubview(xScaleLabel)
        chartView.addSubview(coordinateLabel)
        chartView.addSubview(circlePoint)
    }
    
    func updateChartViewFrame() {
        if xPosition >= chartView.frame.maxX {
            chartView.frame = CGRect(x: 0, y: 0, width: xPosition + 50, height: chartView.frame.height)
            chartScrollView.contentSize = chartView.frame.size
        }
    }
    
    func drawYScaleLabel(x: Double, y:Double, value: Double){
        let yScaleLabel = UILabel()
        yScaleLabel.frame = CGRect(x: x, y: y, width: 40, height: 30)
        yScaleLabel.text = "\(value)"
        yScaleLabel.textColor = UIColor.green
        yScaleLabel.backgroundColor = UIColor.red
        self.chartView.addSubview(yScaleLabel)
    }
    
    

    
}


