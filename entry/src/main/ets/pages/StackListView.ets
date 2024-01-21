
import hilog from '@ohos.hilog';
import { Layout } from '../common/constants/Layout';
@Entry
@Component
struct StackListView {
  @State datas: Array<number>  = [1,2,3,4,5,6,7,8];


  build() {

    Column(){
      StackList({datas: $datas,itemView: this.itemView})
    }
    .width(Layout.FULL_PERCENT)
    .height(Layout.FULL_PERCENT)
  }


  @Builder itemView(item: number,index: number){
    ItemView({item: item,index: index})
  }


}


@Component
struct ItemView{
  @State item: number = 0;
  @State index: number = 0;
  build(){
    Row(){
      Text(JSON.stringify(this.item))
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
    }
    .justifyContent(FlexAlign.Center)
    .width('80%')
    .height(200)
    .borderRadius(30)
    .backgroundColor(Color.Green)
    .shadow({
      color: Color.Black,
      radius: 30
    })
  }
}


@Component
struct StackList{
  /**
   * 数据
   */
  @Link datas: Array<any>;
  /**
   * 子组件
   */
  @BuilderParam itemView: (item: any,index: number) => void;
  /**
   * 透明度指数
   */
  @State opacityVal: number = 20;

  /**
   * 每个item的偏移量
   */
  @State offsetY: number = 100;

  /**
   * 缩放偏移量
   */
  @State offsetScale: number = 7;

  /**
   * 垂直位移大小
   */
  @State private verticalOffset: number = 0;

  /**
   * 总偏移量
   */
  @State private totalOffsetY: number = 0;

  @State private indexArr: Array<number> = [];

  /**
   * 中心 item 索引
   */
  private centerIndex: number = 0;

  /**
   * 当前索引
   */
  private currentIndex: number = 0;

  /**
   * 获取拖动后的 Y 偏移量
   * @param y 初始 y 值
   * @returns
   */
  getOffsetY(y: number): number{
    return y * this.offsetY + this.verticalOffset + this.totalOffsetY;
  }

  /**
   * 获取拖动后的透明度变化
   * @param y 初始 y 值
   * @returns
   */
  getOpacity(y: number): number{
    let offset: number = y  * this.offsetY + this.verticalOffset + this.totalOffsetY;
    let opacity: number = 1 - Math.abs(offset) / 100 / this.opacityVal;
    return opacity < 0 ? 0 : opacity;
  }

  /**
   * 获取拖动后的大小变化
   * @param y
   * @returns
   */
  getScale(y: number): number{
    let offset: number = y  * this.offsetY + this.verticalOffset + this.totalOffsetY;
    let scale: number = 1 - Math.abs(offset) / 100 / this.offsetScale;
    return scale < 0 ? 0 : scale;
  }

  /**
   * 获取拖动后的层级
   * @param index
   * @returns
   */
  getZIndex(index: number): number{
    let offset: number = (index - this.centerIndex)  * this.offsetY + this.verticalOffset + this.totalOffsetY;
    // hilog.info(111,'stackList',`index: ${index}; offset: ${offset}`)
    if (offset > -this.offsetY && offset < this.offsetY) {
      return 999;
    }else if (offset <= -this.offsetY){
      return index;
    }else if (offset >= this.offsetY){
      return -index;
    }
  }

  aboutToAppear(){
    this.centerIndex = Math.floor(this.datas.length / 2) + this.datas.length % 2;
    this.datas = this.datas.splice(this.centerIndex).concat(this.datas);
    for (let i = 0; i < this.datas.length; i++) {
      this.indexArr.push(i);
    }
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
        .offset({x: 0, y: this.getOffsetY(this.indexArr[index] - this.centerIndex)})
        .zIndex(this.getZIndex(this.indexArr[index]))
        .opacity(this.getOpacity(this.indexArr[index] - this.centerIndex))
        .scale({x: this.getScale(this.indexArr[index] - this.centerIndex), y: this.getScale(this.indexArr[index] - this.centerIndex) })
      },(item:any,_index: number) => JSON.stringify(item)
      )
    }
    .gesture(
      PanGesture({direction: PanDirection.Vertical})
        .onActionStart((event: GestureEvent) => {
          this.verticalOffset = event.offsetY;
        })
        .onActionUpdate((event: GestureEvent) => {
          let curIndex = Math.round((this.totalOffsetY + event.offsetY) / this.offsetY);
          this.handlePanGesture(curIndex - this.currentIndex);
          this.currentIndex = curIndex;
          this.verticalOffset = event.offsetY;
        })
        .onActionEnd((event: GestureEvent) => {
          let end: number = Math.round((this.totalOffsetY + event.offsetY) / this.offsetY);
          // hilog.info(111,'stackList',this.indexArr.toString())
          animateTo({
            duration: 300
          },() => {
            this.totalOffsetY = end * this.offsetY;
            this.verticalOffset = 0;
          })
        })
    )
    .width(Layout.FULL_PERCENT)
    .height(Layout.FULL_PERCENT)
  }


}
