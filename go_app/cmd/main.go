package main

import (
	"fmt"
	"net/http"
	"sync"
)

type SharedMemory struct {
	data int
	mu   sync.Mutex
}

func main() {
	http.HandleFunc("/do_work", do_work)
	http.ListenAndServe("0.0.0.0:7000", nil)
}

func do_work(w http.ResponseWriter, req *http.Request) {
	Iter := 1000
	sharedMemory := SharedMemory{data: 0}

	var wg sync.WaitGroup
	wg.Add(Iter)

	resultChan := make(chan int)

	for i := 0; i < Iter; i++ {
		go func() {
			result := updateSharedMemory(&sharedMemory)
			resultChan <- result
			wg.Done()
		}()
	}

	// Start a goroutine to collect results from other goroutines
	go func() {
		for result := range resultChan {
			fmt.Println("Result from goroutine:", result)
		}
	}()

	wg.Wait()

	close(resultChan)

	fmt.Println("Final shared memory value:", sharedMemory.data)
	fmt.Fprintf(w, "Done processing")
}

func updateSharedMemory(sharedMemory *SharedMemory) int {
	sharedMemory.mu.Lock()
	defer sharedMemory.mu.Unlock()

	sharedMemory.data++

	return sharedMemory.data
}
