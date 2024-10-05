/**
 * 图片类型
 */
export type ImageType = PixelMap | ResourceStr | DrawableDescriptor

/**
 * 长按事件
 */
export type ImgLongPressCallback = (event: GestureEvent, index: number) => void

/**
 * 单击事件
 */
export type ImgClickCallback = (event: GestureEvent, index: number) => void

/**
 * 下拉事件
 */
export type ImgPullDownCallback = (event: GestureEvent, index: number) => void

/**
 * 翻页事件
 */
export type ImgFlipCallback = (prePage: number, nextPage: number) => void

/**
 * 共享元素专场id生成策略
 */
export type TransitionIdGeneratorCallback = (image: ImageType, index: number) => string

/**
 * 图片自定义解析
 */
export type ImgParserCallBack = (image: ImageType, index: number) => ImageType
