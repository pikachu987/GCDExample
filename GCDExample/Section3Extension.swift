//
//  Section3Extension.swift
//  GCDExample
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

extension ViewController{
    func queueTest2_0(){
        //메인큐는 그룹이 있을 시에 그룹 끝난 후 실행이 됩니다.
        /**
         1 그룹 시작합니다.
         2 그룹 시작합니다.
         1번 글로벌큐(1그룹, 2그룹) 쓰레드 주기 전입니다.
         2번 글로벌큐(1그룹) asyncAfter 쓰레드 주기 전입니다.
         1번 글로벌큐(1그룹, 2그룹) 쓰레드 준 후입니다.
         2번 글로벌큐(1그룹) asyncAfter 쓰레드 준 후입니다.
         1그룹 다 끝났습니다.(동기)
         1그룹 다 끝났습니다.(비동기)
         3번 글로벌큐(2그룹) asyncAfter 쓰레드 주기 전입니다.
         3번 글로벌큐(2그룹) asyncAfter 쓰레드 준 후입니다.
         2그룹 다 끝났습니다.(비동기)
         2그룹 다 끝났습니다.(동기)
         1번 메인 큐입니다.
         2번 메인 큐 쓰레드 주기 전입니다.
         2번 메인 큐 쓰레드 준 후입니다.
         **/
        DispatchQueue.main.async{
            print("1번 메인 큐입니다.")
        }
        print("1 그룹 시작합니다.")
        let group1 = DispatchGroup()
        print("2 그룹 시작합니다.")
        let group2 = DispatchGroup()
        
        let global = DispatchQueue.global()
        
        group1.enter()
        group2.enter()
        DispatchQueue.global().async{
            print("1번 글로벌큐(1그룹, 2그룹) 쓰레드 주기 전입니다.")
            Thread.sleep(forTimeInterval: 0.3)
            print("1번 글로벌큐(1그룹, 2그룹) 쓰레드 준 후입니다.")
            group1.leave()
            group2.leave()
        }
        
        DispatchQueue.main.async{
            print("2번 메인 큐 쓰레드 주기 전입니다.")
            Thread.sleep(forTimeInterval: 1)
            print("2번 메인 큐 쓰레드 준 후입니다.")
        }
        
        group1.enter()
        //이런식으로도 사용 가능합니다.
        global.async(group: group1){
            print("2번 글로벌큐(1그룹) asyncAfter 쓰레드 주기 전입니다.")
            Thread.sleep(forTimeInterval: 0.5)
            print("2번 글로벌큐(1그룹) asyncAfter 쓰레드 준 후입니다.")
            group1.leave()
        }
        
        group1.notify(queue: DispatchQueue.global()) {
            print("1그룹 다 끝났습니다.(비동기)")
        }
        _ = group1.wait(timeout: .distantFuture)
        print("1그룹 다 끝났습니다.(동기)")
        
        group2.enter()
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5){
            print("3번 글로벌큐(2그룹) asyncAfter 쓰레드 주기 전입니다.")
            Thread.sleep(forTimeInterval: 0.5)
            print("3번 글로벌큐(2그룹) asyncAfter 쓰레드 준 후입니다.")
            group2.leave()
        }
        
        group2.notify(queue: DispatchQueue.global()) {
            print("2그룹 다 끝났습니다.(비동기)")
        }
        _ = group2.wait(timeout: .distantFuture)
        print("2그룹 다 끝났습니다.(동기)")
    }
    
    
    
    func queueTest2_1(){
        /**
         workItem perform
         workItem start
         workItem working 0.0
         workItem working 0.1
         workItem working 0.2
         workItem working 0.3
         workItem working 0.4
         workItem working 0.5
         workItem cancel
         workItem notify!!!
         workItem wait
         **/
        var workItem: DispatchWorkItem?
        var timer = 0.0
        workItem = DispatchWorkItem {
            print("workItem start")
            while(!workItem!.isCancelled){
                print("workItem working \(timer)")
                Thread.sleep(forTimeInterval: 0.1)
                timer += 0.1
            }
        }
        workItem?.notify(queue: DispatchQueue.main) {
            print("workItem notify!!!")
        }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .milliseconds(10)) {
            print("workItem perform")
            workItem?.perform()
        }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(1) + .milliseconds(10)) {
            print("workItem wait")
            workItem?.wait()
        }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(1)) {
            print("workItem cancel")
            workItem?.cancel()
        }
    }
    
    
    
    func queueTest2_2(){
        /**
         data load
         data load after
         **/
        let semaphore = DispatchSemaphore(value: 0)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: self.imageUrl
        )!) { (data, response, error) in
            print("data load")
            semaphore.signal()
            DispatchQueue.main.async {
                self.img.image = UIImage(data: data!)
            }
        }.resume()
        semaphore.wait()
        print("data load after")
    }
}
