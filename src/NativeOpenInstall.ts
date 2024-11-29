import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";


export interface Spec extends TurboModule {
  init(): void;

  // getInstall():Promise<string>;
  getInstall(seconds?: number):Promise<string>;

  getWakeUp(url: string): Promise<string>

  reportRegister(): void;

  // reportEffectPoint(id: string, value: number): void;
  reportEffectPoint(id: string, value: number, extra?: string[]): void;

  reportShare(code: string, platform: string): Promise<string>

}
export default TurboModuleRegistry.get<Spec>("RTNOpenInstall");