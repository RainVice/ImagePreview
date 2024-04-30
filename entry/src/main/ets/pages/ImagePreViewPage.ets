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
    this.imagePreViewOption.setRotateEnable(false)
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