import UIKit


/// MARK: - 简单初始化

//let queue = DispatchQueue(label: "com.queue")

/// MARK: - 属性指明初始化队列

//let label = "com.queue"
//let qos = DispatchQoS.default // quality of service 队列质量

/*
    .userInteractive
    用户交互 优先级最高 计算拖拽等操作
    .default
    默认
    .unspecified
    未指定
    .userInitiated
    用户启动 需要立刻知道结果
    .utility
    公共 长时间执行再通知用户 如下载文件
    .background
    后台 用于在后台存储数据等
*/


//let attributes = DispatchQueue.Attributes.concurrent // 队列属性 默认串行 .concurrent 并行 .initiallyInactive 需手动触发
//let autoreleaseFrequency = DispatchQueue.AutoreleaseFrequency.never //自动释放频率
//
//
//let queue = DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: nil)

/// MARK: - 队列

//  系统队列
//let mainQueue = DispatchQueue.main
//let globalQueue = DispatchQueue.global()
//let globalQueueWithQos = DispatchQueue.global(qos: .userInitiated)

// 串行队列
//let serialQueue = DispatchQueue(label: "com.serialQueue")

// 并行队列
//let concurrentQueue = DispatchQueue(label: "com.concurrentQueue", attributes: .concurrent)

// 创建并行队列并手动触发
//let concurrentInitiallyInactiveQueue = DispatchQueue(label: "com.concurrentInitiallyInactiveQueue", attributes: [.concurrent, .initiallyInactive])

// 手动触发
//concurrentInitiallyInactiveQueue.activate()

/// MARK: - 挂起与继续

//concurrentQueue.resume() // 挂起 占用资源不释放
//concurrentQueue.suspend() // 继续

/// MARK: - QoS指定方式

// 创建时制定
//let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .background)
//backgroundQueue.async {
//
//}

// 提交block时指定
//let queue = DispatchQueue(label: "backgroundQueue")
//queue.async(qos: .background) {
//
//}

/// MARK: - DispatchGroup 管理一组任务执行 并监听任务是否完成

// 普通方式
//let group = DispatchGroup()
//
//let queueA = DispatchQueue(label: "queueA")
//print("start task queueA")
//queueA.async(group: group) {
//    sleep(2)
//    print("end task queueA")
//}
//let queueB = DispatchQueue(label: "queueB")
//print("start task queueB")
//queueB.async(group: group) {
//    sleep(1)
//    print("end task queueB")
//}
//group.notify(queue: DispatchQueue.main) {
//    print("all task done")
//}

/// MARK: -Group.enter / Group.leave

// 延时任务
///
/// - Parameters:
///   - label: 任务标题
///   - cost: 延时
///   - complete: 回调
//func task(label: String, cost: UInt32, complete:@escaping ()->()){
//    print("start task \(label)")
//    DispatchQueue.global().async {
//        sleep(cost)
//        DispatchQueue.main.async {
//            complete()
//        }
//    }
//}
//
//print("Group Created")
//let group = DispatchGroup()
//group.enter()
//task(label: "1", cost: 2) {
//    group.leave()
//}
//group.enter()
//task(label: "2", cost: 2) {
//    group.leave()
//}

//group.wait(timeout: .now() + .seconds(4)) //阻塞当前线程

//group.notify(queue: .main) {
//    print("all task is done")
//}

/// MARK: - 封装为对象

//let item = DispatchWorkItem {
//    print(123)
//}

// 可在初始化时指定更多参数
//let item2 = DispatchWorkItem(qos: .userInitiated, flags: [.enforceQoS,.assignCurrentContext]) {
//    print(456)
//}

//DispatchQueue.global().async(execute: item2)

/// MARK: - 延迟执行
// DispatchTime 纳秒级操作
//let deadline = DispatchTime.now() + 2.0
//print("start")
//DispatchQueue.global().asyncAfter(deadline: deadline) {
//    print("End")
//}
// DispatchWallTime 微妙级操作
//let walltime = DispatchWallTime(). + 2.0
//print("start")
//DispatchQueue.global().asyncAfter(deadline: walltime) {
//    print("End")
//}

/// MARK: - 线程同步

// NSLock 互斥锁
//let lock = NSLock()
//lock.lock()
// 操作
//lock.unlock()

//sync 同步函数
//class SomeData {
//    private var privateData : Int = 0
//    private let dataQueue = DispatchQueue(label: "com.dataQueue")
//    var data : Int {
//        get {
//            return dataQueue.sync { privateData }
//        }
//        set {
//            dataQueue.sync { privateData = newValue }
//        }
//    }
//}
//
//let someData = SomeData()
//let lock = NSLock() // 设置互斥锁
//let group = DispatchGroup() // 设置组
//for i in 0...10 {
//    group.enter() // 进组
//    DispatchQueue.global().async {
//        lock.lock() //锁住线程准备数据操作
//        someData.data = someData.data + 1 // 数据操作
//        lock.unlock() // 释放锁
//        group.leave() //退组
//    }
//}
//group.notify(queue: .main) { //线程结束后通知
//    print(someData.data)
//}

/// MARK: - Barrier 线程阻断
// barrier提交后，会等待在它之前的全部任务完成后执行，且等待它完成后才会执行后面的任务

//let concurrentQueue = DispatchQueue(label: "com.concurrent", attributes: .concurrent)
//concurrentQueue.async {
//    sleep(2)
//    print(1)
//}
//concurrentQueue.async {
//    sleep(2)
//    print(2)
//}
//concurrentQueue.async(flags: .barrier) {
//    print("start")
//    print(3)
//    print("end")
//    sleep(2)
//}
//concurrentQueue.async() {
//    print(4)
//}

/// MARK: - Semaphore 信号量
// 控制同时开启线程数量
public func task(label: String, cost: UInt32, complete: @escaping ()->()) {
    print("start task\(label)")
    sleep(cost)
    print("end task\(label)")
    complete()
}

let semaphore = DispatchSemaphore(value: 2) //设置总量为2
let queue = DispatchQueue(label: "com.concurrentqueue", qos: .default, attributes: .concurrent)

queue.async {
    semaphore.wait() // 开启
    task(label: "1", cost: 2, complete: {
        semaphore.signal() //结束
    })
}

queue.async {
    semaphore.wait()
    task(label: "2", cost: 2, complete: {
        semaphore.signal()
    })
}

queue.async {
    semaphore.wait()
    task(label: "3", cost: 2, complete: {
        semaphore.signal()
    })
}

