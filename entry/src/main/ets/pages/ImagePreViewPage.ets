import { ImagePreView, ImagePreViewOption } from '@rv/image-preview/Index'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct ImagePreViewPage {
  images: ResourceStr[] = router.getParams() as ResourceStr[]
  @State imagePreViewOption: ImagePreViewOption | null = null

  aboutToAppear(): void {
    this.imagePreViewOption = new ImagePreViewOption(this.images)
    this.imagePreViewOption.setLongPressListener((_,index) => {
      promptAction.showToast({ message: index.toString()})
    })
    this.imagePreViewOption.setOnClickListener((_,index) => {
      promptAction.showToast({ message: index.toString() })
    })
    // this.imagePreViewOption.setRotateEnable(false)
    this.imagePreViewOption.setMinScale(0.1)
    this.imagePreViewOption.setShowIndex(1)
    this.imagePreViewOption.setBackgroundColor(Color.White)
    // this.imagePreViewOption.setZoomEnabled(false)
  }

  build() {
    Column() {
      ImagePreView({ option: this.imagePreViewOption as ImagePreViewOption })
    }.width("100%")
    .height("100%")
  }
}