package main

import (
	"fmt"
	"sync"
)

func main() {
	ch := make(chan string)
	wg := sync.WaitGroup{}

	wg.Add(1)
	go func() {
		defer wg.Done()
		v := <-ch
		fmt.Println("task from manager Vasya:", v)
	}()

	ch <- "do it brother"

	wg.Wait()

	fmt.Print("worker brother did it")
}
