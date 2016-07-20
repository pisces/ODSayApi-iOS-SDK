//
//  ODSayApiResult.swift
//  ODSayApiSDK
//
//  Created by Steve Kim on 7/20/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//
//

import PSFoundation

public class ODSayApiResult: AbstractJSONModel {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override public init(object: AnyObject?) {
        super.init(object: object)
    }
    
    public class PathSearchExit: ODSayApiResult {
        public var busCount: UInt = 0
        public var endRadius: UInt = 0
        public var outTrafficCheck: UInt = 0
        public var pointDistance: UInt = 0
        public var searchType: UInt = 0
        public var startRadius: UInt = 0
        public var subwayBusCount: UInt = 0
        public var subwayCount: UInt = 0
        public var path: [ODSayApiModel.Path]?
        
        override public func setProperties(object: AnyObject?) {
            super.setProperties(object)
            
            if let object = object {
                path = self.childWithKey("path", classType: ODSayApiModel.Path.self) as? [ODSayApiModel.Path]
            }
        }
    }
}

public class ODSayApiModel {
    public enum TrafficType: Int {
        case
        Subway  = 1,
        Bus     = 2,
        Walk    = 3
    }
    
    public class Info: AbstractJSONModel {
        public var busStationCount: UInt = 0
        public var busTransitCount: UInt = 0
        public var payment: UInt = 0
        public var subwayStationCount: UInt = 0
        public var subwayTransitCount: UInt = 0
        public var totalDistance: UInt = 0
        public var totalStationCount: UInt = 0
        public var totalTime: UInt = 0
        public var totalWalk: UInt = 0
        public var trafficDistance: UInt = 0
        public var totalWalkTime: Int = 0
        public var firstStartStation: String?
        public var lastEndStation: String?
        public var mapObj: String?
    }
    
    public class Path: AbstractJSONModel {
        public var pathType: UInt = 0
        public private(set) var info: ODSayApiModel.Info?
        public private(set) var subPath: [ODSayApiModel.SubPath]?
        
        override public func setProperties(object: AnyObject?) {
            super.setProperties(object)
            
            if let object = object {
                info = self.childWithKey("info", classType: ODSayApiModel.Info.self) as? ODSayApiModel.Info
                
                if let rawSubPath = object["subPath"] as? [NSDictionary] {
                    subPath = []
                    
                    for dict in rawSubPath {
                        let trafficType = dict["trafficType"] as? Int
                        var subPathItem: SubPath?
                        
                        if trafficType == TrafficType.Bus.rawValue {
                            subPathItem = SubPath.Bus(object: dict)
                        } else if trafficType == TrafficType.Subway.rawValue {
                            subPathItem = SubPath.Subway(object: dict)
                        } else if trafficType == TrafficType.Walk.rawValue {
                            subPathItem = SubPath.Walk(object: dict)
                        }
                        
                        if let subPathItem = subPathItem {
                            subPath!.append(subPathItem)
                        }
                    }
                }
            }
        }
    }
    
    public class SubPath: AbstractJSONModel {
        public var distance: UInt = 0
        public var trafficType: UInt = 0
        public var sectionTime: Int = 0
        
        public class Bus: SubPath {
            
        }
        
        public class Subway: SubPath {
            
        }
        
        public class Walk: SubPath {
            
        }
    }
}