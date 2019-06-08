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
    var currentColor = UIColor.red
    
    let dataManager = DataManager()
    var trend: Trend?
    var centerPoint: Double?
    var centerPointY: CGFloat?
    var topPoint: Double?
    var bottomPoint: Double?
    
    //let linePath = UIBezierPath()
    //let lineShapeLayer = CAShapeLayer()
    
    var chartScrollView = UIScrollView()
    var chartView = UIView()
    
    var bigArray = [[Tick]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrendData()
        
        makeArray()
        
        chartScrollViewSetUp()
        chartViewSetUp()
        
        chartScrollView.addSubview(chartView)
        view.addSubview(chartScrollView)
        
        centerPointY = self.chartView.frame.height - (self.chartView.frame.height*(23.1-20.8)/(25.4-20.8))
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //init point
        xPosition = 40
        //yPosition = self.chartView.frame.height/2-15
        yPosition = self.chartView.frame.height-(self.chartView.frame.height * CGFloat((Double(bigArray[0][0].c)!-20.8)/(25.4-20.8)))
        
        for ary in bigArray{
            
            let origin = CGPoint(x: xPosition, y: yPosition)
            var linePath = UIBezierPath()
            let lineShapeLayer = CAShapeLayer()
            
            linePath.move(to: origin)
            
            
            for i in ary{
                
                if Double(i.c)! > Double(self.trend!.root.c)! {
                    currentColor = UIColor.red
                }
                else if Double(i.c)! < Double(self.trend!.root.c)! {
                    currentColor = UIColor.green
                }
                
                xPosition = CGFloat(Double(i.t)!)+40
                yPosition = self.chartView.frame.height-(self.chartView.frame.height * CGFloat((Double(i.c)!-20.8)/(25.4-20.8)))
                updateChart(linePath, lineShapeLayer)
                
            }
        }
        
//        for i in trend.root.tick {
//            xPosition = CGFloat(Double(i.t)!)+40
//
//            yPosition = self.chartView.frame.height-(self.chartView.frame.height * CGFloat((Double(i.c)!-20.8)/(25.4-20.8)))
//
//            updateChart()
//        }
        
        let viewHeight = Int(chartView.frame.height)
        
        drawYScaleLabel(x: 0, y: Double(self.chartView.frame.height/2) - 20, value: self.centerPoint!)
        drawYScaleLabel(x: 0, y: 0, value: self.topPoint!)
        drawYScaleLabel(x: 0, y: Double(self.chartView.frame.height) - 40, value: self.bottomPoint!)
        
        
        //linePath.addLine(to: CGPoint(x: 311, y: self.chartView.frame.height/2-15))
        //lineShapeLayer.path = linePath.cgPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func getTrendData() {
        dataManager.readJson { (trend) in
            self.trend = trend
            self.centerPoint = Double(trend.root.c)
            self.topPoint = Double(trend.root.tp)
            self.bottomPoint = Double(trend.root.bp)
        }
    }
    
    fileprivate func chartViewSetUp() {
        
        let chartViewWidth = self.view.frame.width
        let chartViewHeight = chartScrollView.frame.height
        chartView.frame = CGRect(x: 0, y: 0, width: chartViewWidth , height: chartViewHeight )
        chartView.backgroundColor = UIColor.clear
    }
    
    fileprivate func chartScrollViewSetUp() {
        
        let scrollViewWidth = self.view.frame.width
        let scrollViewHeight = self.view.frame.height/3
        
        chartScrollView.frame = CGRect(x: 0, y: self.view.frame.height/4, width: scrollViewWidth, height: scrollViewHeight)
        chartScrollView.backgroundColor = UIColor.black
        chartScrollView.contentSize = chartView.frame.size
        chartScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    // MARK: - LineChart functions
    
    func updateChart(_ linePath: UIBezierPath, _ lineShapeLayer: CAShapeLayer) {
        
        updateChartViewFrame()
        linePath.addLine(to: CGPoint(x: xPosition, y: yPosition))
        lineShapeLayer.path = linePath.cgPath
        //lineShapeLayer.fillColor = UIColor.clear.cgColor
        lineShapeLayer.fillColor = currentColor.cgColor
        lineShapeLayer.strokeColor = currentColor.cgColor
        lineShapeLayer.lineWidth = 1
        //print(linePath)
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
    
    func makeArray(){
        
        var basicValue = Double(self.trend!.root.c)
        var isUp = false
        var index = 0
        for point in (self.trend?.root.tick)!{
            
            if point.t == "1"{
                if Double(point.c)! >= basicValue!{
                    isUp = true
                }else{
                    isUp = false
                }
                
                var array = [Tick]()
                let zeroPoint = Tick.init(t: "0", o: "\(basicValue!)", h: "\(basicValue!)", l: "\(basicValue!)", c: "\(basicValue!)", v: "0")
                array.append(zeroPoint)
                array.append(point)
                bigArray.append(array)
            }else{
                if Double(point.c)! >= basicValue!{
                    
                    if isUp == false{
                        let array = [Tick]()
                        bigArray.append(array)
                        index += 1
                        
                        //add bigAry[index-1]
                        //add bigAry[index]
                        let lastPoint = bigArray[index-1][bigArray[index-1].count-1]
                        let t = (Double(lastPoint.t)! - Double(point.t)!) / (Double(point.c)! - Double(lastPoint.c)!)
                            * (Double(lastPoint.c)! - basicValue!) + Double(lastPoint.t)!
                        let zeroPoint = Tick.init(t: String(t), o: "\(basicValue!)", h: "\(basicValue!)", l: "\(basicValue!)", c: "\(basicValue!)", v: "0")
                        bigArray[index-1].append(zeroPoint)
                        bigArray[index].append(zeroPoint)
                        
                    }
                    
                    //add point
                    //...
                    bigArray[index].append(point)
                    
                    isUp = true;
                }
                else{
                    
                    if isUp == true{
                        let array = [Tick]()
                        bigArray.append(array)
                        index += 1
                        
                        
                        let lastPoint = bigArray[index-1][bigArray[index-1].count-1]
                        let t = (Double(lastPoint.t)! - Double(point.t)!) / (Double(point.c)! - Double(lastPoint.c)!)
                            * (Double(lastPoint.c)! - basicValue!) + Double(lastPoint.t)!
                        let zeroPoint = Tick.init(t: String(t), o: "\(basicValue!)", h: "\(basicValue!)", l: "\(basicValue!)", c: "\(basicValue!)", v: "0")
                        bigArray[index-1].append(zeroPoint)
                        bigArray[index].append(zeroPoint)
                    }
                    
                    //add point
                    //...
                    bigArray[index].append(point)
                    
                    isUp = false;
                }
            }
        }
        
        
        let zeroPoint = Tick.init(t: "\(self.trend!.root.tick.count)", o: "\(basicValue!)", h: "\(basicValue!)", l: "\(basicValue!)", c: "\(basicValue!)", v: "0")
        bigArray[bigArray.count-1].append(zeroPoint)
        
        for ary in bigArray{
            print("=============")
            print(ary)
        }
        
        
    }
    
    

    
}


