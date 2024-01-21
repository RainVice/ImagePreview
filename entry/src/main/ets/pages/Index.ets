
import router from '@ohos.router';

class AnimPage{

  name: string;
  page: string;

}

@Entry
@Component
struct Index {

  @State names: Array<AnimPage> = [
    {name: '堆叠列表',page: 'pages/StackListView'},

  ]

  build() {
    Column() {

      Text("案例列表")
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({bottom: 20})

      List({space: 10}){
        ForEach(this.names,(item: AnimPage )=> {
          ListItem(){
            Button(item.name)
              .onClick(() => router.pushUrl({url: item.page}))
          }
          .width("100%")
        })
      }
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }
}