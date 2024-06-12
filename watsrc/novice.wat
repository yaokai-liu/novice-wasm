(module
    (import "js" "mem" (memory 1))
    (func $memset (param $_mem i32) (param $_ch i32) (param $_size i32) (result i32)
        (block $_block
            local.get  $_size
            i32.eqz
            br_if 0
            (loop $_loop
                local.get  $_size
                i32.const  1
                i32.sub
                local.tee  $_size
                local.get  $_mem
                i32.add
                local.get  $_ch
                i32.store8
                local.get  $_size
                i32.const  0
                i32.ne
                br_if $_loop
            )
        )
        local.get $_mem
        return
    )
    (func $abs32 (param $_num i32) (result i32)
        (local.get  $_num)
        f32.convert_i32_s
        f32.abs
        i32.trunc_f32_s
        return
    )
    (func $abs64 (param $_num i64) (result i64)
        (local.get  $_num)
        f64.convert_i64_s
        f64.abs
        i64.trunc_f64_s
        return
    )
    (export "abs32" (func $abs32))
    (export "abs64" (func $abs64))
    (export "memset" (func $memset))
)
