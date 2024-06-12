import { NoviceTs } from "../tssrc/index.js"
import { NoviceWasm, NoviceMemory } from "../watsrc/index.js";
import assert from "node:assert";
import { test, suite } from "mocha";

suite("testMemset", () => {
    const memBuffer = NoviceMemory.buffer;
    const check = (_start: number, value:number, _size:number) => {
        const summands = new Uint8Array(memBuffer);
        for (let i = _start; i < _size; i ++) {
            if (summands[i] != value) {
                return i + 1 - _start;
            }
        }
        return 0;
    }
    test("testMemsetZeroLength", () => {
        const value: number = 199;
        const origin_mem: number = 0;
        const mem:number = NoviceWasm.memset(origin_mem, value, 0);
        assert.strictEqual(mem, origin_mem);
        // since length is zero, will not check the memory.
    });
    test("testMemsetNormalValue", () => {
        const value: number = 199;
        const origin_mem: number = 0;
        const mem:number = NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(mem, origin_mem);
        assert.strictEqual(check(mem, 199, 100), 0);
    });
    test("testMemsetNegativeToComplementValue", () => {
        const value: number = -1;
        const origin_mem: number = 0;
        const mem:number = NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(mem, origin_mem);
        assert.strictEqual(check(mem, 255, 100), 0);
    });
    test("testMemsetCutOverFlowValue", () => {
        const value: number = 167832;
        const origin_mem: number = 0;
        const mem:number = NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(mem, origin_mem);
        assert.strictEqual(check(mem, 167832 & 255, 100), 0);
    });
  });
