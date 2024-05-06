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
  private id:string | undefined = undefined


  /**
   * 长按事件
   */
  private longPressListener: () => void = () => {
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
  setBackgroundColor(bgColor: ResourceColor) {
    this.bgColor = bgColor
  }

  getBackgroundColor(): ResourceColor {
    return this.bgColor
  }

  /**
   * 设置展示页
   * @param showIndex 索引
   */
  setShowIndex(showIndex: number) {
    this.showIndex = showIndex
  }

  getShowIndex(): number {
    return this.showIndex
  }

  /**
   * 设置缓存数量
   * @param cachedCount 缓存数量
   */
  setCachedCount(cachedCount: number) {
    this.cachedCount = cachedCount
  }

  getCachedCount(): number {
    return this.cachedCount
  }

  /**
   * 设置长按事件
   * @param event 事件
   */
  setLongPressListener(event: () => void) {
    this.longPressListener = event
  }

  getLongPressListener(): () => void {
    return this.longPressListener
  }

  /**
   * 允许缩放
   * @param zoomEnabled
   */
  setZoomEnabled(zoomEnabled: boolean) {
    this.zoomEnabled = zoomEnabled
  }

  getZoomEnabled(): boolean {
    return this.zoomEnabled
  }

  /**
   * 是否允许拖拽
   * @param panEnabled
   */
  setPanEnabled(panEnabled: boolean) {
    this.panEnabled = panEnabled
  }

  getPanEnabled(): boolean {
    return this.panEnabled
  }

  /**
   * 允许选装
   * @param rotateEnable
   * @returns
   */
  setRotateEnable(rotateEnable: boolean) {
    return this.rotateEnable = rotateEnable
  }

  getRotateEnable(): boolean {
    return this.rotateEnable
  }

  /**
   * 最大缩放比
   * @param maxScale
   */
  setMaxScale(maxScale: number) {
    this.maxScale = maxScale
  }

  getMaxScale(): number {
    return this.maxScale;
  }

  /**
   * 最小缩放比
   * @param minScale
   */
  setMinScale(minScale: number) {
    this.minScale = minScale
  }

  getMinScale(): number {
    return this.minScale
  }

  /**
   * 设置过渡动画id
   * @param minScale
   */
  setId(id: string) {
    this.id = id
  }

  /**
   * 最小缩放比
   * @param minScale
   */
  getId(): string {
    return this.id as string
  }

}
