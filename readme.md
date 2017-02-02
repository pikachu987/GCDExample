
## GCD(Grand Centeral Dispatch)

### 큐(Queue)

mainQueue, globalQueue, new DispatchQueue 가 있다.

메인큐, 글로벌큐, 내가만든 새로운큐라고 하며

~~~~
//메인큐
DispatchQueue.main

//글로벌큐
DispatchQueue.global()

//내가만든큐
DispatchQueue(label: "myQueue")
~~~~

이런식으로 만들 수 있다.

1. 화면 UI를 변경시키려면 main큐에서 해야 한다.
2. 큐를 중첩시킬 수 있다.(큐 안의 큐 안의 큐  이런식)

<br><br>

### 동기/비동기(sync, async)

sync 동기, async 비동기가 있으며

~~~~
//동기
DispatchQueue.global().sync
DispatchQueue.main.sync
DispatchQueue(label: "myQueue").sync


//비동기
DispatchQueue.global().async
DispatchQueue.main.async
DispatchQueue(label: "myQueue").async
~~~~

이런식으로 만들 수 있다.

1. sync를 하게 되면 앱이 sync 동작 끝날때 까지 얼어있는 상황이 발생한다.
2. DispatchQueue.main.sync는 교착상태에 빠지기 쉽다.
	* sync(동기) Queue 안에 main.sync가 있으면 교착상태에 빠져 에러가 난다.
	* 그럴때는 main.async를 쓰던가 async(비동기) Queue를 먼저 쓰고 main.sync를 쓰면 된다.

<br><br>

### DispatchQoS(Quality of service)

userInteractive

userInitiated

default

utility

background

unspecified


위에 있는것 부터 우선순위가 높다.

~~~~
DispatchQueue(label: "myQueue", qos: DispatchQoS.userInteractive)
~~~~

이런식으로 사용한다.


~~~~
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
~~~~

이렇게 하면 직렬(serial) 처리가 된다.


~~~~
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
~~~~

.concurrent 옵션을 넣으면 병렬(concurrent)처리가 된다.


``initiallyInactive`` 옵션을 넣으면 트리거 ``queue.activate()`` 를 해야 실행이 된다.



### DispatchGroup

DispatchGroup()로 그룹을 만들 수 있다.

몇개의 큐를 그룹으로 만들게 되면 그룹에 속해있는 큐들이 끝날때 까지 기다리는 ``wait(timeout: .distantFuture)`` 이나 끝나고 난 후 호출되는 ``notify``를 사용 할 수 있다.

~~~~~
//그룹을 만들고
let group = DispatchGroup()
group.enter()
DispatchQueue.global().async{
      //작업
      group.leave()
}
group.enter()
DispatchQueue.global().async{
      //작업
      group.leave()
}
group.enter()
DispatchQueue.global().async{
      //작업
      group.leave()
}
group.enter()
DispatchQueue.global().async{
      //작업
      group.leave()
}
group.notify(queue: DispatchQueue.global()) {
      //notify는 그룹이 끝난 다음 호출됨(비동기 방식)
      print("그룹이 끝남")
}
// _ = group.wait(timeout: .distantFuture)
// wait는 그룹이 끝날때 까지 기다림(동기 방식)
~~~~~

이런식으로 사용가능하다.


### WorkItem

~~~~
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
~~~~

이런식으로 사용가능하다.

실행하면

~~~~
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
~~~~

이런식으로 콘솔창에 출력이 된다.

``perform``을 실행 시킨 다음 WorkItem이 실행되고 ``cancel``로 취소를 시킨다. 

그리고 ``wait``로 딜레이를 줄 수 있다.


### Semaphore

~~~~
let semaphore = DispatchSemaphore(value: 0)
URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: self.imageUrl
)!) { (data, response, error) in
    print("data load")
    semaphore.signal()
}.resume()
semaphore.wait()
print("data load after")
~~~~

원래 콘솔창에 data load after이 먼저 나와야 하지만 세마포어로 data load after이란 글자가 나중에 나오게 된다.

``signal``이 나오기 전까지 ``wait``에서 기다리는 중이다.