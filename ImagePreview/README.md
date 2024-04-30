# image-preview

## 简介

image-preview 提供图片预览组件，支持旋转，缩放和平移，提供一些自定义属性

## 下载安装

`ohpm install @rv/image-preview`

## 权限

无需权限

## 属性列表

| 属性名         | 类型            | 必须              | 默认值     | 描述          |
|-------------|---------------|-----------------|---------|-------------|
| `option`    | ImagePreViewOption | 是               | null    | 配置选项，集体如下介绍 |
| `indicator` | DotIndicator \| DigitIndicator \| boolean | 否           | true | [见官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-swiper-0000001862607461#ZH-CN_TOPIC_0000001862607461__indicator10) |

## ImagePreViewOption

### 构造函数

```ts
constructor(images: ImageType[])
其中:
type ImageType = PixelMap | ResourceStr | DrawableDescriptor
```

### 接口说明

1. 设置背景色
   ```typescript
   setBackgroundColor(bgColor: ResourceColor)
   ```

2. 设置展示页

   ```typescript
   setShowIndex(showIndex: number)
   ```

3. 设置缓存数量

   ```ts
   setCachedCount(cachedCount: number)
   ```

4. 设置长按事件

   ```ts
   setLongPressListener(event: () => void)
   ```

5. 允许缩放

   ```ts
   setZoomEnabled(zoomEnabled: boolean)
   ```

6. 是否允许拖拽

   ```ts
   setPanEnabled(panEnabled: boolean)
   ```

7. 最大缩放比

   ```ts
   setMaxScale(maxScale: number)
   ```

8. 最小缩放比

   ```TS
   setMinScale(minScale: number)
   ```

## 使用示例

```typescript
import { ImagePreView, ImagePreViewOption } from '@rv/image-preview/Index'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ImagePreViewPage {
  @State images: ResourceStr[] = [
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
  ]
  @State imagePreViewOption: ImagePreViewOption = new ImagePreViewOption(this.images)

  aboutToAppear(): void {
    this.imagePreViewOption.setLongPressListener(() => {
      promptAction.showToast({ message: "1111" })
    })
    this.imagePreViewOption.setZoomEnabled(false)
    this.imagePreViewOption.setMinScale(0.1)
    this.imagePreViewOption.setShowIndex(2)
    this.imagePreViewOption.setBackgroundColor(Color.White)
  }
  build() {
    Column() {
      ImagePreView({ option: this.imagePreViewOption })
    }.width("100%")
    .height("100%")
  }
}
```

效果如下：
![](image/Screenshot_2024-04-30T221110.png)
![](image/Screenshot_2024-04-30T221245.png)
