package main

import (
	"fmt"
	"time"
)

func generator(arr []int) <-chan int {
	out := make(chan int, len(arr))

	go func() {
		for i := 0; i < len(arr); i++ {
			time.Sleep(time.Second)
			out <- arr[i]
		}
		close(out)
	}()

	return out
}

func pipe[T any](in <-chan T, fn func(v T) T) <-chan T {
	ch := make(chan T, cap(in))

	go func() {
		defer close(ch)
		for v := range in {
			ch <- fn(v)
		}
	}()

	return ch
}

func main() {
	seq := generator([]int{0, 1, 2, 3, 4})
	powed := pipe(seq, func(v int) int { return v * v })
	divided := pipe(powed, func(v int) int { return v / 2 })

	for v := range divided {
		fmt.Println(v)
	}

}
