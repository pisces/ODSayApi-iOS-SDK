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
    
    public class MapLoadLane: ODSayApiResult {
        public var boundary: Boundary?
        public var lane: [Lane]?
        
        override public func setProperties(object: AnyObject?) {
            super.setProperties(object)
            
            if let object = object {
                boundary = self.childWithKey("boundary", classType: Boundary.self) as? Boundary
                lane = self.childWithKey("lane", classType: Lane.self) as? [Lane]
            }
        }
        
        public class Boundary: AbstractJSONModel {
            public var left: Double = 0.0
            public var top: Double = 0.0
            public var right: Double = 0.0
            public var bottom: Double = 0.0
        }
        
        public class Lane: AbstractJSONModel {
            public var trafficType: Int = 0
            public var type: Int = 0
            public var section: [Section]?
            
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    trafficType = object["class"] as! Int
                    section = self.childWithKey("section", classType: Section.self) as? [Section]
                }
            }
        }
        
        public class Pos: AbstractJSONModel {
            public var x: Double = 0.0
            public var y: Double = 0.0
        }
        
        public class Section: AbstractJSONModel {
            public var graphPos: [Pos]?
            
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    graphPos = self.childWithKey("graphPos", classType: Pos.self) as? [Pos]
                }
            }
        }
    }
    
    public class PathSearchExit: ODSayApiResult {
        public var busCount: Int = 0
        public var endRadius: Int = 0
        public var outTrafficCheck: Int = 0
        public var pointDistance: Int = 0
        public var searchType: Int = 0
        public var startRadius: Int = 0
        public var subwayBusCount: Int = 0
        public var subwayCount: Int = 0
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
    public enum BusType: Int {
        case
        General         = 1,
        Seat            = 2,
        Town            = 3,
        DirectlySeat    = 4,
        Airport         = 5,
        TrunkExpress    = 6,
        Suburban        = 10,
        Trunk           = 11,
        Branch          = 12,
        Cycle           = 13,
        Wide            = 14,
        Express         = 15,
        FarmOrSea       = 20,
        Jeju            = 22,
        ExpressTrunk    = 26
    }
    
    public enum PathType: Int {
        case
        Subway = 1,
        Bus = 2,
        SubwayAndBus = 3
    }
    
    public enum SubwayCode: Int {
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
        Incheon  = 21,
        Bundang  = 100,
        Airport  = 101,
        Kyungui  = 104,
        Ever  = 107,
        Kyungchoon  = 108,
        SinBundang  = 109,
        Uijeongbu  = 110,
        Suin  = 111
    }
    
    public enum TrafficType: Int {
        case
        Subway  = 1,
        Bus     = 2,
        Walk    = 3
    }
    
    public class Path: AbstractJSONModel {
        public var pathType: Int = 0
        public var attributedInfoString: NSAttributedString?
        public var attributedSubPathString: NSAttributedString?
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
        public var busStationCount: Int = 0
        public var busTransitCount: Int = 0
        public var payment: Int = 0
        public var subwayStationCount: Int = 0
        public var subwayTransitCount: Int = 0
        public var totalDistance: Int = 0
        public var totalStationCount: Int = 0
        public var totalTime: Int = 0
        public var totalWalk: Int = 0
        public var trafficDistance: Int = 0
        public var totalWalkTime: Int = 0
        public var firstStartStation: String?
        public var lastEndStation: String?
        public var mapObj: String?
        
        public var paymentString: String {
            get {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                return formatter.stringFromNumber(payment)!
            }
        }
    }
    
    public class SubPath: AbstractJSONModel {
        public var distance: Int = 0
        public var trafficType: Int = 0
        public var sectionTime: Int = 0
        
        public class Transport: SubPath {
            public var endID: Int = 0
            public var stationCount: Int = 0
            public var startID: Int = 0
            public var endX: Double = 0.0
            public var endY: Double = 0.0
            public var startX: Double = 0.0
            public var startY: Double = 0.0
            public var endName: String?
            public var startName: String?
            public private(set) var lane: [Lane]?
            public private(set) var passStopList: PassStopList?
            
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    passStopList = self.childWithKey("passStopList", classType: PassStopList.self) as? PassStopList
                }
            }
            
            override public func format(value: AnyObject!, forKey key: String!) -> AnyObject! {
                if value is String {
                    return (value as! String).decode
                }
                
                return super.format(value, forKey: key)
            }
            
            override public func unformat(value: AnyObject!, forKey key: String!) -> AnyObject! {
                if value is String {
                    return (value as! String).encode
                }
                
                return super.unformat(value, forKey: key)
            }
        }
        
        public class Bus: Transport {
            override public func setProperties(object: AnyObject?) {
                super.setProperties(object)
                
                if let object = object {
                    lane = self.childWithKey("lane", classType: Lane.Bus.self) as? [Lane.Bus]
                }
            }
        }
        
        public class Subway: Transport {
            public var wayCode: Int = 0
            public var startExitX: Double = 0.0
            public var startExitY: Double = 0.0
            public var door: String?
            public var startExitNo: String?
            public var way: String?
            
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
    
    public class Lane: AbstractJSONModel {
        public class Bus: Lane {
            public var busID: Int = 0
            public var busNo: Int = 0
            public var type: Int = 0
        }
        
        public class Subway: Lane {
            public var subwayCityCode: Int = 0
            public var subwayCode: Int = 0
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
        public var index: Int = 0
        public var stationID: Int = 0
        public var x: Double = 0
        public var y: Double = 0
        public var stationName: String?
    }
    
    public class Section: AbstractJSONModel {
        
    }
}