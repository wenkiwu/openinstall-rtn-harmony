/**
 * This code was generated by "react-native codegen-harmony"
 * 
 * Do not edit this file as changes may cause incorrect behavior and will be
 * lost once the code is regenerated.
 * 
 * @generatorVersion: 1
 */

#include "RTNOpenInstall.h"

namespace rnoh {
using namespace facebook;

RTNOpenInstall::RTNOpenInstall(const ArkTSTurboModule::Context ctx, const std::string name) : ArkTSTurboModule(ctx, name) {
    methodMap_ = {
        ARK_METHOD_METADATA(init, 0),
        ARK_ASYNC_METHOD_METADATA(getInstall, 1),
        ARK_ASYNC_METHOD_METADATA(getWakeUp, 1),
        ARK_METHOD_METADATA(reportRegister, 0),
        ARK_METHOD_METADATA(reportEffectPoint, 3),
        ARK_ASYNC_METHOD_METADATA(reportShare, 2),
    };
}

} // namespace rnoh
