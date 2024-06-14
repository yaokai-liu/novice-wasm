import { NoviceTs } from "../tssrc/index.js"
import { NoviceWasm, NoviceMemory } from "../watsrc/index.js";
import assert from "node:assert";
import { test, suite } from "mocha";

suite("testMemset", () => {
    const memBuffer = NoviceMemory.buffer;
    const setArray = (_array: Array<number>) => {
        const summands = new Uint32Array(memBuffer);
        for (var i = 0; i < _array.length; i ++) {
            summands[i] = _array[i];
        }
        return 0;
    }
    test("testGetSumZeroLength", () => {
        const array: Array<number> = [0];
        setArray(array);
        const sum = NoviceWasm.getSum(0, 0);
        assert.strictEqual(sum, 0);
    });
    test("testGetSum001To100", () => {
        const array: Array<number> = [];
        for (var i: number = 0; i < 100; i ++) { array.push(i+1); }
        setArray(array);
        const sum = NoviceWasm.getSum(0, 100);
        assert.strictEqual(sum, 5050);
    });
  });
