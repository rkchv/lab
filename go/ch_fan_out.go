package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func main() {
	numWorkers := 100
	ch := make(chan string, numWorkers)
	wg := sync.WaitGroup{}

	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(w int) {
			defer wg.Done()
			duration := time.Duration(rand.Intn(100)) * time.Millisecond
			time.Sleep(duration)
			ch <- "take this cake"
		}(w)
	}

	go func() {
		wg.Wait()
		close(ch)
	}()

	for v := range ch {
		fmt.Println(v)
	}

}
