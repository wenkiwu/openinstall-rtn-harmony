#### React Native 工程配置
1. 将 openinstall-rnoh-0.1.0.tgz 文件放到工程目录同一级，在工程的根目录下，运行下面命令
```
npm install openinstall-rnoh@file:../openinstall-rnoh-0.1.0.tgz
```
2. 在需要使用 openinstall 的文件中引入插件：
```
import RTNOpenInstall from 'openinstall-react-native'
```
3. 初始化
```
RTNOpenInstall.init();
```
4. 注册唤醒回调监听
```
  useEffect(() => {
    const sub = RTNOpenInstall.addWakeUpListener((data: any) => {
      setWakeupParam(JSON.stringify(data));
    });
    RTNOpenInstall?.init();
    return () => {
      sub?.remove();
    };
  }, []);
```
> 必须在初始化之前添加监听，否则可能导致唤醒时无法收到事件

5. 获取安装参数
```
  RTNOpenInstall.getInstall().then(data => {
    setInstallParam(JSON.stringify(data));
  }).catch(e => {
    console.error(e);
  });
```
6. 事件上报  

上报注册事件
```
RTNOpenInstall.reportRegister()
```
上报自定义事件
```
RTNOpenInstall.reportEffectPoint("effect_test", 1) 
// 支持携带额外参数
RTNOpenInstall.reportEffectPoint("effect_detail", 1, { "k": "10", "x": "z" })
```
分享上报
```
  RTNOpenInstall?.reportShare("c1001", "QQ").then(ret => {
    console.log("reportShare result = " + JSON.stringify(ret));
  }).catch(e => {
    console.log("reportShare error = " + JSON.stringify(e));
  });
```
#### 鸿蒙工程配置

1. 在工程的根目录的 `oh-package.json5` 添加 `overrides` 字段
```
{
  "overrides": {
    "@openinstall/sdk": "2.2.0",  // 当 Harmony SDK 升级时可在此修改版本
    "@rnoh/react-native-openharmony" : "^0.72.38"
  }
}

```
2. 通过 har 包引入原生端代码   
> har 包位于模块安装路径的 harmony 文件夹下
打开`entry/oh-package.json5` ，添加以下依赖
```
{
  "dependencies": {
    "@rnoh/react-native-openharmony": "0.72.38",  // add
    "openinstall": "file:../../node_modules/openinstall-rnoh/harmony/openinstall.har"
  },
}
```
3. 配置 `CMakeLists` 和引入 `RTNOpenInstallPackge`  
打开 `entry/src/main/cpp/CMakeLists.txt`，添加：
```
project(rnapp)
cmake_minimum_required(VERSION 3.4.1)
set(CMAKE_SKIP_BUILD_RPATH TRUE)
set(OH_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules")
set(RNOH_APP_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

set(RNOH_CPP_DIR "${OH_MODULE_DIR}/@rnoh/react-native-openharmony/src/main/cpp")
set(RNOH_GENERATED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/generated")
set(CMAKE_ASM_FLAGS "-Wno-error=unused-command-line-argument -Qunused-arguments")
set(CMAKE_CXX_FLAGS "-fstack-protector-strong -Wl,-z,relro,-z,now,-z,noexecstack -s -fPIE -pie")
add_compile_definitions(WITH_HITRACE_SYSTRACE)
set(WITH_HITRACE_SYSTRACE 1) # for other CMakeLists.txt files to use

add_subdirectory("${RNOH_CPP_DIR}" ./rn)
+ add_subdirectory("${OH_MODULE_DIR}/openinstall/src/main/cpp" ./openinstall) # add

add_library(rnoh_app SHARED
    "./PackageProvider.cpp"
    "${RNOH_CPP_DIR}/RNOHAppNapiBridge.cpp"
)

target_link_libraries(rnoh_app PUBLIC rnoh)
+ target_link_libraries(rnoh_app PUBLIC rnoh_openinstall)  # add
```
打开 `entry/src/main/cpp/PackageProvider.cpp`，添加
```
#include "RNOH/PackageProvider.h"
+ #include "RTNOpenInstallPackage.h"   // add

using namespace rnoh;

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    return {
+        std::make_shared<RTNOpenInstallPackage>(ctx),  // add
    };
}
```
4. 在 ArkTs 侧引入 OpenInstallPackage    
__修改文件后缀，将 RNPackagesFactory.ts文件后缀修改为ets__   
打开 `entry/src/main/ets/RNPackagesFactory.ets`，添加：
```
import { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony/ts';
+ import {OpenInstallPackage} from 'openinstall'  //add
export function createRNPackages(ctx: RNPackageContext): RNPackage[] {
  return [
+    new OpenInstallPackage(ctx)  // add
  ];
}
```
5. 参考鸿蒙的集成文档添加权限，配置Appkey和scheme
