import { Animator, AnimatorOptions, AnimatorResult } from "@kit.ArkUI";

export class ImageAnimUtil {
  private static animMap: Map<AnimType, AnimatorResult> = new Map()

  static playScale(begin: number, end: number, action: ImageAction) {
    ImageAnimUtil.play('scale', ImageAnimUtil.getOptions(begin, end), action)
  }

  static playCenterX(begin: number, end: number, action: ImageAction) {
    ImageAnimUtil.play('centerX', ImageAnimUtil.getOptions(begin, end), action)
  }

  static playCenterY(begin: number, end: number, action: ImageAction) {
    ImageAnimUtil.play('centerY', ImageAnimUtil.getOptions(begin, end), action)
  }

  static playOffsetX(begin: number, end: number, action: ImageAction) {
    ImageAnimUtil.play('offsetX', ImageAnimUtil.getOptions(begin, end), action)
  }

  static playOffsetY(begin: number, end: number, action: ImageAction) {
    ImageAnimUtil.play('offsetY', ImageAnimUtil.getOptions(begin, end), action)
  }

  static stop() {
    for (let anim of ImageAnimUtil.animMap.values()) {
      anim.pause()
    }
  }

  private static play(type: AnimType, option: AnimatorOptions, action: ImageAction) {
    ImageAnimUtil.animMap.get(type)?.pause()
    if (option.begin === option.end) {
      return
    }
    const anim = Animator.create(option)
    anim.onFrame = action
    ImageAnimUtil.animMap.set(type, anim)
    anim.play()
  }

  private static getOptions(begin: number, end: number) {
    return {
      duration: 300,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin,
      end
    } as AnimatorOptions
  }
}

type ImageAction = (value: number) => void
type AnimType = 'scale' | 'centerX' | 'centerY' | 'offsetX' | 'offsetY'