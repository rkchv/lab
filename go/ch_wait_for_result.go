package main

import (
	"fmt"
	"time"
)

/*
unbuffered channel provides a guarantee that
send side waiting for rec'd side
*/

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
