//
//  TrendModel.swift
//  Mitake Assignment
//
//  Created by Yenting Chen on 2019/6/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

struct Trend: Codable {
    let root: Root
}

struct Root: Codable {
    let rc, cnts, stk, c: String
    let tp, bp, v, tt: String
    let st: String
    let tick: [Tick]
}

struct Tick: Codable {
    let t, o, h, l: String
    let c, v: String
}

//Double Type
struct TrendDoubleType {
    let root: RootDoubleType
}

struct RootDoubleType {
    let rc, cnts, stk, c: Double
    let tp, bp, v, tt: Double
    let st: Double
    let tick: [TickDoubleType]
}

struct TickDoubleType {
    let t, o, h, l: Double
    let c, v: Double
}

