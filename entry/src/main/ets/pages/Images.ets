import { ImagePreview, ImagePreviewController, ImageType } from '@rv/image-preview'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Images {
  images: ImageType[] = []
  private controller: ImagePreviewController = new ImagePreviewController()

  aboutToAppear(): void {

    const param:ESObject = router.getParams()
    this.images = param['images']

    this.controller
      .setImage(this.images)
      .setBgColor(Color.Pink)
      .setParser((image: ImageType, index: number) => {
        return image
      })
      .setMaxScale(2)
      .setInitialIndex(param['index'])
      .setCachedCount(1)
      .setOnClick((event: GestureEvent, index: number) => {
        console.log(`点击：${index}`)
      })// 点击
      .setOnLongPress((event: GestureEvent, index: number) => {
        console.log(`长按：${index}`)
      })// 长按
      .setOnWillFlip((currentPage: number, center: number) => {
        console.log(`滚动中，从 ${currentPage} 去往 ${center}`)
      })// 即将翻页
      .setOnFlip((currentPage: number, center: number) => {
        console.log(`滚动结束，从 ${currentPage} 去往 ${center}`)
      })// 翻页
  }

  build() {
    Column() {
      Button("颜色")
        .onClick(() => {
          this.controller.setBgColor(Color.Blue)
        })
      Button("添加")
        .onClick(() => {
          this.controller.addImage($r('app.media.img'))
        })
      Button("删除")
        .onClick(() => {
          this.controller.removeImage(0)
        })
      Button("翻页")
        .onClick(() => {
          this.controller.showNext()
        })
      Button("上一页")
        .onClick(() => {
          this.controller.showPrevious()
        })
      ImagePreview({ controller: this.controller })
    }
    .height('100%')
    .width('100%')
  }
}