(module
  (memory (import "js" "mem") 1)

  (func $get_index (param $offset i32) (param $index i32) (param $size i32) (result i32)
    (i32.add
      (get_local $offset)
      (i32.mul
        (get_local $index)
        (get_local $size)
      )
    )
  )

  (func $get_elem_f32 (param $offset i32) (param $index i32) (result f32)
    (f32.load
      (call $get_index
        (get_local $offset)
        (get_local $index)
        (i32.const 4)
      )
    )
  )

  (func $set_elem_f32 (param $offset i32) (param $index i32) (param $element f32)
    (f32.store
      (call $get_index
        (get_local $offset)
        (get_local $index)
        (i32.const 4)
      )
      (get_local $element)
    )
  )


  (func (export "transpose_f32")
    (param $offset_1 i32)
    (param $offset_2 i32)
    (param $m i32)
    (param $n i32)

    (local $i i32)
    (local $j i32)

    (set_local $i (i32.const 0))
    (set_local $j (i32.const 0))

    (block
      (loop
        (br_if 1 (i32.ge_s (get_local $i) (get_local $m)))

          (block
            (set_local $j (i32.const 0))
            (loop
              (br_if 1 (i32.ge_s (get_local $j) (get_local $n)))

              (call $set_elem_f32
                (get_local $offset_2)
                (i32.add
                  (i32.mul (get_local $j) (get_local $m))
                  (get_local $i)
                )

                (call $get_elem_f32
                  (get_local $offset_1)
                  (i32.add
                    (i32.mul (get_local $i) (get_local $n))
                    (get_local $j)
                  )
                )
              )

              (set_local $j
                (i32.add
                  (get_local $j)
                  (i32.const 1)
                )
              )
              (br 0)
            )
          )

        (set_local $i
          (i32.add
            (get_local $i)
            (i32.const 1)
          )
        )
        (br 0)
      )
    )

  )


  (func $matmul_dot_f32
    (param $offset_1 i32)
    (param $offset_2 i32)
    (param $k i32)
    (param $n i32)
    (result f32)

    (local $i i32)
    (local $accum f32)

    (set_local $i (i32.const 0))
    (set_local $accum (f32.const 0))

    (block
      (loop
        (br_if 1 (i32.ge_s (get_local $i) (get_local $n)))

        (set_local $accum
          (f32.add
            (get_local $accum)
            (f32.mul
              (call $get_elem_f32
                (get_local $offset_1)
                (get_local $i)
              )
              (call $get_elem_f32
                (get_local $offset_2)
                (i32.mul
                  (get_local $i)
                  (get_local $k)
                )
              )
            )
          )
        )

        (set_local $i
          (i32.add
            (get_local $i)
            (i32.const 1)
          )
        )
        (br 0)
      )
    )
    (get_local $accum)
  )


  (func $matmul_f32
    (param $offset_1 i32)
    (param $dim_1 i32)
    (param $dim_2 i32)
    (param $offset_2 i32)
    (param $dim_3 i32)
    (param $dim_4 i32)
    (result i32)

    (local $i i32)
    (local $j i32)
    (local $result_offset i32)

    (set_local $i (i32.const 0))
    (set_local $j (i32.const 0))
    (set_local $result_offset
      (i32.add
        (get_local $offset_2)
        (i32.mul
          (i32.mul
            (get_local $dim_3)
            (get_local $dim_4)
          )
          (i32.const 4)
        )
      )
    )

    (block
      (loop
        (br_if 1 (i32.ge_s (get_local $i) (get_local $dim_1)))

          (block
            (set_local $j (i32.const 0))
            (loop
              (br_if 1 (i32.ge_s (get_local $j) (get_local $dim_4)))

              (call $set_elem_f32
                (get_local $result_offset)
                (i32.add
                  (i32.mul (get_local $i) (get_local $dim_4))
                  (get_local $j)
                )

                (call $matmul_dot_f32
                  (i32.add
                    (get_local $offset_1)
                    (i32.mul
                      (i32.mul (get_local $i) (get_local $dim_2))
                      (i32.const 4)
                    )
                  )
                  (i32.add
                    (get_local $offset_2)
                    (i32.mul (get_local $j) (i32.const 4))
                  )
                  (get_local $dim_4)
                  (get_local $dim_2)
                )
              )

              (set_local $j
                (i32.add
                  (get_local $j)
                  (i32.const 1)
                )
              )
              (br 0)
            )
          )

        (set_local $i
          (i32.add
            (get_local $i)
            (i32.const 1)
          )
        )
        (br 0)
      )
    )
    (get_local $result_offset)
  )


  (func $matadd_f32
    (param $offset_1 i32)
    (param $dim_1 i32)
    (param $dim_2 i32)
    (param $offset_2 i32)
    (param $dim_3 i32)
    (param $dim_4 i32)
    (result i32)

    (local $i i32)
    (local $j i32)
    (local $current_index i32)
    (local $result_offset i32)

    (set_local $i (i32.const 0))
    (set_local $j (i32.const 0))
    (set_local $result_offset
      (i32.add
        (get_local $offset_2)
        (i32.mul
          (i32.mul
            (get_local $dim_3)
            (get_local $dim_4)
          )
          (i32.const 4)
        )
      )
    )

    (block
      (loop
        (br_if 1 (i32.ge_s (get_local $i) (get_local $dim_1)))

          (block
            (set_local $j (i32.const 0))
            (loop
              (br_if 1 (i32.ge_s (get_local $j) (get_local $dim_2)))

              (set_local $current_index
                (i32.add
                  (i32.mul (get_local $i) (get_local $dim_2))
                  (get_local $j)
                )
              )

              (call $set_elem_f32
                (get_local $result_offset)
                (get_local $current_index)

                (f32.add
                  (call $get_elem_f32
                    (get_local $offset_1)
                    (get_local $current_index)
                  )
                  (call $get_elem_f32
                    (get_local $offset_2)
                    (get_local $current_index)
                  )
                )
              )

              (set_local $j
                (i32.add
                  (get_local $j)
                  (i32.const 1)
                )
              )
              (br 0)
            )
          )

        (set_local $i
          (i32.add
            (get_local $i)
            (i32.const 1)
          )
        )
        (br 0)
      )
    )
    (get_local $result_offset)
  )

  (func (export "entry") (param $arg0.7.0 i32) (param $arg1.7.1 i32) (result i32)
    get_local $arg0.7.0
    i32.const 512
    i32.const 512
    get_local $arg1.7.1
    i32.const 512
    i32.const 512
    call $matmul_f32
  )


  (export "matmul_dot_f32" (func $matmul_dot_f32))
  (export "matadd_f32" (func $matadd_f32))
  (export "matmul_f32" (func $matmul_f32))
)
