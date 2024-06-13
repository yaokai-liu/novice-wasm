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
                return false;
            }
        }
        return true;
    }
    test("testMemsetNormalValue", () => {
        const value: number = 199;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(check(origin_mem, 199, 100), true);
    });
    test("testMemsetNegativeToComplementValue", () => {
        const value: number = -1;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(origin_mem, origin_mem);
        assert.strictEqual(check(origin_mem, 255, 100), true);
    });
    test("testMemsetCutOverFlowValue", () => {
        const value: number = 167832;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(origin_mem, origin_mem);
        assert.strictEqual(check(origin_mem, value & 255, 100), true);
    });
  });
