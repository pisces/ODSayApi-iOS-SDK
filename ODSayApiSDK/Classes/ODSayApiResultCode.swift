//
//  ODSayApiResultCode.swift
//  ODSayApiSDK
//
//  Created by Steve Kim on 7/20/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//
//

import Foundation

public enum ODSayApiErrorCode: Int {
    case
    UNKNOWN_ERROR = 99
}

func ODSayApiGetErrorDomain(resultCode: ODSayApiErrorCode) -> String {
    switch resultCode {
    case ODSayApiErrorCode.UNKNOWN_ERROR:
        return "UNKNOWN_ERROR"
    default:
        return ""
    }
}