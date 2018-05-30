# ScannerView

-带扫条码功能的View 可自己创建View视图大小

## 安装
-直接把ScannerView.swift拖入工程

## 使用
init方法创建，frame设置大小
``` swift
let scannerView = ScannerView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 100))
``` 

- 设置开始扫描
``` swift
scannerView.startRunning()
```

- 结束扫描
``` swift
scannerView.stopRunning()
```

- 获取扫描结果使用代理ScannerViewDelegate
- 实现result方法

``` swift
func result(_ result: String?) {
    print(result)
}
```


