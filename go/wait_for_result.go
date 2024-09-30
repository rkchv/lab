package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan string)

	go func() {
		time.Sleep(time.Second)
		ch <- "paper"
		fmt.Println("worker : sent signal")
	}()

	res := <-ch
	fmt.Println("manager : recieved signal :", res)

	time.Sleep(time.Second)
}
