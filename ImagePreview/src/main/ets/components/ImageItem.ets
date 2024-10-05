import { ImageType } from "../utils/common"
import { ImageAnimUtil } from "../utils/ImageAnimUtil"
import { ImagePreviewController } from "../utils/ImagePreviewController"
import { ImageItemViewModel } from "../viewmodel/ImageItemViewModel"

@Component
export struct ImageItem {
  private readonly viewModel: ImageItemViewModel = new ImageItemViewModel()
  @Prop @Require image: ImageType
  @Prop @Watch('reset') currentPage: number
  index: number = 0
  controller?: ImagePreviewController

  aboutToAppear(): void {
    this.viewModel.max_scale_ratio = this.controller?.maxScale ?? ImageItemViewModel.DEFAULT_MAX_SCALE_RATIO
  }

  build() {
    Stack() {
      Image(this.image)
        .scale({
          x: this.viewModel.scaleRatioDown,
          y: this.viewModel.scaleRatioDown,
          centerX: this.viewModel.centerXDown,
          centerY: 0
        })
        .offset({ x: this.viewModel.offsetX, y: this.viewModel.offsetY })
        .objectFit(ImageFit.Contain)
        .onComplete(event => {
          this.viewModel.imageWidth = px2vp(event?.width as number)
          this.viewModel.imageHeight = px2vp(event?.height as number)
        })
        .onSizeChange((_: SizeOptions, newValue: SizeOptions) => {
          this.viewModel.imgComponentHeight = newValue.height as number
          this.viewModel.imgComponentWidth = newValue.width as number
        })
        .aspectRatio(this.viewModel.imageRatio)
        .geometryTransition(this.controller?.transitionIdGenerator?.(this.image, this.index))
        .sharedTransition(this.controller?.transitionIdGenerator?.(this.image, this.index), { duration: 300 })
        .width("100%")
    }
    .scale({
      x: this.viewModel.scaleRatio,
      y: this.viewModel.scaleRatio,
      centerX: this.viewModel.centerX,
      centerY: this.viewModel.centerY
    })
    .onSizeChange((_: SizeOptions, newValue: SizeOptions) => {
      this.viewModel.previewHeight = newValue.height as number
      this.viewModel.previewWidth = newValue.width as number
    })
    .width("100%")
    .height("100%")
    .gesture(GestureGroup(GestureMode.Exclusive,
      // 长按事件
      LongPressGesture()
        .onAction((event: GestureEvent) => {
          ImageAnimUtil.stop()
          this.controller?.onLongPress?.(event, this.index)
        }),
      // 双击事件
      TapGesture({ fingers: 1, count: 2 })
        .onAction((event: GestureEvent) => {
          ImageAnimUtil.stop()
          // 双击时，通过动画展示缩放效果
          const finger = event.fingerList[0]
          this.viewModel.refreshCenter(finger.localX, finger.localY)

          if (this.viewModel.scaleRatio === ImageItemViewModel.MIN_SCALE_RATIO) {
            this.viewModel.refreshScaleAnim(this.viewModel.max_scale_ratio)
          } else {
            this.viewModel.refreshScaleAndOffsetAnim(ImageItemViewModel.MIN_SCALE_RATIO)
          }
        }),
      // 单击事件
      TapGesture({ fingers: 1, count: 1 })
        .onAction((event: GestureEvent) => {
          ImageAnimUtil.stop()
          this.controller?.onClick?.(event, this.index)
        }),
      // 缩放手势
      PinchGesture({ fingers: 2 })
        .onActionStart((event: GestureEvent) => {
          ImageAnimUtil.stop()
          // 手势开始时，记录上一次缩放比例，并设置缩放中心点
          this.viewModel.preScaleRatio = this.viewModel.scaleRatio
          this.viewModel.refreshCenter(event.pinchCenterX, event.pinchCenterY)
        })
        .onActionUpdate((event: GestureEvent) => {
          // 不通过设置合法的缩放比例设置，在手势结束后通过动画展示回弹效果
          this.viewModel.scaleRatio = this.viewModel.preScaleRatio * event.scale
        })
        .onActionEnd((event: GestureEvent) => {
          // 手势结束时，通过动画展示回弹效果
          this.viewModel.refreshScaleAndOffsetAnim()
        }),
      // 拖动手势
      PanGesture()
        .onActionStart((event: GestureEvent) => {
          ImageAnimUtil.stop()
          // 手势开始时，记录上一次偏移量
          this.viewModel.flipDistance = 0
          this.viewModel.preOffsetX = this.viewModel.offsetX
          this.viewModel.preOffsetY = this.viewModel.offsetY
        })
        .onActionUpdate((event: GestureEvent) => {
          // 设置位移
          this.viewModel.refreshOffset(this.viewModel.preOffsetX + event.offsetX,
            this.viewModel.preOffsetY + event.offsetY)
          // 拖拽翻页
          this.dragFlip(event.offsetX)
          // 识别到下拉手势
          this.pullDown(event)
        })
        .onActionEnd((event: GestureEvent) => {
          // 拖拽惯性滚动
          this.viewModel.refreshOffsetAnim(this.viewModel.offsetX + event.velocityX,
            this.viewModel.offsetY + event.velocityY)
          // 惯性翻页
          this.inertiaFlip(event.velocityX)
          // 下拉手势结束
          this.pullDownEnd(event)
        })
    ))
  }

  // 拖动翻页
  private dragFlip(offsetX: number) {
    if (!this.viewModel.isHorizontalBoundary) {
      return
    }
    this.controller?.listScroller?.scrollBy((this.viewModel.flipDistance - offsetX) * this.viewModel.scaleRatio, 0)
    this.viewModel.flipDistance = offsetX
  }

  // 惯性翻页
  private inertiaFlip(velocityX: number) {
    if ((this.viewModel.isLeftBoundary && velocityX < 0) || (this.viewModel.isRightBoundary && velocityX > 0)) {
      this.controller?.listScroller?.fling(velocityX * this.viewModel.scaleRatio)
    }
  }

  // 下拉手势（持续调用）
  private pullDown(event: GestureEvent) {
    if (this.controller?.onPullDown
      && this.viewModel.scaleRatio === ImageItemViewModel.MIN_SCALE_RATIO
      && this.viewModel.isTopBoundary
      && event.offsetY > Math.abs(event.offsetX)
      && event.offsetY > 0) {
      this.viewModel.offsetX = this.viewModel.preOffsetX + event.offsetX
      this.viewModel.offsetY = this.viewModel.preOffsetY + event.offsetY
      this.viewModel.refreshCenterXDown((event.offsetX + this.viewModel.previewWidth / 2)
        / this.viewModel.previewWidth)
      const scaleRatioDown = 1 - event.offsetY / this.viewModel.previewHeight
      this.viewModel.scaleRatioDown = scaleRatioDown
      this.controller?.setBgOpacity(scaleRatioDown)
    }
  }

  // 下拉手势结束
  private pullDownEnd(event: GestureEvent) {
    if (this.controller?.onPullDown
      && this.viewModel.scaleRatio === ImageItemViewModel.MIN_SCALE_RATIO
      && this.viewModel.isTopBoundary
      && event.offsetY > 0) {
      if (this.viewModel.scaleRatioDown <= 0.75) {
        this.controller?.onPullDown?.(event, this.index)
      }
      this.viewModel.offsetX = this.viewModel.preOffsetX
      this.viewModel.offsetY = this.viewModel.preOffsetY
      this.viewModel.refreshCenterXDown(0.5)
      this.viewModel.scaleRatioDown = 1
      this.controller?.setBgOpacity(1)
    }
  }

  // 重置
  private reset() {
    this.viewModel.reset()
  }
}