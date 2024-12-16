import type { TurboModule, TurboModuleContext } from '@rnoh/react-native-openharmony/ts';
import { RNPackage, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts';
import { OpenInstallModule } from './OpenInstallModule';

class OpenInstallModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === "RTNOpenInstall") {
      return new OpenInstallModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === "RTNOpenInstall"
  }
}

export class OpenInstallPackage extends RNPackage {
  createTurboModulesFactory(ctx: TurboModuleContext): TurboModulesFactory {
    return new OpenInstallModulesFactory(ctx)
  }
}