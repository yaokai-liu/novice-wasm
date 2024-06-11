import fs from "node:fs";
import { dirname } from "node:path";
import { fileURLToPath } from "node:url";

export const NoviceWasm: Record<string, Function> = {};

const DIR: string = dirname(fileURLToPath(import.meta.url));

function loadWasmModule(): void {
    const wasmBuffer = fs.readFileSync(DIR + "/novice.wasm");
    WebAssembly.instantiate(wasmBuffer).then(wasmModule => {
        return new WebAssembly.Instance(wasmModule.module);
    }).then(instance => {
        NoviceWasm.abs32 = instance.exports.abs32 as any as (_num:number)=>number;
        NoviceWasm.abs64 = instance.exports.abs64 as any as (_num:bigint)=>bigint;
    });

}
loadWasmModule();
