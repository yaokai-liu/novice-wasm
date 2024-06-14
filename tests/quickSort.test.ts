import { NoviceWasm, NoviceMemory } from "../watsrc/index.js";
import assert from "node:assert";
import { test, suite } from "mocha";

suite("testQuickSort", () => {
    const memBuffer = NoviceMemory.buffer;
    const setArray = (_array: Array<number>, _start: number) => {
        const summands = new Uint32Array(memBuffer);
        for (var i = 0; i < _array.length; i ++) {
            summands[i + _start] = _array[i + _start];
        }
    }
    const check = (_array:Array<number>, _start: number, _size:number) => {
        const summands = new Uint32Array(memBuffer);
        for (let i = 0; i < _size; i ++) {
            assert.strictEqual(summands[i + _start], _array[i], `at index of ${i}`);
        }
    }
    test("testQuickSortRandom", () => {
        const array1: Array<number> = [33, 23, 2, 1, 9, 12, 5, 8, 2, 3, 1, 4, 6, 7,10];
        const array2: Array<number> = [33, 23, 2, 1, 9, 12, 5, 8, 2, 3, 1, 4, 6, 7,10];
        const compareFn = (a:number, b:number) => { return a == b  ? 0 : a > b ? 1 : -1; };
        const startAddress = 0;
        setArray(array1, startAddress);
        array2.sort(compareFn);
        NoviceWasm.quickSort32(startAddress, array1.length);
        check(array2, 0, array1.length);
    });
    test("testQuickSortReversed", () => {
        const array1: Array<number> = [9, 8, 7, 6, 5, 4, 3, 2, 1];
        const array2: Array<number> = [9, 8, 7, 6, 5, 4, 3, 2, 1];
        const compareFn = (a:number, b:number) => { return a == b  ? 0 : a > b ? 1 : -1; };
        const startAddress = 0;
        setArray(array1, startAddress);
        array2.sort(compareFn);
        NoviceWasm.quickSort32(startAddress, array1.length);
        check(array2, 0, array1.length);
    });
    test("testQuickSortOdered", () => {
        const array1: Array<number> = [3, 5, 6, 8, 9, 10, 21, 33, 45, 69];
        const array2: Array<number> = [3, 5, 6, 8, 9, 10, 21, 33, 45, 69];
        const compareFn = (a:number, b:number) => { return a == b  ? 0 : a > b ? 1 : -1; };
        const startAddress = 0;
        setArray(array1, startAddress);
        array2.sort(compareFn);
        NoviceWasm.quickSort32(startAddress, array1.length);
        check(array2, 0, array1.length);
    });
  });
