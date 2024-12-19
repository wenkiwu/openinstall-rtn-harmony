import { TurboModule, TurboModuleContext } from '@rnoh/react-native-openharmony/ts';
import { OpData, OpenInstall, OpError } from '@openinstall/sdk';
import { common, Want } from '@kit.AbilityKit';
import { ResultData } from './ResultData';
import { JSON } from '@kit.ArkTS';
import { RNInstance } from '@rnoh/react-native-openharmony';

export class OpenInstallModule extends TurboModule {
  private uiAbilityContext: common.UIAbilityContext
  private rnInstance: RNInstance
  private launchUri: string | undefined

  constructor(ctx: TurboModuleContext) {
    super(ctx)
    this.rnInstance = ctx.rnInstance
    this.uiAbilityContext = ctx.uiAbilityContext
    this.launchUri = ctx.launchUri

    OpenInstall.preInit(this.uiAbilityContext)
  }

  init(): void {
    console.debug("OpenInstallModule init()")
    OpenInstall.init(this.uiAbilityContext)

    // RNInstance.onNewWant  ->  this.emitDeviceEvent('url', { url: url });
    if (this.launchUri) {
      console.debug("OpenInstallModule launchUri = " + this.launchUri)
      this.rnInstance.emitDeviceEvent("url", { url: this.launchUri })
    }
  }

  getInstall(seconds: number): Promise<Object> {
    console.debug("OpenInstallModule getInstall(%d)", seconds)
    return new Promise((resolve) => {
      OpenInstall.getInstall(seconds, {
        onResult: (data: OpData) => {
          console.debug("OpenInstallModule getInstall onResult = %s", JSON.stringify(data))
          resolve(this.toResult(data))
        },
        onError: (error: OpError) => {
          console.debug("OpenInstallModule getInstall onError = %s", JSON.stringify(error))
          resolve(this.toResult(error))
        }
      })
    })
  }

  getWakeUp(url: string): Promise<Object> {
    console.debug("OpenInstallModule getWakeUp uri = ", url)
    if (url == null) {
      return Promise.resolve(this.toResult("invalid uri"))
    }
    return new Promise((resolve) => {
      let fakeWant: Want = {
        action: "ohos.want.action.viewData",
        uri: url
      }
      OpenInstall.getWakeUp(fakeWant, {
        onResult: (data: OpData) => {
          console.debug("OpenInstallModule getWakeUp onResult = %s", JSON.stringify(data))
          resolve(this.toResult(data))
        },
        onError: (error: OpError) => {
          console.debug("OpenInstallModule getWakeUp onError = %s", JSON.stringify(error))
          resolve(this.toResult(error))
        }
      })
    })
  }

  reportRegister(): void {
    console.debug("OpenInstallModule reportRegister()")
    OpenInstall.reportRegister()
  }

  reportEffectPoint(id: string, value: number, extra?: string[]): void {
    console.debug("OpenInstallModule reportEffectPoint(%s, %d)", id, value)
    let extraMap = new Map<string, string>()
    if (extra) {
      console.debug("OpenInstallModule extra = " + JSON.stringify(extra))
      for (let i = 0; i < extra.length - 1; ) {
        extraMap.set(extra[i++], extra[i++])
      }
    }
    OpenInstall.reportEffectPoint(id, value, extraMap)
  }

  reportShare(code: string, platform: string): Promise<Object> {
    console.debug("OpenInstallModule reportShare(%s, %s)", code, platform)
    return new Promise((resolve) => {
      OpenInstall.reportShare(code, platform, {
        onResult: (result: void) => {
          console.debug("OpenInstallModule reportShare onResult")
          resolve(this.toResult(null))
        },
        onError: (error: OpError) => {
          console.debug("OpenInstallModule reportShare onError = %s", JSON.stringify(error))
          resolve(this.toResult(error))
        }
      })
    })
  }

  private toResult(x: OpData | OpError | string): Object {
    let result = new ResultData()
    if (x instanceof OpData) {
      result.channel = x.channelCode
      result.data = x.bindData
    } else if (x instanceof OpError) {
      if (x.code == OpError.REQUEST_FAIL || x.code == OpError.TIMEOUT) {
        result.shouldRetry = true
      }
      result.message = x.message ?? "未知错误"
    } else {
      result.message = x
    }
    return result
  }
}