//
//  DataManager.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    let decoder = JSONDecoder()
    
    func readJson(complitionHandler: (TrendDoubleType)-> Void) {
        
        do {
            if let file = Bundle.main.url(forResource: "trend_2201", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let trend = try self.decoder.decode(Trend.self, from: data)
                let trendDoubleType = transferToDoubleType(trend: trend)
                complitionHandler(trendDoubleType)
                
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func transferToDoubleType(trend: Trend) -> TrendDoubleType {
        var tickDoubleArray = [TickDoubleType]()
        
        for i in trend.root.tick {
            
            let tickDoubleType = TickDoubleType.init(t: Double(i.t)!, o: Double(i.o)!, h: Double(i.h)!, l: Double(i.l)!, c: Double(i.c)!, v: Double(i.v)!)
            tickDoubleArray.append(tickDoubleType)
        }
        
        let rootDoubleType = RootDoubleType.init(rc:  Double(trend.root.rc)!, cnts:  Double(trend.root.cnts)!, stk:  Double(trend.root.stk)!, c:  Double(trend.root.c)!, tp:  Double(trend.root.tp)!, bp:  Double(trend.root.bp)!, v:  Double(trend.root.v)!, tt:  Double(trend.root.tt)!, st:  Double(trend.root.st)!, tick: tickDoubleArray)
        
        let trendDoubleType = TrendDoubleType.init(root: rootDoubleType)
        
        return trendDoubleType
        
    }
    
    
    func findMaxAndMin(view: UIView, trend: TrendDoubleType, hadler: (TickDoubleType, TickDoubleType) -> Void, handler2: (CGPoint, CGPoint) -> Void) {
        var maxCGPoint: CGPoint?
        var minCGPoint: CGPoint?
        var maxValue = trend.root.c
        var minValue = trend.root.c
        var maxPoint: TickDoubleType?
        var minPoint: TickDoubleType?
        
        for point in trend.root.tick {
            
            if Double(point.h) > maxValue {
                maxValue = Double(point.h)
                maxPoint = point
                maxCGPoint = CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.h, tp: trend.root.tp, bp: trend.root.bp))
            }
            
            if Double(point.l) < minValue {
                minValue = Double(point.l)
                minPoint = point
                minCGPoint = CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.l, tp: trend.root.tp, bp: trend.root.bp))
                print(minCGPoint)
            }
            
        }
        hadler(maxPoint!, minPoint!)
        handler2(maxCGPoint!, minCGPoint!)
    }
    
    var cgPointsArray = [[CGPoint]]()
    
    func makeLineArray(view: UIView, trend: TrendDoubleType, handler: ([[TickDoubleType]]) -> Void, hadler2: ([[CGPoint]]) -> Void ) {
        var bigArray = [[TickDoubleType]]()
        var bigPointArray = [[CGPoint]]()
        let basicValue = trend.root.c
        var isUp = false
        var index = 0
        var maxValue = trend.root.c
        var minValue = trend.root.c

        for point in trend.root.tick {
            
            if Double(point.h) > maxValue {
                maxValue = Double(point.h)
                
            }
            
            if Double(point.l) < minValue {
                minValue = Double(point.l)
                
            }
            
            if point.t == 1 {
                if Double(point.c) >= basicValue {
                    isUp = true
                }else{
                    isUp = false
                }
                
                var pointArray = [CGPoint]()
                var array = [TickDoubleType]()
                let origin = TickDoubleType.init(t: 0, o: basicValue, h: basicValue, l: basicValue, c: basicValue, v: 0)
                array.append(origin)
                pointArray.append(CGPoint(x: origin.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: origin.c, tp: trend.root.tp, bp: trend.root.bp)))
                array.append(point)
                if point.c > basicValue {
                    pointArray.append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.h, tp: trend.root.tp, bp: trend.root.bp)))
                } else if point.c < basicValue {
                    pointArray.append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.l, tp: trend.root.tp, bp: trend.root.bp)))
                } else {
                    pointArray.append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.h, tp: trend.root.tp, bp: trend.root.bp)))
                }
                
                bigArray.append(array)
                bigPointArray.append(pointArray)
                
            }else{
                
                if point.c >= basicValue {
                    
                    if isUp == false{
                        let array = [TickDoubleType]()
                        let pointArray = [CGPoint]()
                        bigArray.append(array)
                        bigPointArray.append(pointArray)
                        
                        index += 1
                        
                        //add bigAry[index-1]
                        //add bigAry[index]
                        let lastPoint = bigArray[index-1][bigArray[index-1].count-1]
                        let t = (lastPoint.t - point.t) / (point.c - lastPoint.c)
                            * (lastPoint.c - basicValue) + lastPoint.t
                        let zeroPoint = TickDoubleType.init(t: t, o: basicValue, h: basicValue, l: basicValue, c: basicValue, v: 0)
                        bigArray[index-1].append(zeroPoint)
                        bigArray[index].append(zeroPoint)
                        bigPointArray[index-1].append(CGPoint(x: zeroPoint.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: zeroPoint.c, tp: trend.root.tp, bp: trend.root.bp)))
                        bigPointArray[index].append(CGPoint(x: zeroPoint.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: zeroPoint.c, tp: trend.root.tp, bp: trend.root.bp)))
                    
                    }
                    
                    //add point
                    //...
                    bigArray[index].append(point)
                    if point.c > basicValue {
                        bigPointArray[index].append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.h, tp: trend.root.tp, bp: trend.root.bp)))
                    } else if point.c < basicValue {
                        bigPointArray[index].append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.l, tp: trend.root.tp, bp: trend.root.bp)))
                    } else {
                        bigPointArray[index].append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.c, tp: trend.root.tp, bp: trend.root.bp)))
                    }
                    
                    isUp = true
                }
                else {
                    
                    if isUp == true{
                        let array = [TickDoubleType]()
                        let pointArray = [CGPoint]()
                        bigArray.append(array)
                        bigPointArray.append(pointArray)
                        index += 1
                        
                        
                        let lastPoint = bigArray[index-1][bigArray[index-1].count-1]
                        let t = (lastPoint.t - point.t) / ( point.c - lastPoint.c)
                            * (lastPoint.c - basicValue) + lastPoint.t
                        let zeroPoint = TickDoubleType.init(t: t, o: basicValue, h: basicValue, l: basicValue, c: basicValue, v: 0)
                        bigArray[index-1].append(zeroPoint)
                        bigArray[index].append(zeroPoint)
                        bigPointArray[index-1].append(CGPoint(x: zeroPoint.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: zeroPoint.c, tp: trend.root.tp, bp: trend.root.bp)))
                        bigPointArray[index].append(CGPoint(x: zeroPoint.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: zeroPoint.c, tp: trend.root.tp, bp: trend.root.bp)))
                    }
                    
                    //add point
                    //...
                    bigArray[index].append(point)
                    
                    if point.c > basicValue {
                        bigPointArray[index].append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.h, tp: trend.root.tp, bp: trend.root.bp)))
                    } else if point.c < basicValue {
                        bigPointArray[index].append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.l, tp: trend.root.tp, bp: trend.root.bp)))
                    } else {
                        bigPointArray[index].append(CGPoint(x: point.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: point.c, tp: trend.root.tp, bp: trend.root.bp)))
                    }
                    
                    isUp = false
                }
            }
        }
        
        let zeroPoint = TickDoubleType.init(t: Double(trend.root.tick[trend.root.tick.count-1].t + 1), o: basicValue, h: basicValue, l: basicValue, c: basicValue, v: 0)
        bigArray[bigArray.count-1].append(zeroPoint)
        bigPointArray[bigPointArray.count-1].append(CGPoint(x: zeroPoint.t*2, y: Double.convertToChartViewYCoordinate(view: view, yValue: zeroPoint.c, tp: trend.root.tp, bp: trend.root.bp)))
        
        
        handler(bigArray)
        hadler2(bigPointArray)
    }
    
}

