import { DigitalIndicatorStyle, DotIndicatorStyle, IndicatorStyle, IndicatorType } from "../model/IndicatorStyle"
import { CustomIndicatorBuilder, ImageType, IndicatorItemBuilder } from "../utils/common"
import { ImagePreviewController } from "../utils/ImagePreviewController"
import { ImagePreviewViewModel } from "../viewmodel/ImagePreviewViewModel"
import { ImageItem } from "./ImageItem"

@Component
export struct ImagePreview {
  controller: ImagePreviewController = new ImagePreviewController()
  viewModel: ImagePreviewViewModel = new ImagePreviewViewModel(this.controller)
  @BuilderParam dotActiveBuilder?: IndicatorItemBuilder
  @BuilderParam dotInactiveBuilder?: IndicatorItemBuilder
  @BuilderParam customIndicatorBuilder?: CustomIndicatorBuilder

  aboutToAppear(): void {
    // 初始化当前页
    this.viewModel.currentPage = this.controller.initialIndex
    this.viewModel.currentScrollPage = this.controller.initialIndex

    // 初始化指示器样式
    this.initIndicator()
  }

  /**
   * 初始化指示器样式
   */
  private initIndicator() {
    const tmpIndicator = this.controller.indicatorStyle?.customIndicatorBuilder
    // 自定义指示器
    if (tmpIndicator) {
      this.customIndicatorBuilder = tmpIndicator
    }
    // 设置自定义圆点指示器样式
    else if (this.controller.indicatorType === IndicatorType.DOT) {
      const tmpIndicator = this.controller.indicatorStyle as DotIndicatorStyle
      this.dotActiveBuilder = tmpIndicator.customActiveBuilder
      this.dotInactiveBuilder = tmpIndicator.customInactiveBuilder
    }
  }

  build() {
    RelativeContainer() {
      Stack()
        .width("100%")
        .height("100%")
        .backgroundColor(this.controller.bgColor)
        .opacity(this.viewModel.bgOpacity)
        .alignRules({
          middle: { anchor: "__container__", align: HorizontalAlign.Center },
          center: { anchor: "__container__", align: VerticalAlign.Center }
        })
      List({ scroller: this.controller.listScroller, initialIndex: this.controller.initialIndex }) {
        LazyForEach(this.controller.imagesData, (image: ImageType, index: number) => {
          ImageItem({
            image: image,
            index: index,
            currentPage: this.viewModel.currentPage,
            currentScrollPage: this.viewModel.currentScrollPage,
            controller: this.controller,
            previewViewModel: this.viewModel
          })
        }, (image: ImageType, index: number) => `${image}${index}`)
      }
      .cachedCount(this.controller.cachedCount)
      .edgeEffect(EdgeEffect.Fade)
      .enableScrollInteraction(false)
      .friction(100)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .scrollSnapAlign(ScrollSnapAlign.CENTER)
      .width("100%")
      .height("100%")
      .onScrollIndex((start: number, end: number, center: number) => {
        // 调用即将翻页回调
        this.controller.onWillFlip?.(this.viewModel.currentScrollPage, center)
        // 设置滚动页
        this.viewModel.currentScrollPage = center
      })
      .onScrollStop(() => {
        // 调用翻页回调
        this.controller.onFlip?.(this.viewModel.currentPage, this.viewModel.currentScrollPage)
        const tmpPage = this.viewModel.currentScrollPage
        // 设置当前页
        this.viewModel.currentPage = tmpPage
        // 设置指示器滚动
        this.viewModel.indicatorScroll.scrollToIndex(tmpPage, true, ScrollAlign.CENTER)
      })
      .alignRules({
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      })

      this.indicator(this.controller.indicatorStyle)
    }
    .width("100%")
    .height("100%")
  }

  @Builder
  private indicator($$?: IndicatorStyle) {
    if (this.customIndicatorBuilder) {
      Stack() {
        this.customIndicatorBuilder({
          currentPage: this.viewModel.currentScrollPage,
          totalCount: this.controller.imagesData.totalCount()
        })
      }
      .alignRules(ImagePreviewViewModel.INDICATOR_DEFAULT_ALIGN_RULES)
      .margin($$?.margin ?? ImagePreviewViewModel.INDICATOR_DEFAULT_MARGIN)
    } else if (this.controller.indicatorType === IndicatorType.DIGITAL) {
      // 数字指示器
      this.digIndicator($$ as DigitalIndicatorStyle)
    } else if (this.controller.indicatorType === IndicatorType.DOT) {
      // 圆点指示器
      this.dotIndicator($$ as DotIndicatorStyle)
    }
  }

  /**
   * 数字指示器
   * @param $$
   */
  @Builder
  private digIndicator($$?: DigitalIndicatorStyle) {
    Text($$?.text ?? `${this.viewModel.currentScrollPage + 1}/${this.controller.imagesData.totalCount()}`)
      .fontSize($$?.fontSize ?? undefined)
      .fontColor($$?.fontColor ?? Color.White)
      .fontWeight($$?.fontWeight)
      .fontStyle($$?.fontStyle)
      .alignRules(this.controller.indicatorStyle?.alignRules ?? ImagePreviewViewModel.INDICATOR_DEFAULT_ALIGN_RULES)
      .margin($$?.margin ?? ImagePreviewViewModel.INDICATOR_DEFAULT_MARGIN)
  }

  /**
   * 圆点指示器
   * @param $$
   */
  @Builder
  private dotIndicator($$?: DotIndicatorStyle) {
    List({
      scroller: this.viewModel.indicatorScroll,
      initialIndex: this.controller.initialIndex,
      space: $$?.dotSpace ?? 5
    }) {
      LazyForEach(this.controller.imagesData, (_: ImageType, index: number) => {
        ListItem() {
          Stack() {
            // 选中状态
            Stack() {
              if (this.dotActiveBuilder) {
                this.dotActiveBuilder()
              } else {
                Stack().width($$?.dotWidth ?? 10)
                  .height($$?.dotHeight ?? 10)
                  .borderRadius($$?.dotRadius ?? $$?.dotWidth ?? $$?.dotHeight ?? 10)
                  .backgroundColor($$?.dotActiveColor ?? Color.Orange)
              }
            }.visibility(index === this.viewModel.currentScrollPage ? Visibility.Visible : Visibility.None)

            // 未选中状态
            Stack() {
              if (this.dotInactiveBuilder) {
                this.dotInactiveBuilder()
              } else {
                Stack().width($$?.dotWidth ?? 10)
                  .height($$?.dotHeight ?? 10)
                  .borderRadius($$?.dotRadius ?? $$?.dotWidth ?? $$?.dotHeight ?? 10)
                  .backgroundColor($$?.dotInactiveColor ?? Color.Gray)
              }
            }.visibility(index !== this.viewModel.currentScrollPage ? Visibility.Visible : Visibility.None)
          }
        }.onAreaChange((_, newValue: Area) => this.viewModel.indicatorHeight = newValue.height)
      }, (img: ImageType, index: number) => `${img}${index}`)
    }
    .scrollBar(BarState.Off)
    .scrollSnapAlign(ScrollSnapAlign.CENTER)
    .listDirection(Axis.Horizontal)
    .enableScrollInteraction(false)
    .width($$?.indicatorWidth ?? "30%")
    .height($$?.dotHeight ?? this.viewModel.indicatorHeight)
    .alignRules(this.controller.indicatorStyle?.alignRules ?? ImagePreviewViewModel.INDICATOR_DEFAULT_ALIGN_RULES)
    .margin($$?.margin ?? ImagePreviewViewModel.INDICATOR_DEFAULT_MARGIN)
  }
}
