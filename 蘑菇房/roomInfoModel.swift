//
//  roomInfoModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/18.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
class roomInfoModel {
    var district : Int{
        get{
            return self.district 
        }
        set{
            self.district = newValue
        }
    }
    var imageIdentifier : String{
        get{
            return self.imageIdentifier
        }
        set{
            self.imageIdentifier = newValue
        }
    }
    var name : String{
        get{
            return self.name
        }
        set{
            self.name = newValue
        }
    }
    
    init(district:Int,imageIdentifier:String,name:String){
        self.district = district
        self.imageIdentifier = imageIdentifier
        self.name = name
    }
    
}