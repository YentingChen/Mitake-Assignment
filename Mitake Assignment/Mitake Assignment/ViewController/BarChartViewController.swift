//
//  BarChartViewController.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/11.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class BarChartViewController: UIViewController {
    
    let dataManager = DataManager()
    var trend: TrendDoubleType?
    
    let barChart = UIView()
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = CGRect(x: 60, y: 100, width: self.view.frame.width, height: self.view.frame.height/2)
        barChart.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width*2, height: self.scrollView.frame.height)
        barChart.backgroundColor = UIColor.black
        scrollView.contentSize = barChart.frame.size
        self.scrollView.addSubview(barChart)
        self.view.addSubview(scrollView)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataManager.readJson { (trend) in
            self.trend = trend
            addBaseLine()
            addLine()
            
        }
        
    }
    
    func addLine() {
        guard let trend = self.trend else {
            return
        }
        
        for i in trend.root.tick {
            let path = UIBezierPath()
            let shape = CAShapeLayer()
            let fakeView = UIView()
            fakeView.frame = CGRect(x: 0, y: 0, width: barChart.frame.width, height: barChart.frame.height-50)
            path.move(to: CGPoint(x: i.t*2, y: Double.convertToChartViewYCoordinate(view: fakeView, yValue: 0, tp: 805, bp: 0) ))
            path.addLine(to: CGPoint(x: i.t*2, y: Double.convertToChartViewYCoordinate(view: fakeView, yValue: i.v, tp: 805, bp: 0)))
            shape.path = path.cgPath
            shape.strokeColor = UIColor.blue.cgColor
            shape.lineWidth = 1
            barChart.layer.addSublayer(shape)
        }
        
       
        
        
    }
    
    func addBaseLine() {
        
        let path = UIBezierPath()
        let shape = CAShapeLayer()
        
        for i in 0...3 {
            path.move(to: CGPoint(x: 0, y: (barChart.frame.height-50)/3 * CGFloat(i)))
            path.addLine(to: CGPoint(x: barChart.frame.width, y: (barChart.frame.height-50)/3 * CGFloat(i)))
            shape.path = path.cgPath
            shape.strokeColor = UIColor.white.cgColor
            shape.lineWidth = 0.5
            barChart.layer.addSublayer(shape)
            
        }
        
        var time = 8
        for i in 0...5 {
            
            time+=1
            path.move(to: CGPoint(x: CGFloat(i)*120, y: 0))
            path.addLine(to: CGPoint(x:CGFloat(i)*120, y: barChart.frame.height-50))
            shape.path = path.cgPath
            shape.strokeColor = UIColor.white.cgColor
            shape.lineWidth = 0.5
            barChart.layer.addSublayer(shape)
            if i != 5 {
                addXScaleLabel(x: Double(i*120), y: Double(barChart.frame.height-50), value: time)
            }
    
        }
        addYScaleLabel(x: 0, y: 85, value: 805, textColor: UIColor.white, backgroundColor: UIColor.clear)
        addYScaleLabel(x: 0, y: 85 + Double((barChart.frame.height-50)/3 * 1), value: 537, textColor: UIColor.white, backgroundColor: UIColor.clear)
        addYScaleLabel(x: 0, y: 85 + Double((barChart.frame.height-50)/3 * 2), value: 268, textColor: UIColor.white, backgroundColor: UIColor.clear)
    }
    
    func addXScaleLabel(x: Double, y:Double, value: Int){
        let xScaleLabel = UILabel()
        xScaleLabel.frame = CGRect(x: x, y: y, width: 40, height: 30)
        if value < 10 {
            xScaleLabel.text = "0\(value)"
        } else {
            xScaleLabel.text = "\(value)"
        }
        
        xScaleLabel.textColor = UIColor.white
        xScaleLabel.backgroundColor = UIColor.clear
        self.barChart.addSubview(xScaleLabel)
    }
    
    func addYScaleLabel(x: Double, y:Double, value: Double, textColor: UIColor, backgroundColor: UIColor){
        let yScaleLabel = UILabel()
        yScaleLabel.frame = CGRect(x: x, y: y, width: 50, height: 30)
        yScaleLabel.text = "\(Int(value))"
        yScaleLabel.textColor = textColor
        yScaleLabel.backgroundColor = backgroundColor
        yScaleLabel.textAlignment = .center
        self.view.addSubview(yScaleLabel)
    }

}
