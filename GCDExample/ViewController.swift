//
//  ViewController.swift
//  GCDTest
//
//  Created by guanho on 2017. 2. 1..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let image = UIImage(named: "img.png")
    let imageUrl = "https://s3-us-west-1.amazonaws.com/powr/defaults/image-slider2.jpg"
    var time: Double = 0
    var timer: Timer?
    
    let array = [
        [
            "0. none queue(큐 없이)",
            "1. mainQueue async(비동기)",
            "2. globalQueue async(비동기)",
            "3. globalQueue sync(동기)",
            "4. mainQueue asyncAfter(비동기)",
            "5. globalQueue asyncAfter(비동기)",
            "6. new DispatchQueue async(비동기)",
            "7. new DispatchQueue sync(동기)"
        ],[
            "0. queue order",
            "1. queue qos",
            "2. queue qos order",
            "3. queue qos serial",
            "4. queue qos attribute concurrent",
            "5. queue qos attribute initiallyInactive",
            "6. queue qos attribute concurrent"
        ],[
            "0. group",
            "1. workItem",
            "2. semaphore"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAction("" as Any)
    }
    
    @IBAction func initAction(_ sender: Any) {
        self.lbl.text = "0"
        self.img.image = self.image
        self.time = 0
        self.timer?.invalidate()
    }
}




extension ViewController: UITableViewDelegate{
    
}
extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.array.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "mainQueue, globalQueue, async, sync 차이"
        }else if section == 1{
            return "queue qos, order"
        }else if section == 2{
            return "queue 기타(group, workItme, semaphore)"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell") as? ExampleCell
        let row = self.array[indexPath.section][indexPath.row]
        cell?.btn.setTitle(row, for: .normal)
        cell?.delegate = self
        return cell!
    }
}

extension ViewController: ExampleDelegate{
    func exampleAction(_ cell: ExampleCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else{
            return
        }
        if indexPath.section == 0{
            if indexPath.row == 0{
                self.queueTest0_0()
            }else if indexPath.row == 1{
                self.queueTest0_1()
            }else if indexPath.row == 2{
                self.queueTest0_2()
            }else if indexPath.row == 3{
                self.queueTest0_3()
            }else if indexPath.row == 4{
                self.queueTest0_4()
            }else if indexPath.row == 5{
                self.queueTest0_5()
            }else if indexPath.row == 6{
                self.queueTest0_6()
            }else if indexPath.row == 7{
                self.queueTest0_7()
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                self.queueTest1_0()
            }else if indexPath.row == 1{
                self.queueTest1_1()
            }else if indexPath.row == 2{
                self.queueTest1_2()
            }else if indexPath.row == 3{
                self.queueTest1_3()
            }else if indexPath.row == 4{
                self.queueTest1_4()
            }else if indexPath.row == 5{
                self.queueTest1_5()
            }else if indexPath.row == 6{
                self.queueTest1_6()
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                self.queueTest2_0()
            }else if indexPath.row == 1{
                self.queueTest2_1()
            }else if indexPath.row == 2{
                self.queueTest2_2()
            }
        }
    }
}

extension Double {
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let round = (self*divisor).rounded()
        return round / divisor
    }
}
