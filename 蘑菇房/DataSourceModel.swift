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
    
    fileprivate var currentAirTemperature: CGFloat?
    fileprivate var currentAirHumidity: CGFloat?
    fileprivate var currentSoilTemperature: CGFloat?
    fileprivate var currentSoilHumidity: CGFloat?
    
    var arr_CO2: [CGFloat]?
    fileprivate var currentCO2: CGFloat?
    
    var arr_Voltage: [CGFloat]?
    fileprivate var currentVoltage: CGFloat?
    
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
