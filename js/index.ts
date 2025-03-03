import NativeOpenInstall from './NativeOpenInstall'
import {
    EmitterSubscription,
    Platform,
    DeviceEventEmitter,
} from 'react-native';

export default class RTNOpenInstall {
    static serialEnabled(enabled: boolean) {
        // ignore, platform unsupport
    }

    static clipBoardEnabled(enabled: boolean) {
        // ignore, platform unsupport
    }


    static init(options?: Object) {
        NativeOpenInstall?.init()
    }

    static getInstall(seconds?: number): Promise<Object> {
        if (seconds == null) {
            seconds = 10
        }
        if (NativeOpenInstall == null) {
            return Promise.reject("import NativeOpenInstall failed")
        }
        return NativeOpenInstall.getInstall(seconds)
    }

    static addWakeUpListener(callback: Function, alwaysCallback?: boolean): EmitterSubscription {
        return DeviceEventEmitter.addListener("url", (data) => {
            console.log("receive url event : " + JSON.stringify(data))
            NativeOpenInstall?.getWakeUp(data.url).then(ret => {
                callback(ret)
            }).catch(e => {

            })
        })
    }

    static reportRegister() {
        NativeOpenInstall?.reportRegister()
    }

    static reportEffectPoint(effectID: string, effectValue: number, extra?: Object) {
        if (extra == null) {
            extra = {}
        }
        let extraArray: string[] = []
        let i = 0
        for(const prop in extra){
            extraArray[i++] = prop
            extraArray[i++] = extra[prop] as string
        }
        NativeOpenInstall?.reportEffectPoint(effectID, effectValue, extraArray)
    }


    static reportShare(shareCode: string, sharePlatform: string): Promise<Object> {
        if (NativeOpenInstall == null) {
            return Promise.reject("import NativeOpenInstall failed")
        }
        return NativeOpenInstall.reportShare(shareCode, sharePlatform)
    }

}