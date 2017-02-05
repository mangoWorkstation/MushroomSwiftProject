//
//  DataSourceModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/9/2.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
import CoreGraphics

class DataSource : NSObject {
    
    var timestamp: TimeInterval?
    var finalIdentifier: String!
    var arr_airTemperature: [CGFloat]?
    var arr_airHumidity: [CGFloat]?
    var arr_soilTemperatrue: [CGFloat]?
    var arr_soilHumidity: [CGFloat]?
    
    private var currentAirTemperature: CGFloat?
    private var currentAirHumidity: CGFloat?
    private var currentSoilTemperature: CGFloat?
    private var currentSoilHumidity: CGFloat?
    
    var arr_CO2: [CGFloat]?
    private var currentCO2: CGFloat?
    
    var arr_Voltage: [CGFloat]?
    private var currentVoltage: CGFloat?
    
    init(roomID:String!,area:String!,level:String?,timestamp:TimeInterval!,arr_airTemperature:[CGFloat]?,arr_airHumidity:[CGFloat]?,arr_soilTemperatrue:[CGFloat]?,arr_soilHumidity:[CGFloat]?,arr_CO2:[CGFloat]?,arr_Voltage: [CGFloat]?) {
        if level != nil{
            self.finalIdentifier = roomID + area + level!
        }
        else {
            self.finalIdentifier = roomID + area
        }
        self.timestamp = timestamp
        self.arr_airTemperature = arr_airTemperature
        self.arr_airHumidity = arr_airHumidity
        self.arr_soilTemperatrue = arr_soilTemperatrue
        self.arr_soilHumidity = arr_soilHumidity
        self.arr_CO2 = arr_CO2
        self.arr_Voltage = arr_Voltage
        
        self.currentCO2 = arr_CO2?.last
        self.currentVoltage = arr_Voltage?.last
        self.currentAirTemperature = arr_airTemperature?.last
        self.currentAirHumidity = arr_airHumidity?.last
        self.currentSoilTemperature = arr_soilTemperatrue?.last
        self.currentSoilHumidity = arr_soilHumidity?.last
    }
    
    init(coder aDecoder:NSCoder!){
        self.timestamp = aDecoder.decodeObject(forKey: "timestamp") as? TimeInterval
        self.finalIdentifier = aDecoder.decodeObject(forKey: "finalIdentifier") as? String
        self.arr_airTemperature = aDecoder.decodeObject(forKey: "arr_airTemperature") as? [CGFloat]
        self.arr_airHumidity = aDecoder.decodeObject(forKey: "arr_airHumidity") as? [CGFloat]
        self.arr_soilTemperatrue = aDecoder.decodeObject(forKey: "arr_soilTemperatrue") as? [CGFloat]
        self.arr_soilHumidity = aDecoder.decodeObject(forKey: "arr_soilHumidity") as? [CGFloat]
        self.arr_CO2 = aDecoder.decodeObject(forKey: "arr_CO2") as? [CGFloat]
        self.arr_Voltage = aDecoder.decodeObject(forKey: "arr_CO2") as? [CGFloat]
        
        self.currentAirTemperature = aDecoder.decodeObject(forKey: "currentAirTemperature") as? CGFloat
        self.currentAirHumidity = aDecoder.decodeObject(forKey: "currentAirHumidity") as? CGFloat
        self.currentSoilTemperature = aDecoder.decodeObject(forKey: "currentSoilTemperature") as? CGFloat
        self.currentSoilHumidity = aDecoder.decodeObject(forKey: "currentSoilHumidity") as? CGFloat
        self.currentCO2 = aDecoder.decodeObject(forKey: "currentCO2") as? CGFloat
        self.currentVoltage = aDecoder.decodeObject(forKey: "currentVoltage") as? CGFloat
   
    }
    
    func encodeWithCoder(_ aCoder:NSCoder!){
        aCoder.encode(timestamp, forKey: "timestamp")
        aCoder.encode(finalIdentifier,forKey:"finalIdentifier")
        aCoder.encode(arr_airTemperature,forKey:"arr_airTemperature")
        aCoder.encode(arr_airHumidity,forKey:"arr_airHumidity")
        aCoder.encode(arr_soilTemperatrue,forKey:"arr_soilTemperatrue")
        aCoder.encode(arr_soilHumidity,forKey:"arr_soilHumidity")
        aCoder.encode(arr_CO2,forKey:"arr_CO2")
        aCoder.encode(arr_Voltage,forKey:"arr_Voltage")
        
        aCoder.encode(currentAirTemperature, forKey: "currentAirTemperature")
        aCoder.encode(currentAirHumidity,forKey:"currentAirHumidity")
        aCoder.encode(currentSoilTemperature,forKey:"currentSoilTemperature")
        aCoder.encode(currentSoilHumidity,forKey:"currentSoilHumidity")
        aCoder.encode(currentCO2,forKey:"currentCO2")
        aCoder.encode(currentVoltage,forKey:"currentVoltage")

    }

    
    func getCurrentAirTemperature()->CGFloat?{
        if arr_airTemperature != nil{
            self.currentAirTemperature = arr_airTemperature?.last
            return currentAirTemperature
        }
        else {
            return nil
        }
    }
    
    func getCurrentAirHumidity()->CGFloat?{
        if arr_airHumidity != nil{
            self.currentAirHumidity = arr_airHumidity?.last
            return currentAirHumidity
        }
        else {
            return nil
        }
    }
    
    func getCurrentSoilTemperature()->CGFloat?{
        if arr_soilTemperatrue != nil{
            self.currentSoilTemperature = arr_soilTemperatrue?.last
            return currentSoilTemperature
        }
        else {
            return nil
        }
    }
    
    func getCurrentSoilHumidity()->CGFloat?{
        if arr_soilHumidity != nil{
            self.currentSoilHumidity = arr_soilHumidity?.last
            return currentSoilHumidity
        }
        else {
            return nil
        }
    }
    
    func getCurrentCO2()->CGFloat?{
        if arr_CO2 != nil{
            self.currentCO2 = arr_CO2?.last
            return currentCO2
        }
        else {
            return nil
        }
    }
    
    func getCurrentVoltage()->CGFloat?{
        if arr_Voltage != nil{
            self.currentVoltage = arr_Voltage?.last
            return currentVoltage
        }
        else {
            return nil
        }
    }
    
}
