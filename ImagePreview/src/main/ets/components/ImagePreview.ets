import { ImageType } from "../utils/common"
import { ImagePreviewController } from "../utils/ImagePreviewController"
import { ImageItem } from "./ImageItem"

@Component
export struct ImagePreview {
  controller: ImagePreviewController = new ImagePreviewController()

  aboutToAppear(): void {
    this.controller.currentPage = this.controller.initialIndex
    this.controller.currentScrollPage = this.controller.initialIndex
  }

  build() {
    Stack() {
      Stack()
        .width("100%")
        .height("100%")
        .backgroundColor(this.controller.bgColor)
        .opacity(this.controller.bgOpacity)
      List({ scroller: this.controller.listScroller, initialIndex: this.controller.initialIndex }) {
        LazyForEach(this.controller.imagesData, (image: ImageType, index: number) => {
          ImageItem({
            image: image,
            index: index,
            currentPage: this.controller.currentPage,
            controller: this.controller
          })
        }, (image: ImageType, index: number) => `${image}${index}`)
      }
      .cachedCount(this.controller.cachedCount)
      .edgeEffect(EdgeEffect.None)
      .enableScrollInteraction(false)
      .friction(100)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .scrollSnapAlign(ScrollSnapAlign.CENTER)
      .width("100%")
      .height("100%")
      .onScrollIndex((start: number, end: number, center: number) => {
        this.controller.onWillFlip?.(this.controller.currentScrollPage, center)
        this.controller.currentScrollPage = center
      })
      .onScrollStop(() => {
        this.controller.onFlip?.(this.controller.currentPage, this.controller.currentScrollPage)
        this.controller.currentPage = this.controller.currentScrollPage
      })
    }
    .width("100%")
    .height("100%")
  }
}
