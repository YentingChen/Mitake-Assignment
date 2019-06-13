//
//  ChartViewController.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/10.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

//class ChartViewController: UIViewController {
//    
//    var chartScrollView = UIScrollView()
//    let chartView = UIView()
//    var trend: TrendDoubleType?
//    var basePoint =  Double()
//    var maxTick: TickDoubleType?
//    var minTick: TickDoubleType?
//    var lineArray = [[TickDoubleType]]()
//    let dataManager = DataManager()
//
//    fileprivate func getData() {
//        
//       
//        dataManager.readJson { (trend) in
//            
//            self.trend = trend
//            
//            dataManager.findMaxAndMin(view: chartView, trend: trend, hadler: { (max, min) in
//                
//                self.maxTick = max
//                self.minTick = min
//                
//            }, handler2: { (max, min) in
//                
//            })
//            
//            dataManager.makeLineArray(view: chartView, trend: trend, handler: { (array) in
//                
//                self.lineArray = array
//                
//            }, hadler2: { (pointArray) in
//                
//            })
//            
//            
//        }
//    }
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        setChartView()
//        self.chartScrollView.contentSize = chartView.frame.size
//        self.chartScrollView.addSubview(chartView)
//        self.view.addSubview(chartScrollView)
//        getData()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        makeLine()
//        addAllLabel()
//        
//    }
//    
//    fileprivate func chartScrollViewSetUp() {
//        
//        let scrollViewWidth = self.view.frame.width - self.chartView.frame.maxX
//        let scrollViewHeight:CGFloat = 400
//        
//        chartScrollView.frame = CGRect(x: 60, y: 100, width: scrollViewWidth, height: scrollViewHeight)
//        chartScrollView.backgroundColor = UIColor.black
//        chartScrollView.contentSize = chartView.frame.size
//        chartScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    }
//    
//    fileprivate func setChartView() {
//        
//        chartScrollViewSetUp()
//        chartView.frame = CGRect(x: 0, y: 0, width: chartScrollView.frame.width*2, height: chartScrollView.frame.height)
//        
//        chartView.backgroundColor = .black
//        self.view.backgroundColor = UIColor.black
//        makeBaseFrame()
//        
//    }
//    
//    func makeBaseFrame() {
//        //horizon
//        for i in 0...4 {
//            addBaseLine(origin: CGPoint(x: 0, y: chartScrollView.frame.height*CGFloat(i)/4), destination: CGPoint(x: chartScrollView.frame.width*2, y: chartScrollView.frame.height*CGFloat(i)/4))
//        }
//        //vertical
//        for i in 0...5 {
//             addBaseLine(origin: CGPoint(x: CGFloat(i*120), y: 0), destination: CGPoint(x: CGFloat(i*120), y: chartScrollView.frame.height))
//        }
//
//        
//    }
//    
//    func addAllLabel() {
//        //yScale
//        addYScaleLabel(x: 10, y: 100, value: self.trend!.root.tp, textColor: UIColor.white, backgroundColor: UIColor.red)
//        addYScaleLabel(x: 10, y: Double(chartScrollView.frame.height+100-30), value: self.trend!.root.bp, textColor: UIColor.black, backgroundColor: UIColor.green)
//        addYScaleLabel(x: 10, y: Double(chartScrollView.frame.height/2+100-15), value: self.trend!.root.c, textColor: UIColor.white, backgroundColor: UIColor.clear)
//        
//        //xScale
//        var time = 9
//        for i in 0...4 {
//            addXScaleLabel(x: Double(i*120), y: Double(chartScrollView.frame.height - 30), value: time)
//            time += 1
//        }
//        
//        //max, min
//        addValueLabel(x: self.maxTick!.t*2, y: Double.convertToChartViewYCoordinate(view: chartView, yValue: self.maxTick!.h, tp: self.trend!.root.tp, bp: self.trend!.root.bp)-30, value: self.maxTick!.h)
//        addValueLabel(x: self.minTick!.t*2-15, y: Double.convertToChartViewYCoordinate(view: chartView, yValue: self.minTick!.l, tp: self.trend!.root.tp, bp: self.trend!.root.bp), value: self.minTick!.l)
//        
//    }
//    
//    func addValueLabel(x: Double, y: Double, value: Double) {
//        let valueLabel = UILabel()
//        valueLabel.frame = CGRect(x: x, y: y, width: 60, height: 30)
//       
//        valueLabel.text = "\(value)"
//        valueLabel.textColor = UIColor.white
//        valueLabel.backgroundColor = UIColor.clear
//        self.chartView.addSubview(valueLabel)
//    }
//    
//    
//    func addYScaleLabel(x: Double, y:Double, value: Double, textColor: UIColor, backgroundColor: UIColor){
//        let yScaleLabel = UILabel()
//        yScaleLabel.frame = CGRect(x: x, y: y, width: 50, height: 30)
//        yScaleLabel.text = "\(value)0"
//        yScaleLabel.textColor = textColor
//        yScaleLabel.backgroundColor = backgroundColor
//        yScaleLabel.textAlignment = .center
//        self.view.addSubview(yScaleLabel)
//    }
//    
//    func addXScaleLabel(x: Double, y:Double, value: Int){
//        let xScaleLabel = UILabel()
//        xScaleLabel.frame = CGRect(x: x, y: y, width: 40, height: 30)
//        if value < 10 {
//            xScaleLabel.text = "0\(value)"
//        } else {
//            xScaleLabel.text = "\(value)"
//        }
//        
//        xScaleLabel.textColor = UIColor.white
//        xScaleLabel.backgroundColor = UIColor.clear
//        self.chartView.addSubview(xScaleLabel)
//    }
//    
//    func addBaseLine(origin: CGPoint, destination: CGPoint) {
//        
//        let linePath = UIBezierPath()
//        let lineShapeLayer = CAShapeLayer()
//        linePath.move(to: origin)
//        linePath.addLine(to: destination)
//        lineShapeLayer.path = linePath.cgPath
//        lineShapeLayer.strokeColor = UIColor.lightGray.cgColor
//        lineShapeLayer.lineWidth = 0.5
//        chartView.layer.addSublayer(lineShapeLayer)
//        
//    }
//    
//    func updateChart(_ linePath: UIBezierPath, _ lineShapeLayer: CAShapeLayer, xPosition: Double, yPosition: Double, currentColor: UIColor) {
//
//        linePath.addLine(to: CGPoint(x: xPosition, y: yPosition))
//        lineShapeLayer.path = linePath.cgPath
//        lineShapeLayer.fillColor = currentColor.withAlphaComponent(0.2).cgColor
//        lineShapeLayer.strokeColor = currentColor.cgColor
//        
//        lineShapeLayer.lineWidth = 1
//        
//        chartView.layer.addSublayer(lineShapeLayer)
//    }
//    
//    
//    func makeLine() {
//        guard let trend = self.trend else { return }
//        
//        var currentColor = UIColor.red
//        var xPosition = Double()
//        var yPosition = Double.convertToChartViewYCoordinate(view: chartView, yValue: trend.root.c, tp: trend.root.tp, bp: trend.root.bp)
//        
//        for part in lineArray{
//            
//            let origin = CGPoint(x: xPosition, y: yPosition)
//            let linePath = UIBezierPath()
//            let lineShapeLayer = CAShapeLayer()
//            linePath.move(to: origin)
//            
//            
//            for i in part {
//                
//                if i.c > trend.root.c {
//                    currentColor = UIColor.red
//                    yPosition = Double.convertToChartViewYCoordinate(view: chartView, yValue: i.h, tp: trend.root.tp , bp: trend.root.bp)
//
//                }
//                else if i.c < trend.root.c {
//                    currentColor = UIColor.green
//                    yPosition = Double.convertToChartViewYCoordinate(view: chartView, yValue: i.l, tp: trend.root.tp , bp: trend.root.bp)
//                }
//                else{
//                    
//                    yPosition = Double.convertToChartViewYCoordinate(view: chartView, yValue: i.c, tp: trend.root.tp , bp: trend.root.bp)
//                }
//                
//                xPosition = Double(CGFloat(i.t)*2 )
//                updateChart(linePath, lineShapeLayer, xPosition: xPosition, yPosition: yPosition, currentColor: currentColor)
//
//            }
//        }
//    }
//   
//
//}


    
   


