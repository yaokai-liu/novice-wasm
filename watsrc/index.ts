
import { Func } from "mocha";
import exp from "node:constants";
import fs from "node:fs";

class WasmModule {
    
}

export const NoviceWasm: Record<string, Function> = {};

function loadAbs(): void {
    const wasmBuffer = fs.readFileSync("../build/watsrc/abs.wasm");
    WebAssembly.instantiate(wasmBuffer).then(wasmModule => {
        return new WebAssembly.Instance(wasmModule.module);
    }).then(instance => {
        NoviceWasm.abs32 = instance.exports.abs32 as any as (_num:number)=>number;
        NoviceWasm.abs64 = instance.exports.abs64 as any as (_num:bigint)=>bigint;
    });

}
loadAbs();
