package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

type Task struct {
	ID      int
	Payload int
}

func worker(tasksChan <-chan Task, resultChan chan<- Task, wg *sync.WaitGroup) {
	defer wg.Done()

	for v := range tasksChan {
		duration := time.Duration(rand.Intn(100)) * time.Millisecond
		time.Sleep(duration)
		resultChan <- v
	}
}

func main() {
	numTasks := 10
	numWorkers := 3

	tasksChan := make(chan Task, 100)
	resultChan := make(chan Task, 100)

	wg := sync.WaitGroup{}

	wg.Add(1)
	go func() {
		defer wg.Done()
		defer close(tasksChan)

		for i := 0; i < numTasks; i++ {
			tasksChan <- Task{ID: i, Payload: rand.Int()}
		}
	}()

	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go worker(tasksChan, resultChan, &wg)
	}

	go func() {
		wg.Wait()
		close(resultChan)
	}()

	for v := range resultChan {
		fmt.Println(v)
	}

}
