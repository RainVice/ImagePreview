import { ImageType, ImgParserCallBack } from "./common";

export class ImageDataSource implements IDataSource {
  private data: ImageType[]
  private listeners: DataChangeListener[] = [];
  // 图片解析器
  private _imgParser?: ImgParserCallBack
  set imgParser(callback: ImgParserCallBack) {
    this._imgParser = callback
  }

  constructor(data?: ImageType[]) {
    this.data = data ?? []
  }

  totalCount(): number {
    return this.data.length
  }

  getData(index: number): ImageType {
    const image = this.data[index]
    if (this._imgParser) {
      return this._imgParser(image, index)
    }
    return image
  }

  addData(images: ImageType) {
    this.data.push(images)
    this.notifyDataAdd(this.totalCount() - 1)
  }

  setData(images: ImageType[]) {
    this.data = images
    this.notifyDataReload()
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }


  removeData(index: number) {
    this.data.splice(index, 1)
    this.notifyDataRemove(index)
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataRemove(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }
}