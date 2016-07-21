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
    public enum SubwayCode: UInt {
        case
        L1  = 1,
        L2  = 2,
        L3  = 3,
        L4  = 4,
        L5  = 5,
        L6  = 6,
        L7  = 7,
        L8  = 8,
        L9  = 9,
        LK  = 104,
        LB  = 105,
        LSB  = 106
    }
    
    public enum TrafficType: UInt {
        case
        Subway  = 1,
        Bus     = 2,
        Walk    = 3
    }
    
    public class Path: AbstractJSONModel {
        public var pathType: UInt = 0
        public private(set) var info: ODSayApiModel.Info?
        public private(set) var subPath: [ODSayApiModel.SubPath]?
        public private(set) var subPathExcludesWalk: [ODSayApiModel.SubPath]?
        
        override public func setProperties(object: AnyObject?) {
            super.setProperties(object)
            
            if let object = object {
                info = self.childWithKey("info", classType: ODSayApiModel.Info.self) as? ODSayApiModel.Info
                
                if let rawSubPath = object["subPath"] as? [NSDictionary] {
                    subPath = []
                    subPathExcludesWalk = []
                    
                    for dict in rawSubPath {
                        let trafficType = dict["trafficType"] as? UInt
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
                            
                            if trafficType != TrafficType.Walk.rawValue {
                                subPathExcludesWalk?.append(subPathItem)
                            }
                        }
                    }
                }
            }
        }
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
    
    public class SubPath: AbstractJSONModel {
        public var distance: UInt = 0
        public var trafficType: UInt = 0
        public var sectionTime: Int = 0
        
        public class Transport: SubPath {
            public var endID: UInt = 0
            public var stationCount: UInt = 0
            public var startID: UInt = 0
            public var endX: Double = 0.0
            public var endY: Double = 0.0
            public var startX: Double = 0.0
            public var startY: Double = 0.0
            public var endName: String?
            public var startName: String?
            public private(set) var passStopList: PassStopList?
            
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    passStopList = self.childWithKey("passStopList", classType: PassStopList.self) as? PassStopList
                }
            }
        }
        
        public class Bus: Transport {
            public private(set) var lane: [Lane.Bus]?
            
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    lane = self.childWithKey("lane", classType: Lane.Bus.self) as? [Lane.Bus]
                }
            }
        }
        
        public class Subway: Transport {
            public var wayCode: UInt = 0
            public var startExitX: Double = 0.0
            public var startExitY: Double = 0.0
            public var door: String?
            public var startExitNo: String?
            public var way: String?
            public private(set) var lane: [Lane.Subway]?
            
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    lane = self.childWithKey("lane", classType: Lane.Subway.self) as? [Lane.Subway]
                }
            }
        }
        
        public class Walk: SubPath {
            
        }
    }
    
    public class Lane {
        public class Bus: AbstractJSONModel {
            public var busID: UInt = 0
            public var busNo: UInt = 0
            public var type: UInt = 0
        }
        
        public class Subway: AbstractJSONModel {
            public var subwayCityCode: UInt = 0
            public var subwayCode: UInt = 0
            public var name: String?
        }
    }
    
    public class PassStopList: AbstractJSONModel {
        public private(set) var stations: [Station]?
        
        override public func setProperties(object: AnyObject?) {
            super.setProperties(object)
            
            if let object = object {
                stations = self.childWithKey("stations", classType: Station.self) as? [Station]
            }
        }
    }
    
    public class Station: AbstractJSONModel {
        public var index: UInt = 0
        public var stationID: UInt = 0
        public var x: Double = 0
        public var y: Double = 0
        public var stationName: String?
    }
}