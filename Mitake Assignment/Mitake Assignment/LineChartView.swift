//
//  LineChartView.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/12.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit


class LineChartView: UIView {
    
    var dataPoints: [[CGPoint]]?
    
    var maxPoint: CGPoint?
    
    var minPoint: CGPoint?
    
    var maxValue: Double?
    
    var minValue: Double?
    
    /// Contains dataLayer and gradientLayer
    private let mainLayer: CALayer = CALayer()

    /// Contains the main line which represents the data
    private let dataLayer: CALayer = CALayer()
    
    /// Contains mainLayer and label for each data
    private let scrollView: UIScrollView = UIScrollView()
    
    /// Contains horizontal lines
    private let gridLayer: CALayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        mainLayer.addSublayer(dataLayer)
        scrollView.layer.addSublayer(mainLayer)
        
        self.mainLayer.addSublayer(gridLayer)
        self.addSubview(scrollView)
        self.backgroundColor = UIColor.black
    }
    
     var pathArray = [UIBezierPath]()
    
    /**
     Draw a zigzag line connecting all points in dataPoints
     */
    private func drawChart() {
        createPathArray()
        if let dataPoints = dataPoints,
            dataPoints.count > 0 {
            for i in 0...(pathArray.count-1) {
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = pathArray[i].cgPath
                
                if i%2 == 0 {
                    lineLayer.strokeColor = UIColor.red.cgColor
                    lineLayer.fillColor = UIColor.red.withAlphaComponent(0.5).cgColor
                } else {
                    lineLayer.strokeColor = UIColor.green.cgColor
                    lineLayer.fillColor = UIColor.green.withAlphaComponent(0.5).cgColor
                }
                dataLayer.addSublayer(lineLayer)
                
            }
            
        }
    }
    
    /**
     Create a zigzag bezier path that connects all points in dataPoints
     */
    private func createPathArray() {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return
        }
        
        for part in dataPoints {
            let path = UIBezierPath()
            path.move(to: part.first!)
            for i in part {
                path.addLine(to: i)
                
            }
            
            pathArray.append(path)
            
        }
        
    }
    
    override func layoutSubviews() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        scrollView.contentSize = CGSize(width: self.frame.size.width*2, height: self.frame.size.height)
        mainLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width*2, height: self.frame.size.height)
        gridLayer.frame = CGRect(x: 0, y: 0, width: mainLayer.frame.width, height: self.frame.height)

        drawChart()
        drawGrid()
    }
    
    func drawGrid() {
        
        let path = UIBezierPath()
        let shape = CAShapeLayer()
        
        for i in 0...4 {
            path.move(to: CGPoint(x: 0, y: (gridLayer.frame.height)/4 * CGFloat(i)))
            path.addLine(to: CGPoint(x: gridLayer.frame.width, y: (gridLayer.frame.height)/4 * CGFloat(i)))
            shape.path = path.cgPath
            shape.strokeColor = UIColor.white.cgColor
            shape.lineWidth = 0.5
            gridLayer.addSublayer(shape)
            
        }
        
        for i in 0...5 {
            path.move(to: CGPoint(x: CGFloat(i)*120, y: 0))
            path.addLine(to: CGPoint(x:CGFloat(i)*120, y: gridLayer.frame.height))
            shape.path = path.cgPath
            shape.strokeColor = UIColor.white.cgColor
            shape.lineWidth = 0.5
            gridLayer.addSublayer(shape)
        }
        
        let maxLabelPosition = CGPoint(x: maxPoint!.x, y: maxPoint!.y - 30 )
        let minLabelPosition = CGPoint(x: minPoint!.x - 10 , y: minPoint!.y + 10)
        addLabel(position: maxLabelPosition, value: "\(maxValue!)", backgroundColor: .clear, foregroundColor: .white)
        addLabel(position: minLabelPosition, value: "\(minValue!)", backgroundColor: .clear, foregroundColor: .white)
        
    }
    
    func addLabel(position: CGPoint, value: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(origin: position, size: CGSize(width: 45, height: 20 ))
        textLayer.fontSize = 17
        textLayer.string = value
        textLayer.backgroundColor = backgroundColor.cgColor
        textLayer.foregroundColor = foregroundColor.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        gridLayer.addSublayer(textLayer)
    }
    
    
        
}
        
        

    

  



