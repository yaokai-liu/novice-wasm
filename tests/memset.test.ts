import { NoviceWasm, NoviceMemory } from "../watsrc/index.js";
import assert from "node:assert";
import { test, suite } from "mocha";

suite("testMemset", () => {
    const memBuffer = NoviceMemory.buffer;
    const check = (_start: number, value:number, _size:number) => {
        const summands = new Uint8Array(memBuffer);
        for (let i = 0; i < _size; i ++) {
            assert.strictEqual(summands[i + _start], value);
        }
    }
    test("testMemsetNormalValue", () => {
        const value: number = 199;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        check(origin_mem, 199, 100);
    });
    test("testMemsetNormalValue2", () => {
        const value: number = 234;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(origin_mem, origin_mem);
        check(origin_mem, 234, 100);
    });
    test("testMemsetNegativeToComplementValue", () => {
        const value: number = -1;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(origin_mem, origin_mem);
        check(origin_mem, 255, 100);
    });
    test("testMemsetCutOverFlowValue", () => {
        const value: number = 167832;
        const origin_mem: number = 0;
        NoviceWasm.memset(origin_mem, value, 100);
        assert.strictEqual(origin_mem, origin_mem);
        check(origin_mem, value & 255, 100);
    });
  });
