//
//  DataManager.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

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
    
    func transferToDoubleType(trend: Trend) -> TrendDoubleType{
        var tickDoubleArray = [TickDoubleType]()
        
        for i in trend.root.tick {
            
            let tickDoubleType = TickDoubleType.init(t: Double(i.t)!, o: Double(i.o)!, h: Double(i.h)!, l: Double(i.l)!, c: Double(i.c)!, v: Double(i.v)!)
            tickDoubleArray.append(tickDoubleType)
        }
        
        let rootDoubleType = RootDoubleType.init(rc:  Double(trend.root.rc)!, cnts:  Double(trend.root.cnts)!, stk:  Double(trend.root.stk)!, c:  Double(trend.root.c)!, tp:  Double(trend.root.tp)!, bp:  Double(trend.root.bp)!, v:  Double(trend.root.v)!, tt:  Double(trend.root.tt)!, st:  Double(trend.root.st)!, tick: tickDoubleArray)
        
        let trendDoubleType = TrendDoubleType.init(root: rootDoubleType)
        
        return trendDoubleType
        
    }
    
}

