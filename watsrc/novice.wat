(module
    (import "js" "mem" (memory 1))
    (import "js" "tab" (table 1 funcref))
    (type $t_cmp_fn (func (param $_ele1 i32) (param $_ele2 i32) (result i32)))
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
    (func $memset (param $_mem i32) (param $_ch i32) (param $_size i32)
        (local $_sp i32) (local $_i i32) (local $_cnt i32) (local $_ch64 i64)
        (local.set $_sp (local.get $_mem))
        (if (i32.eqz (local.get $_size))
           (then return)
        )
        (if (i32.ge_u (local.get $_size) (i32.const 0x10000))
           (then return)
        )
        local.get $_ch
        i64.extend_i32_u
        call  $splat64
        local.set $_ch64
        (block $_block1
            local.get $_size
            i32.const 8
            call $subrem
            local.set $_size
            local.tee $_cnt
            i32.eqz
            br_if   $_block1
            (local.set $_i (i32.const 0))
            (loop $_loop1
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
                br_if   $_loop1
            )
            local.get $_cnt
            local.get $_sp
            i32.add
            local.set $_sp
        )
        (block $_block2
            local.get $_size
            i32.const 4
            call $subrem
            local.set $_size
            local.tee $_cnt
            i32.eqz
            br_if   $_block2
            (local.set $_i (i32.const 0))
            (loop $_loop2
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
                br_if   $_loop2
            )
            local.get $_cnt
            local.get $_sp
            i32.add
            local.set $_sp
        )
        (block $_block3
            local.get $_size
            i32.eqz
            br_if   $_block3
            (local.set $_i (i32.const 0))
            (loop $_loop3
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
                br_if   $_loop3
            )
        )
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
    (func $getSum (param $_nums i32) (param $_count i32) (result i32)
        (local $_sum i32) (local $_cnt i32) (local $_i i32)
        local.get $_count
        i32.const 4
        i32.mul
        local.set $_cnt
        i32.const 0
        local.set $_i
        (loop 
            local.get $_i
            local.get $_nums
            i32.add
            i32.load
            local.get $_sum
            i32.add
            local.set $_sum
            local.get $_i
            i32.const 4
            i32.add
            local.tee $_i
            local.get $_cnt
            i32.lt_u
            br_if 0
        )
        local.get $_sum
        return
    )
    (func $swap (param $a i32) (param $b i32) (param $_ele_size i32)
        (local $_i i32)
        i32.const 0
        local.set $_i
        (loop $_loop
            local.get $b
            local.get $a
            local.get $_i
            i32.add
            local.tee $a
            i32.load8_u
            local.get $a
            local.get $b
            local.get $_i
            i32.add
            local.tee $b
            i32.load8_u
            i32.store8
            i32.store8
            local.get $_i
            i32.const 1
            i32.add
            local.tee $_i
            local.get $_ele_size
            i32.ge_u
            br_if $_loop
        )
        return
    )
    (func $quickSort (param $_elements i32) (param $_count i32) (param $_ele_size i32) (param $_fn_cmp i32)
        (local $lower_bound i32) (local $upper_bound i32) (local $left i32) (local $right i32)
        (i32.mul (local.get $_count) (local.get $_ele_size))
        (if (i32.eqz (local.tee $right)) (then return))
        (local.get $_elements)
        (local.tee $left)
        (local.tee $lower_bound)
        (local.get $right)
        (i32.add)
        (local.tee $right)
        (local.set $upper_bound)
        (block $_block_out
            (loop $_out_loop
                (block $_block1
                    (loop $_loop1
                        (i32.ge_u (local.get $left) (local.get $right))
                        br_if  $_block_out
                        (local.get $left) (local.get $right) (local.get $_fn_cmp)
                        (i32.le_s (call_indirect (type $t_cmp_fn)) (i32.const 0))
                        (local.set $left (i32.add (local.get $left) (local.get $_ele_size)))
                        br_if $_loop1
                    )
                    (i32.ge_u (local.get $left) (local.get $right))
                    br_if  $_block_out
                    (local.get $left) (local.get $right) (local.get $_ele_size)
                    call $swap
                    (local.set $right (i32.sub (local.get $right) (local.get $_ele_size)))
                )
                (block $_block2
                    (loop $_loop2
                        (i32.ge_u (local.get $left) (local.get $right))
                        br_if  $_block_out
                        (local.get $left) (local.get $right) (local.get $_fn_cmp)
                        (i32.le_s (call_indirect (type $t_cmp_fn)) (i32.const 0))
                        (local.set $right (i32.sub (local.get $right) (local.get $_ele_size)))
                        br_if $_loop2
                    )
                    (i32.ge_u (local.get $left) (local.get $right))
                    br_if  $_block2
                    (local.get $left) (local.get $right) (local.get $_ele_size)
                    call $swap
                    (local.set $left (i32.add (local.get $left) (local.get $_ele_size)))
                )
                br $_out_loop
            )
        )
        (local.get $lower_bound)
        (i32.div_u (i32.sub (local.get $left) (local.get $lower_bound)) (local.get $_ele_size))
        (local.get $_ele_size)
        (local.get $_fn_cmp)
        call $quickSort

        (i32.add (local.get $right) (local.get $_ele_size))
        (i32.div_u (i32.sub (local.tee $right) (local.get $upper_bound)) (local.get $_ele_size))
        (local.set $_count)
        (local.get $right)
        (local.get $_count)
        (local.get $_ele_size)
        (local.get $_fn_cmp)
        call $quickSort
    )
    (export "abs32" (func $abs32))
    (export "abs64" (func $abs64))
    (export "memset" (func $memset))
    (export "getSum" (func $getSum))
    (export "quickSort" (func $quickSort))
)
