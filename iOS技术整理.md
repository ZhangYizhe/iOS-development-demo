## runtime 

1、动态方法交换

```swift
func ChangeMethod() -> Void {
	// 获取交换之前的方法
	let originaMethodC = class_getInstanceMethod(object_getClass(self),#selector(self.originaMethod))
	// 获取交换之后的方法
	let swizzeMethodC  = class_getInstanceMethod(object_getClass(self),#selector(self.swizzeMethod))
	//替换类中已有方法的实现,如果该方法不存在添加该方法
	//获取方法的Type字符串(包含参数类型和返回值类型)
	//class_replaceMethod(object_getClass(self), #selector(self.swizzeMethod), method_getImplementation(originaMethodC), method_getTypeEncoding(originaMethodC))
         
	print("你交换两个方法的实现")
	method_exchangeImplementations(originaMethodC, swizzeMethodC)
}
  
dynamic func originaMethod() -> Void {
	print("我是交换之前的方法")
}
        
dynamic func swizzeMethod() -> Void {
	print("我是交换之后的方法")
}
```

2、类增加新属性

```swift
    // 改进写法【推荐】
    struct RuntimeKey {
        static let jkKey = UnsafeRawPointer.init(bitPattern: "JKKey".hashValue)
        /// ...其他Key声明
    }
    
    var jkPro: String? {
        set {
            objc_setAssociatedObject(self, ViewController.RuntimeKey.jkKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return  objc_getAssociatedObject(self, ViewController.RuntimeKey.jkKey) as? String
        }
    }
```



3、获取类详细属性

```swift
var count: UInt32  = 0
let ivars = class_copyIvarList(UITextField.self, &count)
for i in 0 ..< count {
	let ivar = ivars![Int(i)]
	let name = ivar_getName(ivar)
	print(String(cString: name!))
}
free(ivars)
```

4、解决同一方法高频调用问题

5、动态方法解析与消息转发

6、动态操作属性

## runloop 

##### Run Loop特点

1、当有事件发⽣时,Run Loop会根据具体的事件类型通知应⽤程序做出响应 
2、当没有事件发生时,Run Loop会进⼊休眠状态,从⽽达到省电的⽬的 
3、当事件再次发生时,Run Loop会被重新唤醒,处理事件

##### 主线程和其他线程中的Run Loop 

1、iOS程序的主线程默认已经配置好了Run Loop

2、其他线程默认情况下没有设置Run Loop

## KVC、KVO及通知 

KVC、KVO Swift中使用KVC和KVO的类都必须必须继承自NSObject

#### KVC：对系统UI控件隐藏的属性进行操作，方便开发

##### 获取隐藏属性的方法有两种

1、可以通过runtime打印出所有的隐藏属性。
2、也可以用打断点的方式，在调试区查看UI控件的隐藏属性

###### 使用方法：forKeyPath

#### KVO： 当被观察者的对象的属性被修改的时候，会通知观察者，KVC是KVO的基础

```swift
		// WKWebView监听title (webView初始化的地方监听)
		webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)

		// 监听title的回调
		override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
			if (keyPath == "title") {
				self.addTitle(titleString: self.webView.title!)
			}
		}
    
    deinit { // 必须在页面销毁的时候，remove
        webView.removeObserver(self, forKeyPath: "title")
    }
```

#### 通知：需要被观察者主动发送通知，然后观察者注册监听，比KVO多了发送通知的一步。优点是：监听不局限属性的变化，可以对多种多样的状态变化进行监听，范围广，灵活。

```swift
	//观察者
	//通知名称常量
	let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyChatMsgRecv")
	//发送通知
	NotificationCenter.default.post(name:NotifyChatMsgRecv, object: 0)

	//接收通知
	let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyChatMsgRecv")
NotificationCenter.default.addObserver(self,selector:#selector(didMsgRecv(notification:)),name: NotifyChatMsgRecv, object: nil)

	//子页面的反馈通知响应方法
	//通知处理函数
	func didMsgRecv(notification:NSNotification){
	
	}

	//销毁观察者
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

```
## delegate 委托代理

委托（delegate）是Cocoa的一个术语，表示将一个对象的部分功能转交给另一个对象。

比如对象A希望对象B知道将要发生或已经发生某件事情，对象A可以把对象B的引用存为一个实例变量。这个对象B称为委托。当事件发生时，它检查委托对象是否实现了与该事件相适应的方法。如果已经实现，则调用该方法。

## 闭包 

闭包就是能够读取其他函数内部变量的函数

```swift
{(parameters) -> return type in
   statements
}
```

```swift
// MARK:- 变量闭包
var varBlock : (String) -> Int = { result in
    print(result)
    return 456
}

print(varBlock("传入参数"))

// MARK:- 函数闭包
func FuncBlock(completion: (String) -> Void) {
    completion("返回值")
}

// 语法糖
FuncBlock { (result) in
    print(result)
}

// 标准方法
FuncBlock (completion: { (result) in
    print(result)
})
```

#### 自动闭包

```swift
var array : [Int] = [1,2,3,4,5,6]
print(array.count)
print(array.sorted(by: {
    $0 > $1
}))
```

#### 逃逸闭包与非逃逸闭包

```
@escaping @noescaping
```

在以下的两种情况，我们需要使用 escaping closure：

1. 异步execution，并不能说函数return了就把closure kill掉，因为这个closure可能还没有执行完毕
2. 存储，如果任何全局变量都有一些些存储存在，那么这个closure也被逃逸掉了。

## 单例 

应用单例模式的一个类只有一个实例。即一个类只有一个对象实例。UIApplication.sharedApplication()就是单例

```swift
// 静态化实现单例
class SingleOne {
    static let shareSingleOne = SingleOne()
    private init() { } //隐藏初始化方法避免不小心被实例化
}

// 全局变量
let shareSingleTwo = SingleTwo()
class SingleTwo {
    fileprivate init() { } //文件方法私有化
}
```

## try catch throws 机制 

```swift
enum ErrorType: Error {
    case error1
    case error2
}

func Map(completion: (Int) -> Void) throws -> Int {
    switch value {
    case 1:
        return value
    default:
        throw ErrorType.error2
    }
}

do {
    try Map(value: 2)
} catch ErrorType.error1 {
    print(123)
} catch {
    print(456)
}
```

## 多线程 

#### 初始化

简单初始化

```swift
let queue = DispatchQueue(label: "com.queue")
```

属性指明初始化

```
let queueDetail = DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: nil)
```

#### QoS指定方式

```swift
.userInteractive //用户交互 优先级最高 计算拖拽等操作
.default //默认
.unspecified //未指定
.userInitiated //用户启动 需要立刻知道结果
.utility //公共 长时间执行再通知用户 如下载文件
.background //后台 用于在后台存储数据等
```

#### 队列

##### 系统队列

串型队列 `DispatchQueue.main`

并行队列 `DispatchQueue.global()`、 ` DispatchQueue.global(qos: DispatchQoS.QoSClass)`

##### 自定义队列

串型队列 `DispatchQueue(label: String)`

并行队列 `DispatchQueue(label: String, qos: DispatchQoS, attributes: DispatchQueue.Attributes, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency, target: DispatchQueue)`

```swift
// 创建并行队列并手动触发
let concurrentInitiallyInactiveQueue = DispatchQueue(label: "com.concurrentInitiallyInactiveQueue", attributes: [.concurrent, .initiallyInactive])

// 手动触发
concurrentInitiallyInactiveQueue.activate()
```

#### 手动触发

当attributes中包含了`.initiallyInactive`时候需手动触发

`.activate()`

#### 封装为对象

```swift
/// MARK: - 封装为对象

let item = DispatchWorkItem {
    print(123)
}

// 可在初始化时指定更多参数
let item = DispatchWorkItem(qos: .userInitiated, flags: [.enforceQoS,.assignCurrentContext]) {
    print(456)
}

DispatchQueue.global().async(execute: item)
```

#### 组管理

```swift
// 普通方式
// .async(group: DispatchGroup)

let group = DispatchGroup()

let queueA = DispatchQueue(label: "queueA")
print("start task queueA")
queueA.async(group: group) {
    sleep(2)
    print("end task queueA")
}
let queueB = DispatchQueue(label: "queueB")
print("start task queueB")
queueB.async(group: group) {
    sleep(1)
    print("end task queueB")
}
group.notify(queue: .main) {
    print("all task done")
}

// Group.enter / Group.leave 方式

let group = DispatchGroup()
group.enter()
task(label: "1", cost: 2) {
    group.leave()
}
group.enter()
task(label: "2", cost: 2) {
    group.leave()
}

group.wait(timeout: .now() + .seconds(4)) //阻塞当前线程

group.notify(queue: .main) {
    print("all task is done")
}
```

#### 线程挂起与继续

```swift
/// MARK: - 挂起与继续
let concurrentQueue = DispatchQueue(label: "com.queue")
concurrentQueue.resume() // 挂起 占用资源不释放
concurrentQueue.suspend() // 继续
```

#### 线程同步

##### 锁

```
// NSLock 互斥锁
let lock = NSLock()
lock.lock()
// 操作
lock.unlock()
```

##### 线程同步

```swift
class SomeData {
    private var privateData : Int = 0
    private let dataQueue = DispatchQueue(label: "com.dataQueue")
    var data : Int {
        get {
            return dataQueue.sync { privateData }
        }
        set {
            dataQueue.sync { privateData = newValue }
        }
    }
}

let someData = SomeData()
let lock = NSLock() // 设置互斥锁
let group = DispatchGroup() // 设置组
for i in 0...10 {
    group.enter() // 进组
    DispatchQueue.global().async {
        lock.lock() //锁住线程准备数据操作
        someData.data = someData.data + 1 // 数据操作
        lock.unlock() // 释放锁
        group.leave() //退组
    }
}
group.notify(queue: .main) { //线程结束后通知
    print(someData.data)
}
```

#### 延迟执行

```swift
/// MARK: - 延迟执行
// DispatchTime 纳秒级操作
let deadline = DispatchTime.now() + 2.0
print("start")
DispatchQueue.global().asyncAfter(deadline: deadline) {
    print("End")
}
// DispatchWallTime 微妙级操作
let walltime = DispatchWallTime() + 2.0
print("start")
DispatchQueue.global().asyncAfter(deadline: walltime) {
    print("End")
}
```

#### Semaphore 信号量

```swift
/// MARK: - Semaphore 信号量
// 控制同时开启线程数量

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

public func task(label: String, cost: UInt32, complete: @escaping ()->()) {
    print("start task\(label)")
    sleep(cost)
    print("end task\(label)")
    complete()
}
```

