import { Adapter, ImagePreViewOption, ImageType } from './common'
import { ImageItem } from './ImageItem'
import { router } from '@kit.ArkUI'

@Component
export struct ImagePreView {

  @ObjectLink option: ImagePreViewOption
  indicator: DotIndicator | DigitIndicator | boolean = true

  build() {
    Column() {
      if (this.option.getImages()) {
        Swiper() {
          LazyForEach(new Adapter(this.option.getImages()), (item: ImageType, index: number) => {
            ImageItem({
              image: item,
              zoomEnabled: this.option.getZoomEnabled(),
              panEnabled: this.option.getPanEnabled(),
              rotateEnable: this.option.getRotateEnable(),
              maxScale: this.option.getMaxScale(),
              minScale: this.option.getMinScale(),
              sharedId: this.option.getId()
            })
              .gesture(
                LongPressGesture().onAction(this.option.getLongPressListener())
              )
              .onClick(() => {
                router.back()
              })
          })
        }
        .indicator(this.indicator)
        .index(this.option.getShowIndex())
        .cachedCount(this.option.getCachedCount())
        .width("100%")
        .height("100%")
      }
    }
    .backgroundColor(this.option.getBackgroundColor())
    .width("100%")
    .width("100%")
  }
}


