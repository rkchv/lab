package main

import "fmt"

func main() {
	cap := 100
	ch := make(chan string, cap)

	go func() {
		for p := range ch {
			fmt.Println("worker recieved a signal:", p)
		}
	}()

	work := 2000
	for i := 0; i < work; i++ {
		select {
		case ch <- "paper":
			fmt.Println("manager send signal")
		default:
			fmt.Println("drop...")
		}
	}

	close(ch)
}
