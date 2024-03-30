
import { DataType, StackList} from '@rv/rvcomponent'

@Entry
@Component
struct StackListView {
  @State datas: Array<number>  = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  build() {
    Column(){
      StackList({
        isVertical: true,
        datas: $datas,
        itemView: (item: DataType,index: number) => {this.itemView(item as number,index)},
        offsetXY: 200
      })
    }
    .width("100%")
    .height("100%")
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
    .backgroundColor(Color.Pink)
    .border({
      color: Color.Black,
      width: 2
    })
  }
}

