package main

import (
	"fmt"
	"math/rand"
	"runtime"
	"sync"
	"time"
)

func main() {
	numWorkers := 100
	ch := make(chan string, numWorkers)
	wg := sync.WaitGroup{}

	g := runtime.NumCPU()
	sem := make(chan struct{}, g)

	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		sem <- struct{}{}
		go func(w int) {
			defer func() {
				wg.Done()
				<-sem
			}()
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


