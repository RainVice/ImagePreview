export type ImageType = PixelMap | ResourceStr | DrawableDescriptor

export class Adapter implements IDataSource {
  private images: ImageType[] = []

  constructor(images: ImageType[]) {
    this.images = images
  }

  totalCount(): number {
    return this.images.length
  }

  getData(index: number): ImageType {
    return this.images[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}


@Observed
export class ImagePreViewOption {
  /**
   * 图片列表
   */
  private images: ImageType[] = []
  /**
   * 背景颜色
   */
  private bgColor: ResourceColor = Color.Black
  /**
   * 显示第几张
   */
  private showIndex: number = 0
  /**
   * 缓存几张
   */
  private cachedCount: number = 1
  /**
   * 设置最小缩放比
   */
  private minScale: number = 0.5
  /**
   * 设置最大缩放比
   */
  private maxScale: number = 2
  /**
   * 是否可缩放
   */
  private zoomEnabled: boolean = true
  /**
   * 是否可以平移
   */
  private panEnabled: boolean = true
  /**
   * 是否可以旋转
   */
  private rotateEnable: boolean = true
  /**
   * 过渡动画ID
   */
  private id: string | undefined = undefined
  /**
   * 长按事件
   */
  private longPressListener: (event: GestureEvent, index: number) => void = () => {
  }
  /**
   * 单击事件
   */
  private onClickListener: (event: ClickEvent, index: number) => void = () => {
  }

  /**
   *
   * @param images 图片列表
   */
  constructor(images: ImageType[]) {
    this.images = images
  }

  getImages() {
    return this.images
  }

  /**
   * 设置背景颜色
   * @param bgColor 背景颜色
   */
  setBackgroundColor(bgColor: ResourceColor): ImagePreViewOption {
    this.bgColor = bgColor
    return this
  }

  getBackgroundColor(): ResourceColor {
    return this.bgColor
  }

  /**
   * 设置展示页
   * @param showIndex 索引
   */
  setShowIndex(showIndex: number): ImagePreViewOption {
    this.showIndex = showIndex
    return this
  }

  getShowIndex(): number {
    return this.showIndex
  }

  /**
   * 设置缓存数量
   * @param cachedCount 缓存数量
   */
  setCachedCount(cachedCount: number): ImagePreViewOption {
    this.cachedCount = cachedCount
    return this
  }

  getCachedCount(): number {
    return this.cachedCount
  }

  /**
   * 设置长按事件
   * @param event 事件回调函数
   *    其中：
   *      event: GestureEvent，与手势事件一致
   *      index: 当前长按的图片索引
   */
  setLongPressListener(event: (event: GestureEvent, index: number) => void): ImagePreViewOption {
    this.longPressListener = event
    return this
  }

  getLongPressListener(): (event: GestureEvent, index: number) => void {
    return this.longPressListener
  }


  /**
   * 设置单击事件
   * @param event 事件回调函数
   *    其中：
   *      event: ClickEvent，与点击事件一致
   *      index: 当前点击的图片索引
   */
  setOnClickListener(event: (event: ClickEvent, index: number) => void): ImagePreViewOption {
    this.onClickListener = event
    return this
  }

  getOnClickListener(): (event: ClickEvent, index: number) => void {
    return this.onClickListener
  }


  /**
   * 允许缩放
   * @param zoomEnabled
   */
  setZoomEnabled(zoomEnabled: boolean): ImagePreViewOption {
    this.zoomEnabled = zoomEnabled
    return this
  }

  getZoomEnabled(): boolean {
    return this.zoomEnabled
  }

  /**
   * 是否允许拖拽
   * @param panEnabled
   */
  setPanEnabled(panEnabled: boolean): ImagePreViewOption {
    this.panEnabled = panEnabled
    return this
  }

  getPanEnabled(): boolean {
    return this.panEnabled
  }

  /**
   * 允许选装
   * @param rotateEnable
   * @returns
   */
  setRotateEnable(rotateEnable: boolean): ImagePreViewOption {
    this.rotateEnable = rotateEnable
    return this
  }

  getRotateEnable(): boolean {
    return this.rotateEnable
  }

  /**
   * 最大缩放比
   * @param maxScale
   */
  setMaxScale(maxScale: number): ImagePreViewOption {
    this.maxScale = maxScale
    return this
  }

  getMaxScale(): number {
    return this.maxScale;
  }

  /**
   * 最小缩放比
   * @param minScale
   */
  setMinScale(minScale: number): ImagePreViewOption {
    this.minScale = minScale
    return this
  }

  getMinScale(): number {
    return this.minScale
  }
}
