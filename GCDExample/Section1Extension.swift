//
//  Section1Extension.swift
//  GCDExample
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

extension ViewController{
    func imageConvert(_ image: UIImage){
        self.img.image = image
        self.timer?.invalidate()
        self.time = 0
        print("3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.\r\n\r\n\r\n")
    }
    
    func infinityLbl(){
        print("1. timer 함수 시작합니다.")
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            timeInterval: 1/6,
            target: self,
            selector: #selector(self.timerStart),
            userInfo: nil,
            repeats: true
        )
    }
    func timerStart(){
        self.time += 0.1
        print("- time: \(self.time.roundToPlaces(places: 1))")
        self.lbl.text = "\(self.time.roundToPlaces(places: 1))"
    }
}


extension ViewController{
    func queueTest0_0(){
        /**
         1.timer 함수 시작합니다.
         2. queueTest1 이미지를 불러옵니다.
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         Timer.scheduledTimer 가 작동하지 않습니다.
         이미지불러오기 전까지는 다른 액션이 작동하지 않습니다.
         **/
        self.infinityLbl()
        print("2. queueTest1 이미지를 불러옵니다.")
        guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
            self.timer?.invalidate()
            return
        }
        self.imageConvert(image)
    }
    
    func queueTest0_1(){
        /**
         1. timer 함수 시작합니다.
         2. queueTest2 이미지를 불러옵니다.
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         Timer.scheduledTimer 가 작동하지 않습니다.
         이미지불러오기 전까지는 다른 액션이 작동하지 않습니다.
         **/
        self.infinityLbl()
        DispatchQueue.main.async {
            print("2. queueTest2 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            self.imageConvert(image)
        }
    }
    
    func queueTest0_2(){
        /**
         1. timer 함수 시작합니다.
         2. queueTest3 이미지를 불러옵니다.
         - time: 0.1
         - time: 0.2
         - time: 0.3
         - time: 0.4
         - time: 0.5
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         **/
        self.infinityLbl()
        DispatchQueue.global().async {
            print("2. queueTest3 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            DispatchQueue.main.async {
                self.imageConvert(image)
            }
        }
    }
    
    func queueTest0_3(){
        /**
         1. timer 함수 시작합니다.
         2. queueTest4 이미지를 불러옵니다.
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         Timer.scheduledTimer 가 작동하지 않습니다.
         이미지불러오기 전까지는 다른 액션이 작동하지 않습니다.
         **/
        self.infinityLbl()
        DispatchQueue.global().sync {
            print("2. queueTest4 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            //globalQueue에서 sync(동기)를 써서 mainQueue에서 sync(동기)를 쓰면 교착상태에 빠져서 에러
            DispatchQueue.main.async {
                self.imageConvert(image)
            }
        }
    }
    
    func queueTest0_4(){
        /**
         1. timer 함수 시작합니다.
         - time: 0.1
         - time: 0.2
         - time: 0.3
         2. queueTest5 이미지를 불러옵니다.
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         현재호출된시간 + 0.5초 후에 작동합니다.
         0.5초 전에는 다른 액션이 작동하지만 0.5초 후에는 다른 액션이 작동하지 않습니다.
         Timer.scheduledTimer 가 0.5초 후에는 작동하지 않습니다.
         **/
        self.infinityLbl()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("2. queueTest5 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            self.imageConvert(image)
        }
    }
    
    func queueTest0_5(){
        /**
         1. timer 함수 시작합니다.
         - time: 0.1
         - time: 0.2
         - time: 0.3
         2. queueTest6 이미지를 불러옵니다.
         - time: 0.4
         - time: 0.5
         - time: 0.6
         - time: 0.7
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         **/
        self.infinityLbl()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            print("2. queueTest6 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            DispatchQueue.main.async {
                self.imageConvert(image)
            }
        }
    }
    
    func queueTest0_6(){
        /**
         1. timer 함수 시작합니다.
         2. queueTest8 이미지를 불러옵니다.
         - time: 0.1
         - time: 0.2
         - time: 0.3
         - time: 0.4
         - time: 0.5
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         **/
        self.infinityLbl()
        let queue = DispatchQueue(label: "myQueue")
        queue.async {
            print("2. queueTest8 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            DispatchQueue.main.async {
                self.imageConvert(image)
            }
        }
    }
    
    
    func queueTest0_7(){
        /**
         1. timer 함수 시작합니다.
         2. queueTest8 이미지를 불러옵니다.
         3. queueTest 이미지 가져오기 완료 이미지를 변경합니다.
         Timer.scheduledTimer 가 작동하지 않습니다.
         이미지불러오기 전까지는 다른 액션이 작동하지 않습니다.
         **/
        self.infinityLbl()
        let queue = DispatchQueue(label: "myQueue")
        queue.sync {
            print("2. queueTest8 이미지를 불러옵니다.")
            guard let url = URL(string: self.imageUrl), let data = NSData(contentsOf: url) as? Data, let image = UIImage(data: data) else{
                self.timer?.invalidate()
                return
            }
            //내가만든 Queue에서 sync(동기)를 써서 mainQueue에서 sync(동기)를 쓰면 교착상태에 빠져서 에러
            DispatchQueue.main.async {
                self.imageConvert(image)
            }
        }
    }
}
