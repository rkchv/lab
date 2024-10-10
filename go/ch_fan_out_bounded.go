package main

import (
	"fmt"
	"runtime"
	"sync"
)

// looks like

func main() {
	work := []string{"one", "L", "super", "hophey", "john", "celtic", "block"}
	wg := sync.WaitGroup{}

	g := runtime.NumCPU()
	wg.Add(g)

	ch := make(chan string, g)

	for i := 0; i < g; i++ {
		go func() {
			defer wg.Done()
			for v := range ch {
				fmt.Println("Done:", v)
			}
		}()
	}

	for _, v := range work {
		ch <- v
	}
	close(ch)

	wg.Wait()
}


