import {
  ImageType,
  ImgClickCallback,
  ImgFlipCallback,
  ImgLongPressCallback,
  ImgParserCallBack,
  ImgPullDownCallback,
  TransitionIdGeneratorCallback
} from "./common";
import { ImageDataSource } from "./ImageDataSource";
import { util } from "@kit.ArkTS";

@ObservedV2
export class ImagePreviewController {
  private readonly _imagesData: ImageDataSource = new ImageDataSource()

  get imagesData(): ImageDataSource {
    return this._imagesData
  }

  private readonly _listScroller: ListScroller = new ListScroller()

  get listScroller(): ListScroller {
    return this._listScroller
  }

  // 背景色
  @Trace bgColor: ResourceColor = Color.Transparent
  // 透明度
  @Trace bgOpacity: number = 1
  // 缓存数量
  @Trace cachedCount: number = 3
  // 当前页码
  @Trace currentPage: number = 0
  // 展示第几页
  initialIndex: number = 0
  // 滚动过程中处于哪一页
  currentScrollPage: number = 0;
  // 最大缩放比例
  maxScale: number = 5
  // 长按事件
  onLongPress?: ImgLongPressCallback
  // 单击事件
  onClick?: ImgClickCallback
  // 下拉事件
  onPullDown?: ImgPullDownCallback
  // 翻页完成事件
  onFlip?: ImgFlipCallback
  // 即将翻页事件
  onWillFlip?: ImgFlipCallback
  // 共享元素专场id生成策略
  transitionIdGenerator?: TransitionIdGeneratorCallback =(image: ImageType, index: number) => `${image.toString()}${index}`

  /**
   * 设置图片数据
   * @param images ImageType[]
   * @returns
   */
  setImage(images: ImageType[]) {
    this._imagesData?.setData(images)
    return this
  }

  /**
   * 添加图片
   * @param image
   * @returns
   */
  addImage(image: ImageType) {
    this._imagesData?.addData(image)
  }

  /**
   * 移除图片
   * @param index number
   * @returns
   */
  removeImage(index: number) {
    this._imagesData?.removeData(index)
  }


  /**
   * 显示下一页
   */
  showNext() {
    this._listScroller?.scrollPage({ next: true })
  }

  /**
   * 显示上一页
   */
  showPrevious() {
    this._listScroller?.scrollPage({ next: false })
  }

  /**
   * 设置图片解析（组要用于用于网络图片自定义请求数据）
   * @param callback
   * @returns
   */
  setParser(callback: ImgParserCallBack) {
    this._imagesData.imgParser = callback
    return this
  }

  /**
   * 设置背景颜色（默认为透明，接入状态管理）
   * @param color ResourceColor
   * @returns
   */
  setBgColor(color: ResourceColor) {
    this.bgColor = color
    return this
  }

  /**
   * 设置背景透明度（不想外提供，设置无效,默认为1，接入状态管理）
   * @param opacity number
   * @returns
   */
  setBgOpacity(opacity: number) {
    this.bgOpacity = opacity
    return this
  }

  /**
   * 设置初始状态下展示第几页
   * @param index number
   * @returns
   */
  setInitialIndex(index: number) {
    this.initialIndex = index
    return this
  }

  /**
   * 设置缓存数量 (接入状态管理)
   * @param count number
   * @returns
   */
  setCachedCount(count: number) {
    this.cachedCount = count
    return this
  }

  /**
   * 设置最大缩放比例
   * @param maxScale
   * @returns
   */
  setMaxScale(maxScale: number) {
    this.maxScale = maxScale
    return this
  }

  /**
   * 设置长按事件
   * @param callback ImgLongPressCallback
   * @returns
   */
  setOnLongPress(callback: ImgLongPressCallback) {
    this.onLongPress = callback
    return this
  }

  /**
   * 设置单击事件
   * @param callback ImgClickCallback
   * @returns
   */
  setOnClick(callback: ImgClickCallback) {
    this.onClick = callback
    return this
  }

  /**
   * 设置下拉事件（设置后预览器将会出现下拉效果）
   * @param callback ImgPullDownCallback
   * @returns
   */
  setOnPullDown(callback: ImgPullDownCallback) {
    this.onPullDown = callback
    return this
  }

  /**
   * 设置翻页事件（翻页完成时回调）
   * @param callback ImgFlipCallback
   * @returns
   */
  setOnFlip(callback: ImgFlipCallback) {
    this.onFlip = callback
    return this
  }

  /**
   * 设置即将翻页事件（翻页前调用，会在拖拽过程中持续调用，可以作为预测即将翻页的回调）
   * @param callback ImgFlipCallback
   * @returns
   */
  setOnWillFlip(callback: ImgFlipCallback) {
    this.onWillFlip = callback
    return this
  }

  /**
   * 设置共享元素专场id生成策略
   * @param callback TransitionIdGeneratorCallback
   * @returns
   */
  setTransitionIdGenerator(callback: TransitionIdGeneratorCallback) {
    this.transitionIdGenerator = callback
    return this
  }
}