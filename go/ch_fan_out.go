package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	numWorkers := 100
	ch := make(chan string, numWorkers)

	for w := 0; w < numWorkers; w++ {
		go func(w int) {
			duration := time.Duration(rand.Intn(100)) * time.Millisecond
			time.Sleep(duration)
			ch <- "take this cake"
		}(w)
	}

	for numWorkers > 0 {
		p := <-ch
		numWorkers -= 1
		fmt.Println(p)
	}

}
