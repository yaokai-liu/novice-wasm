import fs from "node:fs";
import { dirname } from "node:path";
import { fileURLToPath } from "node:url";

export const NoviceWasm: Record<string, Function> = {};
export const NoviceMemory = new WebAssembly.Memory({initial: 1});

const DIR: string = dirname(fileURLToPath(import.meta.url));

function loadWasmModule(): void {
    const importObject = {
        js: {
            mem: NoviceMemory
        }
    };
    const wasmBuffer = fs.readFileSync(DIR + "/novice.wasm");
    WebAssembly.instantiate(wasmBuffer, importObject).then(wasmModule => {
        return new WebAssembly.Instance(wasmModule.module, importObject);
    }).then(instance => {
        NoviceWasm.abs32 = instance.exports.abs32 as any as (_num:number)=>number;
        NoviceWasm.abs64 = instance.exports.abs64 as any as (_num:bigint)=>bigint;
        NoviceWasm.memset = instance.exports.memset as any as (_mem:number, _ch:number, _size:number) => number;
    });
}
loadWasmModule();
