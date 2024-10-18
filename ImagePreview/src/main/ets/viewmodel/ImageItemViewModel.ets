import { ImageAnimUtil } from "../utils/ImageAnimUtil";

@ObservedV2
export class ImageItemViewModel {
  // 偏移量
  @Trace offsetX: number = 0;
  @Trace offsetY: number = 0;
  // 上一次偏移量
  preOffsetX: number = 0;
  preOffsetY: number = 0;
  // 缩放中心点
  @Trace centerX: number = 0;
  @Trace centerY: number = 0;
  // 缩放中心点（用于下拉手势）
  @Trace centerXDown: string = "50%";
  // 缩放比例
  @Trace scaleRatio: number = 1;
  // 上一次缩放比例
  preScaleRatio: number = 1;
  // 缩放比例（用于下拉手势）
  @Trace scaleRatioDown: number = 1;
  // 预览器大小
  previewHeight: number = 0;
  previewWidth: number = 0;
  // 图片组件大小
  @Trace imageHeight: number = 0;
  @Trace imageWidth: number = 0;
  // 图片容器大小
  imgComponentHeight: number = 0;
  imgComponentWidth: number = 0;
  // 翻页位移差
  flipDistance: number = 0
  // 最大缩放比例
  max_scale_ratio: number = 5
  static readonly DEFAULT_MAX_SCALE_RATIO = 5
  // 最小缩放比例
  static readonly MIN_SCALE_RATIO = 1
  // 默认 offsetY
  defaultOffsetY: number = 0

  reset() {
    this.refreshScale(ImageItemViewModel.MIN_SCALE_RATIO)
    this.refreshCenter()
    this.refreshOffset(undefined, this.defaultOffsetY)
  }

  /**
   * 刷新缩放和位移
   */
  refreshScaleAndOffsetAnim(ratio: number = this.scaleRatio, offsetX: number = this.offsetX,
    offsetY: number = this.offsetY) {
    ratio = this.getLegalScaleRatio(ratio)
    this.refreshScaleAnim(ratio)
    this.refreshOffsetAnim(this.getLegalOffsetX(offsetX, ratio), this.getLegalOffsetY(offsetY, ratio))
  }

  /**
   * 设置缩放比例
   * @param scaleRatio 缩放比例
   */
  refreshScale(scaleRatio: number = this.scaleRatio) {
    this.scaleRatio = this.getLegalScaleRatio(scaleRatio)
  }

  refreshScaleAnim(scaleRatio: number = this.scaleRatio) {
    ImageAnimUtil.playScale(this.scaleRatio, this.getLegalScaleRatio(scaleRatio), (value: number) => {
      this.scaleRatio = value
    })
  }

  /**
   * 设置缩放中心点
   * @param centerX 缩放中心点 x
   * @param centerY 缩放中心点 y
   */
  refreshCenter(centerX: number = this.centerX, centerY: number = this.centerY) {
    this.refreshCenterX(centerX)
    this.refreshCenterY(centerY)
  }

  refreshCenterAnim(centerX: number = this.centerX, centerY: number = this.centerY) {
    this.refreshCenterXAnim(centerX)
    this.refreshCenterYAnim(centerY)
  }


  /**
   * 设置位移
   * @param offsetX
   * @param offsetY
   */
  refreshOffset(offsetX: number = this.offsetX, offsetY: number = this.offsetY) {
    this.refreshOffsetX(offsetX)
    this.refreshOffsetY(offsetY)
  }

  refreshOffsetAnim(offsetX: number = this.offsetX, offsetY: number = this.offsetY) {
    this.refreshOffsetXAnim(offsetX)
    this.refreshOffsetYAnim(offsetY)
  }

  /**
   * 设置位移 x
   * @param offsetX 位移 x
   */
  refreshOffsetX(offsetX: number = this.offsetX) {
    this.offsetX = this.getLegalOffsetX(offsetX)
  }

  refreshOffsetXAnim(offsetX: number = this.offsetX) {
    ImageAnimUtil.playOffsetX(this.offsetX, this.getLegalOffsetX(offsetX), (value: number) => {
      this.offsetX = this.getLegalOffsetX(value)
    })
  }

  /**
   * 设置位移 y
   * @param offsetY 位移 y
   */
  refreshOffsetY(offsetY: number = this.offsetY) {
    this.offsetY = this.getLegalOffsetY(offsetY)
  }

  refreshOffsetYAnim(offsetY: number = this.offsetY) {
    ImageAnimUtil.playOffsetY(this.offsetY, this.getLegalOffsetY(offsetY), (value: number) => {
      this.offsetY = this.getLegalOffsetY(value)
    })
  }

  /**
   * 设置缩放中心点
   * @param centerX 缩放中心点 x
   */
  refreshCenterX(centerX: number = this.centerX) {
    this.centerX = this.getLegalCenterX(centerX)
  }

  refreshCenterXAnim(centerX: number = this.centerX) {
    ImageAnimUtil.playCenterX(this.centerX, this.getLegalCenterX(centerX), (value: number) => {
      this.centerX = this.getLegalCenterX(value)
    })
  }

  refreshCenterXDown(centerXDown: number) {
    this.centerXDown = `${(centerXDown * 100).toFixed()}%`
  }

  /**
   * 设置缩放中心点
   * @param centerY 缩放中心点 y
   */
  refreshCenterY(centerY: number = this.centerY) {
    this.centerY = this.getLegalCenterY(centerY)
  }

  refreshCenterYAnim(centerY: number = this.centerY) {
    ImageAnimUtil.playCenterY(this.centerY, this.getLegalCenterY(centerY), (value: number) => {
      this.centerY = this.getLegalCenterY(value)
    })
  }

  /**
   * 获取合法的缩放比例
   * @param scaleRatio 缩放比例
   * @returns 合法的缩放比例
   */
  getLegalScaleRatio(scaleRatio: number): number {
    return Math.min(Math.max(scaleRatio, ImageItemViewModel.MIN_SCALE_RATIO), this.max_scale_ratio)
  }

  /**
   * 获取水平方向合法的偏移量
   * @param offsetX 横坐标偏移量
   * @returns 合法的偏移量
   */
  getLegalOffsetX(offsetX: number = this.offsetX, ratio: number = this.scaleRatio): number {
    // 如果图片宽度小于预览宽度，则偏移量置为0
    if (this.imgComponentWidth * ratio <= this.previewWidth) {
      return 0
    }
    return Math.max(Math.min(offsetX, this.getLeftBoundary(ratio)), this.getRightBoundary(ratio))
  }

  /**
   * 获取垂直方向合法的偏移量
   * @param offsetY 纵坐标偏移量
   * @returns 合法的偏移量
   */
  getLegalOffsetY(offsetY: number = this.offsetY, ratio: number = this.scaleRatio): number {
    // 如果图片高度小于预览高度，则偏移量置为0
    if (this.imgComponentHeight * ratio <= this.previewHeight) {
      return 0
    }
    return Math.max(Math.min(offsetY, this.getTopBoundary(ratio)), this.getBottomBoundary(ratio))
  }

  /**
   * 获取合法的缩放中心点
   * @param centerX 缩放中心点
   * @returns 合法的缩放中心点
   */
  getLegalCenterX(centerX: number = this.centerX, ratio: number = this.scaleRatio): number {
    if (this.imgComponentWidth * ratio <= this.previewWidth) {
      return this.previewWidth / 2
    }
    return centerX
  }

  /**
   * 获取合法的缩放中心点
   * @param centerY 缩放中心点
   * @returns 合法的缩放中心点
   */
  getLegalCenterY(centerY: number = this.centerY, ratio: number = this.scaleRatio): number {
    if (this.imgComponentHeight * ratio <= this.previewHeight) {
      return this.previewHeight / 2
    }
    return centerY
  }

  /**
   * 计算比例因子
   * @param ratio 缩放比例
   * @returns 比例因子
   */
  getScaleRatioFactor(ratio: number = this.scaleRatio): number {
    return (ratio - 1) / ratio
  }

  /**
   * 上边界
   * @param ratio 缩放比例
   * @returns 上边界
   */
  getTopBoundary(ratio: number = this.scaleRatio): number {
    return this.centerY * this.getScaleRatioFactor(ratio) + (this.imgComponentHeight - this.previewHeight) / 2
  }

  /**
   * 下边界
   * @param ratio 缩放比例
   * @returns 下边界
   */
  getBottomBoundary(ratio: number = this.scaleRatio): number {
    return (this.centerY - this.previewHeight) * this.getScaleRatioFactor(ratio) -
      (this.imgComponentHeight - this.previewHeight) / 2
  }

  /**
   * 左边界
   * @param ratio 缩放比例
   * @returns 左边界
   */
  getLeftBoundary(ratio: number = this.scaleRatio): number {
    return this.centerX * this.getScaleRatioFactor(ratio) + (this.imgComponentWidth - this.previewWidth) / 2
  }

  /**
   * 右边界
   * @param ratio 缩放比例
   * @returns 右边界
   */
  getRightBoundary(ratio: number = this.scaleRatio): number {
    return (this.centerX - this.previewWidth) * this.getScaleRatioFactor(ratio) -
      (this.imgComponentWidth - this.previewWidth) / 2
  }

  /**
   * 图片宽高比
   * @returns 图片宽高比
   */
  get imageRatio(): number {
    return (this.imageWidth / this.imageHeight) || 1
  }

  /**
   * 是否在水平边界
   * @returns 是否在水平边界
   */
  get isHorizontalBoundary(): boolean {
    return this.offsetX >= this.getLeftBoundary() || this.offsetX <= this.getRightBoundary()
  }

  /**
   * 是否在左边界
   * @returns
   */
  get isLeftBoundary(): boolean {
    return this.offsetX >= this.getLeftBoundary()
  }

  /**
   * 是否在右边界
   * @returns
   */
  get isRightBoundary(): boolean {
    return this.offsetX <= this.getRightBoundary()
  }

  get isTopBoundary(): boolean {
    return this.offsetY >= this.getTopBoundary()
  }
}