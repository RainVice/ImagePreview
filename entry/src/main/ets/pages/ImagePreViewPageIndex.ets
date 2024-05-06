import { router } from '@kit.ArkUI'

@Entry
@Component
struct ImagePreViewPageIndex {
  @State images: ResourceStr[] = [
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
    $r('app.media.app_icon'),
  ]

  build() {
    Row() {
      Column() {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.images, (item: ResourceStr, index: number) => {
            Image(item)
              .width(100)
              .height(100)
              .margin(10)
              .sharedTransition(index.toString())
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ImagePreViewPage',
                  params: this.images
                })
              })

          })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}