//
//  ODSayApiAppCenter.swift
//  ODSayApiSDK
//
//  Created by Steve Kim on 7/20/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//
//

import PSFoundation
import w3action


public enum ODSayApiPath: String {
    case
    PathSearchExit            = "PathSearch_Exit"
}

public class ODSayApiAppCenter: NSObject {
    
    let kODSayApiBasePath = "http://api.openapi.io/traffic/appleTree/v1/0/Path/"
    let kODSayApiServiceKey = "ODSayApiServiceKey"
    let kODSayApiSvcid = "ODSayApiSvcid"
    let kODSayApiParamsEcho = "echo"
    let kODSayApiParamsEncoding = "encoding"
    let kODSayApiParamsOutput = "output"
    let kODSayApiParamsSvcid = "svcid"
    let kODSayApiHeadersXWapleAuthorization = "x-waple-authorization"
    
    // MARK: - Properties
    
    public private(set) var serviceKey: String?
    public private(set) var svcid: String?
    
    // MARK: - Overridden: NSObject
    
    override init() {
        if let serviceKey: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kODSayApiServiceKey) as? String {
            self.serviceKey = serviceKey.stringByRemovingPercentEncoding
        } else {
            #if DEBUG
                print("ODSayApiServiceKey does not exist in info plist file!")
            #endif
        }
        
        if let svcid: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kODSayApiSvcid) as? String {
            self.svcid = svcid.stringByRemovingPercentEncoding
        } else {
            #if DEBUG
                print("ODSayApiSvcid does not exist in info plist file!")
            #endif
        }
    }
    
    // MARK: - Public methods
    
    static public func defaultCenter() -> ODSayApiAppCenter {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ODSayApiAppCenter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ODSayApiAppCenter()
        }
        return Static.instance!
    }
    
    public func call<T: ODSayApiParameterSet, Y: ODSayApiResult>(path aPath: ODSayApiPath,
                     params: T?,
                     completion: ((result: Y?, error: NSError?) -> Void)?) -> NSURLSessionDataTask {
        return HTTPActionManager.sharedInstance().doActionWithRequestObject(
            requestObjectWithPath(aPath, params: params, completion: completion),
            success: {(result: AnyObject?) -> Void in
                if (result != nil && completion != nil) {
                    if let dict = result as? NSDictionary {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            let model = Y(object: dict["result"])
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                completion!(result: model, error: nil)
                            }
                        }
                    } else {
                        completion!(result: nil, error: NSError(domain: ODSayApiGetErrorDomain(ODSayApiErrorCode.UNKNOWN_ERROR), code: ODSayApiErrorCode.UNKNOWN_ERROR.rawValue, userInfo: nil))
                    }
                }
            }, error: {(error: NSError?) -> Void in
                if (completion != nil) {
                    completion!(result: nil, error: error)
                }
        }).sessionDataTask
    }
    
    // MARK: - Private methods
    
    private func requestObjectWithPath<T: ODSayApiParameterSet, Y: ODSayApiResult>(path: ODSayApiPath,
                                       params: T?,
                                       completion: ((result: Y?, error: NSError?) -> Void)?) -> HTTPRequestObject {
        let url: String = kODSayApiBasePath + path.rawValue + ".asp"
        
        let _params = params != nil ? NSMutableDictionary(dictionary: params!.dictionary) : NSMutableDictionary()
        _params[kODSayApiParamsSvcid] = svcid
        _params[kODSayApiParamsEncoding] = "utf-8"
        _params[kODSayApiParamsOutput] = "json"
        _params[kODSayApiParamsEcho] = "yes"
        
        let object: HTTPRequestObject = HTTPRequestObject()
        object.headers = [kODSayApiHeadersXWapleAuthorization: serviceKey!]
        object.param = _params as [NSObject: AnyObject]?
        object.action = ["url": url,
                         "method": HTTPRequestMethodGet,
                         "contentType": ContentTypeApplicationXWWWFormURLEncoded,
                         "dataType": DataTypeJSON,
                         "timeout": (10),
                         "async": (true)]
        return object
    }
}
