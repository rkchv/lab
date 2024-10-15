package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func generateNumbers(name string, ch chan int) {
	for i := 0; i < 5; i++ {
		num := rand.Intn(100)
		fmt.Printf("%s sent: %d\n", name, num)
		ch <- num
		time.Sleep(time.Millisecond * time.Duration(rand.Intn(500)))
	}
	close(ch)
}

func fanIn(ch1, ch2 <-chan int) <-chan int {
	out := make(chan int)
	wg := sync.WaitGroup{}

	wg.Add(1)
	go func() {
		defer wg.Done()
		for n := range ch1 {
			out <- n
		}
	}()

	wg.Add(1)
	go func() {
		defer wg.Done()
		for n := range ch2 {
			out <- n
		}
	}()

	go func() {
		wg.Wait()
		close(out)
	}()

	return out
}

func main() {
	ch1 := make(chan int)
	ch2 := make(chan int)

	go generateNumbers("Generator 1", ch1)
	go generateNumbers("Generator 2", ch2)

	combined := fanIn(ch1, ch2)

	for n := range combined {
		fmt.Printf("Received: %d\n", n)
	}
}
