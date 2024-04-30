import { Layout } from '../../common/constants/Layout'
import { DataType } from '../../common/type'


@Component
export struct StackLoopList {
  // 是否垂直
  isVertical: boolean = true
  // 缩放偏移量，每个 item 缩放递减
  offsetScale: number = 0.1
  // 透明偏移量，每个 item 缩放递减
  offsetOpacity: number = 0.1
  // 偏移量
  offsetXY: number = 10
  // 滑动阻尼
  damping: number = 1;

  // 数据
  @Link @Watch("initDate") datas: DataType[]
  // 组件
  @BuilderParam itemView: (item: DataType,index: number) => void
  // 保存偏移量数组
  @State private posArr: number[] = []
  // 当前重点显示索引
  @State private currentIndex: number = 0
  // 总位移量
  @State private totalOffset: number = 0
  // 滑动时位移量
  @State private slideOffset: number = 0

  aboutToAppear() {
    this.initDate()
  }

  /**
   * 初始化数据
   */
  initDate() {
    const centerIndex = Math.floor(this.datas.length / 2) + this.datas.length % 2;
    for (let i = 0; i < this.datas.length; i++) {
      this.posArr.push(i);
    }
    this.handlePanGesture(centerIndex)
  }

  /**
   * 获取偏移量
   * @param index
   * @returns
   */
  getOffset(index: number): number {
    return this.posArr[index] * this.offsetXY + this.totalOffset + this.slideOffset
  }
  /**
   * 获取层级信息
   * @param index
   * @returns
   */
  getZIndex(index: number): number {
    const offset = this.getOffset(index)
    if (offset < this.offsetXY && offset > -this.offsetXY) {
      return 999
    }
    if (offset >= this.offsetXY) {
      return -this.posArr[index]
    } else {
      return this.posArr[index]
    }
  }
  /**
   * 获取透明量
   * @param index
   * @returns
   */
  getOpacity(index: number): number {
    const offset = Math.abs(this.getOffset(index))
    const opacity = 1 - offset / this.offsetXY * this.offsetScale
    return opacity > 0 ? opacity : 0
  }
  /**
   * 获取缩放量
   * @param index
   * @returns
   */
  getScale(index: number): number {
    const offset = Math.abs(this.getOffset(index))
    const scale = 1 - offset / this.offsetXY * this.offsetScale
    return scale > 0 ? scale : 0
  }
  /**
   * 处理循环列表
   * @param offset
   */
  handlePanGesture(offset: number) {
    if (offset === 0) {
      return
    }
    if (offset > 0) {
      this.posArr = this.posArr.map(v => v - offset)
      for (let i = 0; i < offset; i++) {
        this.posArr.push(this.posArr[0])
        this.posArr.shift();
      }
    } else if (offset < 0) {
      this.posArr = this.posArr.map(v => v - offset)
      for (let i = 0; i < -offset; i++) {
        this.posArr.unshift(this.posArr[this.posArr.length-1])
        this.posArr.pop();
      }
    }
  }

  build() {
    Stack() {
      ForEach(this.datas, (item: DataType, index: number) => {
        Column() {
          this.itemView(item, index)
        }
        .opacity(this.getOpacity(index))
        .scale({ x: this.getScale(index), y: this.getScale(index) })
        .zIndex(this.getZIndex(index))
        .offset({ x: this.isVertical ? 0 : this.getOffset(index), y: this.isVertical ? this.getOffset(index) : 0 })
        .justifyContent(FlexAlign.Center)
      })
    }
    .width(Layout.FULL_PERCENT).height(Layout.FULL_PERCENT)
    .gesture(
      PanGesture({ direction: this.isVertical ? PanDirection.Vertical : PanDirection.Horizontal })
        .onActionStart(event => {
          this.slideOffset = (this.isVertical ? event.offsetY : event.offsetX) / this.damping
        })
        .onActionUpdate(event => {
          this.slideOffset = (this.isVertical ? event.offsetY : event.offsetX) / this.damping
          const offsetNum = Math.round((this.totalOffset + this.slideOffset) / this.offsetXY)
          this.handlePanGesture(offsetNum - this.currentIndex)
          this.currentIndex = offsetNum
        })
        .onActionEnd(event => {
          this.totalOffset += (this.isVertical ? event.offsetY : event.offsetX) / this.damping
          this.currentIndex = Math.round(this.totalOffset / this.offsetXY)
          this.slideOffset = 0
          animateTo({
            duration: 300
          }, () => {
            this.totalOffset = this.currentIndex * this.offsetXY;
          })
        })
    )
  }
}
