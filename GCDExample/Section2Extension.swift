//
//  Section2Extension.swift
//  GCDExample
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

extension ViewController{
    func queueTest1_0(){
        /**
         test1 sync -> nomal -> async : sync 끝난 후 nomal 끝난 후 async 실행
         test2 sync -> async -> nomal : sync 끝난 후 async 와 nomal 동시 실행
         test3 nomal -> sync -> async : nomal 끝난 후 sync 끝난 후 async 실행
         test4 nomal -> async -> sync : nomal 끝난 후 async 끝난 후 sync 실행
         test5 async -> nomal -> sync : async 와 nomal 동시 실행 후 sync 실행
         test6 async -> sync -> nomal : async 끝난 후 sync 끝난 후 nomal 실행
         
         여기서 유추해볼 꺼는 async(비동기)밑에 nomal이 있으면 동시 실행이 된다.
         나머지는 순서대로..
         **/
        print("----queueTest1_0----")
        let queue = DispatchQueue(label: "myQueue")
        queue.async {
            for i in 0...4{
                print("async \(i)")
            }
        }
        queue.sync {
            for i in 0...4{
                print("sync \(i)")
            }
        }
        for i in 0...4{
            print("nomal \(i)")
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
            print("\r\n\r\n\r\n")
        }
    }
    
    
    /**
     DispatchQoS(Quality of service)는
     userInteractive
     userInitiated
     default
     utility
     background
     unspecified
     가 있습니다.
     우선순위가 높은것 부터 차례대로 나열되어 있습니다.
     **/
    func queueTest1_1(){
        //같은 순위이면 동시에 실행됩니다.
        print("----queueTest1_1----")
        let queue1 = DispatchQueue(label: "myQueue1", qos: DispatchQoS.userInteractive)
        let queue2 = DispatchQueue(label: "myQueue2", qos: DispatchQoS.userInteractive)
        queue1.async {
            for i in 0...4{
                print("userInteractive: first \(i)")
            }
        }
        queue2.async {
            for i in 0...4{
                print("userInteractive: second \(i)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
            print("\r\n\r\n\r\n")
        }
    }
    
    func queueTest1_2(){
        //순서가 뒤죽박죽입니다. (.background가 대체적으로 뒤쪽에서 나옵니다.)
        let queue1 = DispatchQueue(label: "myQueue1", qos: DispatchQoS.userInteractive)
        let queue2 = DispatchQueue(label: "myQueue2", qos: DispatchQoS.userInitiated)
        let queue3 = DispatchQueue(label: "myQueue3", qos: DispatchQoS.default)
        let queue4 = DispatchQueue(label: "myQueue4", qos: DispatchQoS.utility)
        let queue5 = DispatchQueue(label: "myQueue5", qos: DispatchQoS.background)
        let queue6 = DispatchQueue(label: "myQueue6", qos: DispatchQoS.unspecified)
        print("----queueTest1_2----")
        queue1.async {
            for i in 0...4{
                print("userInteractive: \(i)")
            }
        }
        queue2.async {
            for i in 0...4{
                print("userInitiated: \(i)")
            }
        }
        queue3.async {
            for i in 0...4{
                print("default: \(i)")
            }
        }
        queue4.async {
            for i in 0...4{
                print("utility: \(i)")
            }
        }
        queue5.async {
            for i in 0...4{
                print("background: \(i)")
            }
        }
        queue6.async {
            for i in 0...4{
                print("unspecified: \(i)")
            }
        }
        for i in 0...4{
            print("nomal: \(i)")
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
            print("\r\n\r\n\r\n")
        }
    }
    
    func queueTest1_3(){
        //serial(직렬처리)이 됩니다.
        print("----queueTest1_3----")
        let queue = DispatchQueue(label: "myQueue", qos: DispatchQoS.userInteractive)
        queue.async {
            for i in 0...4{
                print("first: \(i)")
            }
        }
        queue.async {
            for i in 0...4{
                print("second: \(i)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
            print("\r\n\r\n\r\n")
        }
    }
    
    func queueTest1_4(){
        //attributes에 concurrent(병렬처리)를 넣습니다.
        print("----queueTest1_4----")
        let queue = DispatchQueue(label: "myQueue", qos: DispatchQoS.userInteractive, attributes: .concurrent)
        queue.async {
            for i in 0...4{
                print("first: \(i)")
            }
        }
        queue.async {
            for i in 0...4{
                print("second: \(i)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
            print("\r\n\r\n\r\n")
        }
    }
    
    func queueTest1_5(){
        //attributes에 initiallyInactive를 넣습니다. 트리거를 해야 실행이 됩니다.
        print("----queueTest1_5----")
        let queue = DispatchQueue(label: "myQueue", qos: DispatchQoS.userInteractive, attributes: .initiallyInactive)
        queue.async {
            for i in 0...4{
                print("first: \(i)")
            }
        }
        queue.async {
            for i in 0...4{
                print("second: \(i)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.3) {
            queue.activate()
            DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
                print("\r\n\r\n\r\n")
            }
        }
    }
    
    func queueTest1_6(){
        //attributes에 concurrent(병렬처리), initiallyInactive를 넣습니다.
        print("----queueTest1_6----")
        let queue = DispatchQueue(label: "myQueue", qos: DispatchQoS.userInteractive, attributes: [.concurrent, .initiallyInactive])
        queue.async {
            for i in 0...4{
                print("first: \(i)")
            }
        }
        queue.async {
            for i in 0...4{
                print("second: \(i)")
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.3) {
            queue.activate()
            DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
                print("\r\n\r\n\r\n")
            }
        }
    }
}
