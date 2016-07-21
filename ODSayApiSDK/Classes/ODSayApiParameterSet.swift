//
//  ODSayApiParameterSet.swift
//  ODSayApiSDK
//
//  Created by Steve Kim on 7/20/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//
//

import PSFoundation

public class ODSayApiParameterSet: AbstractModel {
    
    public class PathSearchExit: ODSayApiParameterSet {
        public var changeCount: UInt = 0
        public var optCount: UInt = 0
        public var resultCount: UInt = 0
        public var OPT: UInt = 0
        public var SearchType: UInt = 0
        public var SX: Double = 127.101624
        public var SY: Double = 37.602018
        public var EX: Double = 127.010245
        public var EY: Double = 37.489199
        public var radius: String?
        public var weightTime: String?
    }
}
