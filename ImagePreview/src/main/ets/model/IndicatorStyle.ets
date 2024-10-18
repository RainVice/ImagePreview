import { CustomIndicatorBuilder, IndicatorItemBuilder } from "../utils/common"

export enum IndicatorType {
  DOT, // 圆点
  DIGITAL, // 数字
  NONE // 无
}


/**
 * 指示器样式
 */
@Observed
export class IndicatorStyle {
  // 指示器位置
  alignRules?: AlignRuleOption
  // 指示器外边距
  margin?: Margin | Length | LocalizedMargin
  // 自定义指示器
  customIndicatorBuilder?: CustomIndicatorBuilder
}

/**
 * 数字指示器样式
 */
@Observed
export class DigitalIndicatorStyle extends IndicatorStyle {
  text?: ResourceStr
  fontSize?: Length
  fontColor?: ResourceColor
  fontWeight?: FontWeight
  fontStyle?: FontStyle
}

/**
 * 圆点指示器样式
 */
@Observed
export class DotIndicatorStyle extends IndicatorStyle {
  // 指示器宽
  indicatorWidth?: Length
  // 圆点宽
  dotWidth?: Length
  // 圆点高
  dotHeight?: Length
  // 圆点间距
  dotSpace?: number | string
  // 圆点半径
  dotRadius?: Length
  // 选中颜色
  dotActiveColor?: ResourceColor
  // 未选中颜色
  dotInactiveColor?: ResourceColor
  // 自定义选中指示器
  customActiveBuilder?: IndicatorItemBuilder
  // 自定义未选中指示器
  customInactiveBuilder?: IndicatorItemBuilder
}