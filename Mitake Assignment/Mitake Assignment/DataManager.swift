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
    
   
    
    func readJson(complitionHandler: (Trend)-> Void) {
        
        do {
            if let file = Bundle.main.url(forResource: "trend_2201", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let trend = try self.decoder.decode(Trend.self, from: data)
                complitionHandler(trend)
                
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
