//
//  ChooseAreaModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class ChooseAreaModel{
    
    func getAreaString(_ index:Int)->String?{
        var chosenArea :String?
        switch index{
            case 0:chosenArea = "西乡塘区"
            case 1:chosenArea = "兴宁区"
            case 2:chosenArea = "青秀区"
            case 3:chosenArea = "江南区"
            case 4:chosenArea = "邕宁区"
            case 5:chosenArea = "良庆区"
            case 6:chosenArea = "武鸣区"
            case 7:chosenArea = "横县"
            case 8:chosenArea = "隆安县"
            case 9:chosenArea = "马山县"
            case 10:chosenArea = "上林县"
            case 11:chosenArea = "宾阳县"
            default:chosenArea = nil
        }
        return chosenArea
    }
}
