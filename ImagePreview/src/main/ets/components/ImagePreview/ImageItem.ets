import { ImageType } from './common'
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';

@Component
export struct ImageItem {
  @Prop image: ImageType
  @Prop zoomEnabled: boolean
  @Prop panEnabled: boolean
  @Prop rotateEnable: boolean
  @Prop maxScale: number
  @Prop minScale: number
  @Prop index: number
  onClickEvent: (event: ClickEvent, index: number) => void = () => {
  }
  longPressListener: (event: GestureEvent, index: number) => void = () => {
  }
  @State private currentScaleValue: number = 1
  @State private preScaleValue: number = 1
  @State private centerX: number | string = "50%"
  @State private centerY: number | string = "50%"
  @State private currentOffsetX: number = 0
  @State private currentOffsetY: number = 0
  @State private preOffsetX: number = 0
  @State private preOffsetY: number = 0
  @State private currentAngle: number = 0
  @State private preAngle: number = 0
  private parentHeight: number = 0
  private parentWidth: number = 0
  private animatorResultScale: AnimatorResult | undefined = undefined
  private animatorResultY: AnimatorResult | undefined = undefined
  private animatorResultX: AnimatorResult | undefined = undefined
  private animatorResultAngle: AnimatorResult | undefined = undefined

  // 单击是否触发
  private isClick: boolean = false

  // 计时器id
  private timeroutId: number = 0

  build() {
    if (this.image) {
      Column() {
        Image(this.image)
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .offset({
            x: this.currentOffsetX,
            y: this.currentOffsetY,
          })
          .scale({
            x: this.currentScaleValue,
            y: this.currentScaleValue,
            centerX: this.centerX,
            centerY: this.centerY,
          })
          .rotate({
            angle: this.currentAngle,
            // todo 待实现
            // centerX: this.centerX,
            // centerY: this.centerY,
          })
          .sharedTransition(JSON.stringify(this.image) + this.index, {
            duration: 300
          })
          .width("100%")
      }
      .onClick((event) => {
        if (this.isClick) {
          this.isClick = false
          clearTimeout(this.timeroutId)
          this.doubleClick(event)
        }else{
          this.isClick = true
          this.timeroutId = setTimeout(() => {
            this.isClick = false
            this.onClickEvent(event, this.index)
          },300)
        }
      })
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .height("100%")
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.parentHeight = newValue.height as number
        this.parentWidth = newValue.width as number
      })
      .gesture(
        GestureGroup(GestureMode.Parallel,
          PinchGesture()
            .onActionStart((event: GestureEvent) => {
              // todo 待优化
              this.centerX = event.pinchCenterX
              this.centerY = event.pinchCenterY
              this.animatorResultScale?.cancel()
              this.animatorResultY?.cancel()
              this.animatorResultX?.cancel()
              this.animatorResultAngle?.cancel()
              this.preScaleValue = this.currentScaleValue
            })
            .onActionUpdate((event: GestureEvent) => {
              if (!this.zoomEnabled) {
                return
              }
              this.currentScaleValue = this.preScaleValue + event.scale - 1
              this.centerX = event.pinchCenterX
              this.centerY = event.pinchCenterY
            })
            .onActionEnd((event: GestureEvent) => {
              if (this.currentScaleValue < this.minScale) {
                const options: AnimatorOptions = {
                  duration: 300,
                  easing: "linear",
                  delay: 0,
                  fill: "forwards",
                  direction: "normal",
                  iterations: 1,
                  begin: this.currentScaleValue,
                  end: this.minScale
                };
                this.animatorResultScale = animator.create(options)
                this.animatorResultScale.onFrame = (num: number) => {
                  this.currentScaleValue = num
                }
                this.animatorResultScale.play()
              }
              if (this.currentScaleValue > this.maxScale) {
                const options: AnimatorOptions = {
                  duration: 300,
                  easing: "linear",
                  delay: 0,
                  fill: "forwards",
                  direction: "normal",
                  iterations: 1,
                  begin: this.currentScaleValue,
                  end: this.maxScale
                };
                this.animatorResultScale = animator.create(options)
                this.animatorResultScale.onFrame = (num: number) => {
                  this.currentScaleValue = num
                }
                this.animatorResultScale.play()
              }
            }),

          PanGesture({ fingers: 2 })
            .onActionStart((event: GestureEvent) => {
              this.animatorResultScale?.cancel()
              this.animatorResultY?.cancel()
              this.animatorResultX?.cancel()
              this.animatorResultAngle?.cancel()
              this.preOffsetX = this.currentOffsetX
              this.preOffsetY = this.currentOffsetY
            })
            .onActionUpdate((event: GestureEvent) => {
              if (!this.panEnabled) {
                return
              }
              this.currentOffsetX = this.preOffsetX + event.offsetX
              this.currentOffsetY = this.preOffsetY + event.offsetY
            })
            .onActionEnd((event: GestureEvent) => {
              if (Math.abs(this.currentOffsetX) > this.parentWidth / 2 ||
                Math.abs(this.currentOffsetY) > this.parentHeight / 2) {

                this.centerX = "50%"
                this.centerY = "50%"

                const optionsX: AnimatorOptions = {
                  duration: 300,
                  easing: "linear",
                  delay: 0,
                  fill: "forwards",
                  direction: "normal",
                  iterations: 1,
                  begin: this.currentOffsetX,
                  end: 0
                };
                this.animatorResultX = animator.create(optionsX)
                this.animatorResultX.onFrame = (num: number) => {
                  this.currentOffsetX = num
                }
                this.animatorResultX.play()

                const optionsY: AnimatorOptions = {
                  duration: 300,
                  easing: "linear",
                  delay: 0,
                  fill: "forwards",
                  direction: "normal",
                  iterations: 1,
                  begin: this.currentOffsetY,
                  end: 0
                };
                this.animatorResultY = animator.create(optionsY)
                this.animatorResultY.onFrame = (num: number) => {
                  this.currentOffsetY = num
                }
                this.animatorResultY.play()
              }
            }),

          RotationGesture()
            .onActionStart((event: GestureEvent) => {
              // todo 待优化
              this.centerX = event.pinchCenterX
              this.centerY = event.pinchCenterY
              this.animatorResultScale?.cancel()
              this.animatorResultY?.cancel()
              this.animatorResultX?.cancel()
              this.animatorResultAngle?.cancel()
              this.preAngle = this.currentAngle
            })
            .onActionUpdate((event: GestureEvent) => {
              if (!this.rotateEnable) {
                return
              }
              this.currentAngle = this.preAngle + event.angle
            })
            .onActionEnd((event: GestureEvent) => {
              const options: AnimatorOptions = {
                duration: 300,
                easing: "linear",
                delay: 0,
                fill: "forwards",
                direction: "normal",
                iterations: 1,
                begin: this.currentAngle,
                end: Math.floor(this.currentAngle / 90) * 90
              };
              this.animatorResultAngle = animator.create(options)
              this.animatorResultAngle.onFrame = (num: number) => {
                this.currentAngle = num
              }
              this.animatorResultAngle.play()
            }),

          LongPressGesture().onAction((event: GestureEvent) => {
            this.longPressListener(event, this.index)
          }),

          TapGesture({ count: 2,fingers: 2 })
            .onAction((event: GestureEvent) => {
              // todo 待优化
              // this.centerX = "50%"
              // this.centerY = "50%"
              const optionsScale: AnimatorOptions = {
                duration: 300,
                easing: "linear",
                delay: 0,
                fill: "forwards",
                direction: "normal",
                iterations: 1,
                begin: this.currentScaleValue,
                end: 1
              };
              this.animatorResultScale = animator.create(optionsScale)
              this.animatorResultScale.onFrame = (num: number) => {
                this.currentScaleValue = num
              }
              this.animatorResultScale.play()
              const optionsAngle: AnimatorOptions = {
                duration: 300,
                easing: "linear",
                delay: 0,
                fill: "forwards",
                direction: "normal",
                iterations: 1,
                begin: this.currentAngle,
                end: 0
              };
              this.animatorResultAngle = animator.create(optionsAngle)
              this.animatorResultAngle.onFrame = (num: number) => {
                this.currentAngle = num
              }
              this.animatorResultAngle.play()
              const optionsX: AnimatorOptions = {
                duration: 300,
                easing: "linear",
                delay: 0,
                fill: "forwards",
                direction: "normal",
                iterations: 1,
                begin: this.currentOffsetX,
                end: 0
              };
              this.animatorResultX = animator.create(optionsX)
              this.animatorResultX.onFrame = (num: number) => {
                this.currentOffsetX = num
              }
              this.animatorResultX.play()
              const optionsY: AnimatorOptions = {
                duration: 300,
                easing: "linear",
                delay: 0,
                fill: "forwards",
                direction: "normal",
                iterations: 1,
                begin: this.currentOffsetY,
                end: 0
              };
              this.animatorResultY = animator.create(optionsY)
              this.animatorResultY.onFrame = (num: number) => {
                this.currentOffsetY = num
              }
              this.animatorResultY.play()
            })
        )
      )
      .clip(true)
    }
  }

  doubleClick(event: ClickEvent) {

    // todo 待优化
    this.centerX = event.x
    this.centerY = event.y

    if (this.currentScaleValue === 1){
      const optionsScale: AnimatorOptions = {
        duration: 300,
        easing: "linear",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: this.currentScaleValue,
        end: this.maxScale
      };
      this.animatorResultScale = animator.create(optionsScale)
      this.animatorResultScale.onFrame = (num: number) => {
        this.currentScaleValue = num
      }
      this.animatorResultScale.play()
    }else{
      const optionsScale: AnimatorOptions = {
        duration: 300,
        easing: "linear",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: this.currentScaleValue,
        end: 1
      };
      this.animatorResultScale = animator.create(optionsScale)
      this.animatorResultScale.onFrame = (num: number) => {
        this.currentScaleValue = num
      }
      this.animatorResultScale.play()
    }

  }

}