(module
    (import "js" "mem" (memory 1))
    (import "debug" "log" (func $log (param i64)))
    (func $splat64 (param $a i64) (result i64)  (local $_debug i64)
        (i64.shr_u  (i64.shl (local.get  $a) (i64.const  56)) (i64.const  56))
        (i64.or (i64.shl (local.tee $a) (i64.const 8 )) (local.get $a))
        (i64.or (i64.shl (local.tee $a) (i64.const 16)) (local.get $a))
        (i64.or (i64.shl (local.tee $a) (i64.const 32)) (local.get $a))
        return
    )
    (func $subrem (param $a i32) (param $b i32) (result i32 i32)
        local.get $a
        (i32.rem_u (local.get $a) (local.get $b))
        local.tee $b
        i32.sub
        local.get $b
        return
    )
    (func $memset (param $_mem i32) (param $_ch i32) (param $_size i32) (result i32)
        (local $_sp i32) (local $_i i32) (local $_cnt i32) (local $_ch64 i64)
        (local.set $_sp (local.get $_mem))
        (if (i32.eqz (local.get $_size))
           (then (local.get $_mem) return)
        )
        local.get $_ch
        i64.extend_i32_u
        call  $splat64
        local.set $_ch64
        (block
            local.get $_size
            i32.const 8
            call $subrem
            local.set $_size
            local.tee $_cnt
            i32.eqz
            br_if   0
            (local.set $_i (i32.const 0))
            (loop
                local.get $_i
                local.get $_sp
                i32.add
                local.get $_ch64
                i64.store
                local.get $_i
                i32.const 8
                i32.add
                local.tee $_i
                local.get $_cnt
                i32.lt_u
                br_if   0
            )
            local.get $_cnt
            local.get $_sp
            i32.add
            local.set $_sp
        )
        (block
            local.get $_size
            i32.const 4
            call $subrem
            local.set $_size
            local.tee $_cnt
            i32.eqz
            br_if   0
            (local.set $_i (i32.const 0))
            (loop
                local.get $_i
                local.get $_sp
                i32.add
                local.get $_ch64
                i64.store32
                local.get $_i
                i32.const 4
                i32.add
                local.tee $_i
                local.get $_cnt
                i32.lt_u
                br_if   0
            )
            local.get $_cnt
            local.get $_sp
            i32.add
            local.set $_sp
        )
        (block
            local.get $_size
            i32.eqz
            br_if   0
            (local.set $_i (i32.const 0))
            (loop
                local.get $_i
                local.get $_sp
                i32.add
                local.get $_ch64
                i64.store8
                local.get $_i
                i32.const 1
                i32.add
                local.tee $_i
                local.get $_size
                i32.lt_u
                br_if   0
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
