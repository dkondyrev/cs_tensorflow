(module
  (memory (export "memory") 1)

  (func $getElem (param $offset i32) (param $index i32) (result i32)
    (i32.load
      (i32.add
        (get_local $offset)
        (i32.mul
          (get_local $index)
          (i32.const 4)
        )
      )
    )
  )

  (func $setElem (param $offset i32) (param $index i32) (param $element i32)
    (i32.store
      (i32.add
        (get_local $offset)
        (i32.mul
          (get_local $index)
          (i32.const 4)
        )
      )
      (get_local $element)
    )
  )

  (func (export "addArrays")
    (param $offset_1 i32)
    (param $offset_2 i32)
    (param $offset_3 i32)
    (param $size i32)

    (local $i i32)
    (set_local $i (i32.const 0))

    (block
      (loop
        (br_if 1 (i32.ge_s (get_local $i) (get_local $size)))

        (call $setElem
          (get_local $offset_3)
          (get_local $i)

          (i32.add
            (call $getElem
              (get_local $offset_1)
              (get_local $i)
            )
            (call $getElem
              (get_local $offset_2)
              (get_local $i)
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
  )
)
