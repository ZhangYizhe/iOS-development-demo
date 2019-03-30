## XMind 主要功能模拟

#### 节点之间线型链接

节点关系维护使用结构体构造每个节点的特征，使用树结构实现

```swift
// MARK:- 节点结构体
    struct node {
        var type : String // 节点属性
        var location : [Int] // 当前节点位置
        var parent : [node] // 父节点
        var childrens : [node] // 子节点
        var line : CAShapeLayer // 子到父线
        var view : UILabel? // label实例
    }
```

#### 新增与删除节点

长按节点即可新增或删除节点

