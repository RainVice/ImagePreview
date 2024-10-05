import { ImageType } from '@rv/image-preview'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  @State images: ImageType[] = [
    $r('app.media.img'),
    $r('sys.media.ohos_icon_mask_svg'),
    $r('sys.media.ohos_ic_public_video'),
    $r('sys.media.ohos_user_auth_icon_fingerprint'),
    $r('sys.media.ohos_ic_public_select_all'),
  ]
  build() {
    Column(){
      ForEach(this.images,(image: ImageType,index: number) =>{
        Image(image)
          .width(100)
          .height(100)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Images',
              params: {
                index,
                images: this.images
              }
            })
          })
      })
    }
  }
}