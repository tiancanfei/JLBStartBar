# JLBStartBar
评星
### 评星控件，根据评星的分数显示评星，可以正常显示3.1，3.5，3.8等评分

#### 自定义评分规则
```
protocol JLBStartBarDelegate
{
    /// 计算星数
    ///
    /// - Parameters:
    ///   - count: 整数位
    ///   - half: 小数位
    func score(count:NSInteger,half:NSInteger)
}
```

#### 获取评分 直接从score属性获取
```
let score = scoreBar.score
```

#### 设置评分 直接设置score属性，支持xib设置
```
scoreBar.score = 3.4
```
#### 设置灰色星星图片 直接设置grayStartImage属性，支持xib设置
```
scoreBar.grayStartImage = UIImage.init(named: "xxx")
```
#### 设置点亮星星图片 直接设置grayStartImage属性，支持xib设置
```
scoreBar.highLightedStartImage = UIImage.init(named: "xxx")
```
#### 设置点亮星星大小 直接设置startSize属性，支持xib设置
```
scoreBar.startSize = CGSize(width: 21, height: 21)
```
#### 设置点亮星星之间的间距 直接设置padding属性，支持xib设置
```
scoreBar.padding = 5
```


