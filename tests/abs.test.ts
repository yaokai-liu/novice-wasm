import { NoviceTs } from "../tssrc/index.js"
import { NoviceWasm } from "../watsrc/index.js";
import assert from "node:assert";
import { test, suite } from "mocha";

suite("testAbs", () => {
    test("testAbs32Positive", () => {
        assert.strictEqual(NoviceTs.abs32(32), 32);
        assert.strictEqual(NoviceWasm.abs32(32), 32);
    });
    test("testAbs32Negative", () => {
        assert.strictEqual(NoviceTs.abs32(-32), 32);
        assert.strictEqual(NoviceWasm.abs32(-32), 32);
    });
    test("testAbs64Positive", () => {
        assert.strictEqual(NoviceTs.abs64(81341n), 81341n);
        assert.strictEqual(NoviceWasm.abs64(81341n), 81341n);
    });
    test("testAbs64Negative", () => {
        assert.strictEqual(NoviceTs.abs64(-81341n), 81341n);
        assert.strictEqual(NoviceWasm.abs64(-81341n), 81341n);
    });
  });
