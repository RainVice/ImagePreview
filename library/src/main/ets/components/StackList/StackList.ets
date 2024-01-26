import { Layout } from '../../common/constants/Layout';
@Component
export struct StackList{
  /**
   * 数据
   */
  @Link @Watch('aboutToAppear') datas: Array<any>;
  /**
   * 子组件
   */
  @BuilderParam itemView: (item: any,index: number) => void;
  /**
   * 透明度指数，默认 10
   */
  @State opacityVal: number = 10;

  /**
   * 每个item的偏移量，默认100
   */
  @State offsetVal: number = 100;

  /**
   * 缩放偏移量，默认 10
   */
  @State offsetScale: number = 10;

  /**
   * 是否垂直布局,默认垂直（true）
   */
  @State isVertical: boolean = true;

  /**
   * 滑动位移大小
   */
  @State private slideOffset: number = 0;

  /**
   * 总偏移量
   */
  @State private totalOffset: number = 0;

  /**
   * 保存偏移量
   */
  @State private indexArr: Array<number> = [];

  /**
   * 当前索引
   */
  private currentIndex: number = 0;

  /**
   * 获取拖动后的偏移量
   * @param currentIndex 当前位置索引
   * @returns
   */
  getOffset(currentIndex: number): number{
    return currentIndex * this.offsetVal + this.slideOffset + this.totalOffset;
  }

  /**
   * 获取拖动后的透明度变化
   * @param currentIndex 当前位置索引
   * @returns
   */
  getOpacity(currentIndex: number): number{
    let offset: number = currentIndex  * this.offsetVal + this.slideOffset + this.totalOffset;
    let opacity: number = 1 - Math.abs(offset) / 100 / this.opacityVal;
    return opacity < 0 ? 0 : opacity;
  }

  /**
   * 获取拖动后的大小变化
   * @param currentIndex 当前位置索引
   * @returns
   */
  getScale(currentIndex: number): number{
    let offset: number = currentIndex  * this.offsetVal + this.slideOffset + this.totalOffset;
    let scale: number = 1 - Math.abs(offset) / 100 / this.offsetScale;
    return scale < 0 ? 0 : scale;
  }

  /**
   * 获取拖动后的层级
   * @param currentIndex 当前位置索引
   * @returns
   */
  getZIndex(currentIndex: number): number{
    let offset: number = currentIndex  * this.offsetVal + this.slideOffset + this.totalOffset;
    // hilog.info(111,'stackList',`index: ${index}; offset: ${offset}`)
    if (offset > -this.offsetVal && offset < this.offsetVal) {
      return 999;
    }else if (offset <= -this.offsetVal){
      return currentIndex;
    }else if (offset >= this.offsetVal){
      return -currentIndex;
    }
  }

  aboutToAppear(){
    let centerIndex: number = Math.floor(this.datas.length / 2) + this.datas.length % 2;
    this.indexArr = [];
    for (let i = 0; i < this.datas.length; i++) {
      this.indexArr.push(i);
    }
    this.handlePanGesture(centerIndex);
  }

  /**
   * 处理循环列表
   * @param offset
   */
  handlePanGesture(offset: number){
    if (offset > 0){
      this.indexArr = this.indexArr.map(v => v - offset);
      for (let i = 0; i < offset; i++) {
        this.indexArr.push(this.indexArr[0]);
        this.indexArr.shift();
      }
    }else if (offset < 0){
      this.indexArr = this.indexArr.map(v => v - offset);
      for (let i = 0; i < -offset; i++) {
        this.indexArr.unshift(this.indexArr[this.indexArr.length-1]);
        this.indexArr.pop();
      }
    }
  }

  build(){
    Stack(){
      ForEach(this.datas, (item: any,index: number)=>{
        Column(){
          Row(){
            this.itemView(item,index)
          }
        }
        .offset({
          x: this.isVertical ? 0 : this.getOffset(this.indexArr[index]),
          y: this.isVertical ? this.getOffset(this.indexArr[index]) : 0
        })
        .zIndex(this.getZIndex(this.indexArr[index]))
        .opacity(this.getOpacity(this.indexArr[index]))
        .scale({x: this.getScale(this.indexArr[index]), y: this.getScale(this.indexArr[index]) })
      },(item:any,_index: number) => JSON.stringify(item)
      )
    }
    .gesture(
      PanGesture({direction: this.isVertical ? PanDirection.Vertical : PanDirection.Horizontal})
        .onActionStart((event: GestureEvent) => {
          this.slideOffset = this.isVertical ? event.offsetY : event.offsetX;
        })
        .onActionUpdate((event: GestureEvent) => {
          let curIndex = Math.round((this.totalOffset + (this.isVertical ? event.offsetY : event.offsetX)) / this.offsetVal);
          this.handlePanGesture(curIndex - this.currentIndex);
          this.currentIndex = curIndex;
          this.slideOffset = this.isVertical ? event.offsetY : event.offsetX;
        })
        .onActionEnd((event: GestureEvent) => {
          let end: number = Math.round((this.totalOffset + (this.isVertical ? event.offsetY : event.offsetX)) / this.offsetVal);
          animateTo({
            duration: 300
          },() => {
            this.totalOffset = end * this.offsetVal;
            this.slideOffset = 0;
          })
        })
    )
    .width(Layout.FULL_PERCENT)
    .height(Layout.FULL_PERCENT)
  }


}
