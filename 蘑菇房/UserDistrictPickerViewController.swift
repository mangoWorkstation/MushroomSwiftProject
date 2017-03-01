//
//  UserDistrictPickerViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/19.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class UserDistrictPickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
//    @IBOutlet weak var province: UILabel!
//    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var pick: UIPickerView!
    
//    var dic : Dictionary<String,[String]> = ["请选择省份":["请选择城市"],"北京市":["北京市"],
//                                             "上海市":["上海市"],
//                                             "天津市":["天津市"],
//                                             "重庆市":["重庆市"],
//                                             "河北省":["石家庄市","唐山市","秦皇岛市","邯郸市","邢台市","保定市","张家口市","承德市","沧州市","廊坊市","衡水市"],
//                                             "山西省":["太原市","大同市","朔州市","阳泉市","长治市","晋城市","忻州市","晋中市","临汾市","运城市","吕梁市"],
//                                             "陕西省":["西安市","铜川市","宝鸡市","咸阳市","渭南市","延安市","汉中市","榆林市","安康市","商洛市"],
//                                             "山东省":["济南市","青岛市","淄博市","枣庄市","东营市","烟台市","潍坊市","济宁市","泰安市","威海市","日照市","莱芜市","临沂市","德州市","聊城市","滨州市","菏泽市"],
//                                             "河南省":["郑州市","开封市","洛阳市","平顶山市","安阳市","鹤壁市","新乡市","焦作市","濮阳市","许昌市","漯河市","三门峡市","南阳市","商丘市","信阳市","周口市","驻马店市"],
//                                             "辽宁省":["沈阳市","大连市","鞍山市","抚顺市","本溪市","丹东市","锦州市","营口市","阜新市","辽阳市","盘锦市","铁岭市","朝阳市","葫芦岛市"],
//                                             "吉林省":["长春市","吉林市","四平市","辽源市","通化市","白山市","松原市","白城市","延边朝鲜族自治州"],
//                                             "黑龙江省":["哈尔滨市","齐齐哈尔市","鹤岗市","双鸭山市","鸡西市","大庆市","伊春市","牡丹江市","佳木斯市","七台河市","黑河市","绥化市"],
//                                             "江苏省":["南京市","无锡市","徐州市","常州市","苏州市","南通市","连云港市","淮安市","盐城市","扬州市","镇江市","泰州市","宿迁市"],
//                                             "浙江省":["杭州市","宁波市","温州市","嘉兴市","湖州市","绍兴市","金华市","衢州市","舟山市","台州市","丽水市"],
//                                             "安徽省":["合肥市","芜湖市","蚌埠市","淮南市","马鞍山市","淮北市","铜陵市","安庆市","黄山市","滁州市","阜阳市","宿州市","巢湖市","六安市","亳州市","池州市","宣城市"],
//                                             "江西省":["南昌市","景德镇市","萍乡市","九江市","新余市","鹰潭市","赣州市","吉安市","宜春市","抚州市","上饶市"],
//                                             "福建省":["福州市","厦门市","莆田市","三明市","泉州市","漳州市","南平市","龙岩市","宁德市"],
//                                             "湖北省":["武汉市","黄石市","十堰市","荆州市","宜昌市","襄樊市","鄂州市","荆门市","孝感市","黄冈市","咸宁市","随州市"],
//                                             "湖南省":["长沙市","株洲市","湘潭市","衡阳市","邵阳市","岳阳市","常德市","张家界市","益阳市","郴州市","永州市","怀化市","娄底市"],
//                                             "四川省":["成都市","自贡市","攀枝花市","泸州市","德阳市","绵阳市","广元市","遂宁市","内江市","乐山市","南充市","眉山市","宜宾市","广安市","达州市","雅安市","巴中市","资阳市"],
//                                             "贵州省":["贵阳市","六盘水市","遵义市","安顺市"],
//                                             "云南省":["昆明市","曲靖市","玉溪市","保山市","昭通市","丽江市","普洱市","临沧市"],
//                                             "广东省":["广州市","深圳市","珠海市","汕头市","韶关市","佛山市","江门市","湛江市","茂名市","肇庆市","惠州市","梅州市","汕尾市","河源市","阳江市","清远市","东莞市","中山市","潮州市","揭阳市","云浮市"],
//                                             "海南省":["海口市","三亚市"],
//                                             "甘肃省":["兰州市","金昌市","白银市","天水市","嘉峪关市","武威市","张掖市","平凉市","酒泉市","庆阳市","定西市","陇南市"],
//                                             "青海省":["西宁市"],
//                                             "台湾省":["台北市","高雄市","基隆市","台中市","台南市","新竹市","嘉义市"],
//                                             "内蒙古自治区":["呼和浩特市","包头市","乌海市","赤峰市","通辽市","鄂尔多斯市","呼伦贝尔市","巴彦淖尔市","乌兰察布市"],
//                                             "新疆维吾尔自治区":["乌鲁木齐市","克拉玛依市"],
//                                             "西藏自治区":["拉萨市"],
//                                             "广西壮族自治区":["南宁市","柳州市","桂林市","梧州市","北海市","防城港市","钦州市","贵港市","玉林市","百色市","贺州市","河池市","来宾市","崇左市"],
//                                             "宁夏回族自治区":["银川市","石嘴山市","吴忠市","固原市","中卫市"]
//        
//        
//    ]
//    
//    let provinces = ["请选择省份","北京市","上海市","天津市","重庆市","河北省","山西省","陕西省","山东省","河南省","辽宁省","吉林省","黑龙江省","江苏省","浙江省","安徽省","江西省","福建省","湖北省","湖南省","四川省","贵州省","云南省","广东省","海南省","甘肃省","青海省","台湾省","内蒙古自治区","新疆维吾尔自治区","西藏自治区","广西壮族自治区","宁夏回族自治区"]
    
    var dic : Dictionary<String,[String]> = [:]
    
    var provinces : [String] = []
    
    
    var currentProvince:String! = "请选择省份"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pick.delegate = self
        pick.dataSource = self
        
        let filePath_1 = Bundle.main.url(forResource: "provinces", withExtension: "plist")
        let content_1 = NSArray(contentsOf: filePath_1!)
        provinces = content_1 as! [String]
        
        let filePath_2 = Bundle.main.url(forResource: "provinces_dic", withExtension: "plist")
        let content_2 = NSDictionary(contentsOf: filePath_2!)
        dic = content_2 as! Dictionary<String, [String]>
        
//        province.text = "省份"
//        province.font = UIFont(name: GLOBAL_appFont!, size: 20)
//        province.textAlignment = .center
//        city.text = "城市"
//        city.font = UIFont(name: GLOBAL_appFont!, size: 20)
//        city.textAlignment = .center
        
        try?FileManager.default.removeItem(at: URL(string: NSHomeDirectory() + "/Documents/provinces.plist")!)
        try?FileManager.default.removeItem(at: URL(string: NSHomeDirectory() + "/Documents/provinces_dic.plist")!)

//        let filePath_provinces:String = NSHomeDirectory() + "/Documents/provinces.plist"
//        NSArray(array: provinces).write(toFile: filePath_provinces, atomically: true)
//        print(filePath_provinces)
//        
//        let filePath_provinces_dic:String = NSHomeDirectory() + "/Documents/provinces_dic.plist"
//        NSDictionary(dictionary: dic).write(toFile: filePath_provinces_dic, atomically: true)
//        print(filePath_provinces_dic)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0{
            return self.provinces.count
        }
        else{
            let row = pickerView.selectedRow(inComponent: 0)
            self.currentProvince = provinces[row]
            return (self.dic[currentProvince]?.count)!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if component == 0{
            self.currentProvince = self.provinces[row]
            pickerView.reloadComponent(1)
            return self.provinces[row]
        }
        else{
            let province = self.currentProvince
            return self.dic[province!]?[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            self.currentProvince = self.provinces[row]
            GLOBAL_UserProfile.province = provinces[row]
            pickerView.reloadComponent(1)
            
        }
        let _row = pickerView.selectedRow(inComponent: 1)
        let city = self.dic[currentProvince]?[_row]
        GLOBAL_UserProfile.city = city
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 170
        }
        else {
            return 130
        }
    }
    
    
    
    
}
