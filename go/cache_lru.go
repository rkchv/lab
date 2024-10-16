package cache

import (
	"container/list"
	"sync"
)

type Item struct {
	Key   string
	Value any
}

type LRU struct {
	capacity int
	queue    *list.List
	mu       *sync.RWMutex
	items    map[string]*list.Element
}

func NewLRU(capacity int) *LRU {
	return &LRU{
		capacity: capacity,
		queue:    list.New(),
		mu:       new(sync.RWMutex),
		items:    make(map[string]*list.Element),
	}
}

func (c *LRU) Add(key string, value any) bool {
	c.mu.Lock()
	defer c.mu.Unlock()

	if element, exists := c.items[key]; exists {
		c.queue.MoveToFront(element)
		element.Value.(*Item).Value = value
		return true
	}

	if c.queue.Len() == c.capacity {
		c.pop()
	}

	item := &Item{
		Key:   key,
		Value: value,
	}

	element := c.queue.PushFront(item)
	c.items[item.Key] = element

	return true
}

func (c *LRU) Get(key string) any {
	c.mu.RLock()
	defer c.mu.RUnlock()

	element, exists := c.items[key]
	if !exists {
		return nil
	}

	c.queue.MoveToFront(element)
	return element.Value.(*Item).Value
}

func (c *LRU) Remove(key string) bool {
	c.mu.Lock()
	defer c.mu.Unlock()
	if val, found := c.items[key]; found {
		c.deleteItem(val)
	}

	return true
}

func (c *LRU) Len() int {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return len(c.items)
}

func (c *LRU) pop() {
	if element := c.queue.Back(); element != nil {
		c.deleteItem(element)
	}
}

func (c *LRU) deleteItem(element *list.Element) {
	item := c.queue.Remove(element).(*Item)
	delete(c.items, item.Key)
}
