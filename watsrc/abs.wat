(module 
    (func $abs32 (param $_num i32) (result i32)
        local.get $_num
        f32.convert_i32_s
        f32.abs
        i32.trunc_f32_s
        return
    )
    (func $abs64 (param $_num i64) (result i64)
        local.get  $_num
        f64.convert_i64_s
        f64.abs
        i64.trunc_f64_s
        return
    )
    (export "abs32" (func $abs32))
    (export "abs64" (func $abs64))
)
