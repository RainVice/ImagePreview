import { ImagePreviewController } from "../utils/ImagePreviewController";

@ObservedV2
export class ImagePreviewViewModel {
  private readonly controller: ImagePreviewController;
  private readonly _indicatorScroll: ListScroller = new ListScroller()
  public static readonly INDICATOR_DEFAULT_ALIGN_RULES: AlignRuleOption = {
    bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
    middle: { anchor: "__container__", align: HorizontalAlign.Center }
  }
  public static readonly INDICATOR_DEFAULT_MARGIN: Margin = { bottom: 10 };

  constructor(controller: ImagePreviewController,) {
    this.controller = controller;
  }

  // 透明度，不向外提供修改
  @Trace private _bgOpacity: number = 1;
  // 当前页码，不向外提供修改
  @Trace private _currentPage: number = 0;
  // 滚动过程中处于哪一页，不向外提供修改
  @Trace private _currentScrollPage: number = 0;
  // 指示器高度
  @Trace private _indicatorHeight: number = -1;

  public set bgOpacity(value: number) {
    this._bgOpacity = value;
  }

  public set currentPage(value: number) {
    this._currentPage = value;
    this.controller.currentPage = value;
  }

  public set currentScrollPage(value: number) {
    this._currentScrollPage = value;
    this.controller.currentScrollPage = value;
  }

  public set indicatorHeight(value: Length | undefined) {
    this._indicatorHeight = Math.max(value as number ?? 0, this._indicatorHeight)
  }

  public get bgOpacity(): number {
    return this._bgOpacity;
  }

  public get currentPage(): number {
    return this._currentPage;
  }

  public get currentScrollPage(): number {
    return this._currentScrollPage;
  }

  public get indicatorScroll(): ListScroller {
    return this._indicatorScroll;
  }

  public get indicatorHeight(): number {
    return this._indicatorHeight;
  }
}