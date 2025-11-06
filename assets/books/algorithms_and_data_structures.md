# 算法与数据结构精要

## 前言

算法和数据结构是计算机科学的基础。掌握它们对于编写高效、可维护的代码至关重要。

---

## 第1章：算法基础

### 什么是算法？

算法是解决特定问题的一系列明确步骤。好的算法应该具备以下特征：

- **正确性**：对合法输入产生正确输出
- **效率性**：时间和空间资源使用合理
- **可读性**：易于理解和实现
- **健壮性**：能处理边界情况

### 算法分析

#### 时间复杂度

描述算法运行时间随输入规模增长的趋势。

```python
# O(1) - 常数时间
def get_first_element(arr):
    return arr[0] if arr else None

# O(n) - 线性时间
def find_max(arr):
    max_val = arr[0]
    for num in arr:
        if num > max_val:
            max_val = num
    return max_val

# O(n²) - 平方时间
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

# O(log n) - 对数时间
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```

#### 空间复杂度

描述算法所需的额外存储空间。

```python
# O(1) - 常数空间
def reverse_in_place(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1

# O(n) - 线性空间
def reverse_copy(arr):
    return arr[::-1]  # 创建新数组
```

---

## 第2章：基础数据结构

### 数组 (Array)

数组是最基本的数据结构，提供固定大小的连续内存空间。

```python
# 动态数组实现
class DynamicArray:
    def __init__(self, capacity=1):
        self.capacity = capacity
        self.size = 0
        self.array = [None] * capacity

    def append(self, item):
        if self.size >= self.capacity:
            self._resize(2 * self.capacity)
        self.array[self.size] = item
        self.size += 1

    def _resize(self, new_capacity):
        new_array = [None] * new_capacity
        for i in range(self.size):
            new_array[i] = self.array[i]
        self.array = new_array
        self.capacity = new_capacity

    def get(self, index):
        if 0 <= index < self.size:
            return self.array[index]
        raise IndexError("Index out of bounds")
```

### 链表 (Linked List)

链表由节点组成，每个节点包含数据和指向下一个节点的指针。

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return

        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def find(self, data):
        current = self.head
        while current:
            if current.data == data:
                return current
            current = current.next
        return None

    def delete(self, data):
        if not self.head:
            return False

        if self.head.data == data:
            self.head = self.head.next
            return True

        current = self.head
        while current.next:
            if current.next.data == data:
                current.next = current.next.next
                return True
            current = current.next
        return False
```

### 栈 (Stack)

栈是后进先出(LIFO)的数据结构。

```python
class Stack:
    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if not self.is_empty():
            return self.items.pop()
        raise IndexError("Stack is empty")

    def peek(self):
        if not self.is_empty():
            return self.items[-1]
        raise IndexError("Stack is empty")

    def is_empty(self):
        return len(self.items) == 0

# 应用：括号匹配
def is_balanced_parentheses(s):
    stack = Stack()
    pairs = {')': '(', ']': '[', '}': '{'}

    for char in s:
        if char in '({[':
            stack.push(char)
        elif char in ')}]':
            if stack.is_empty() or stack.pop() != pairs[char]:
                return False

    return stack.is_empty()
```

### 队列 (Queue)

队列是先进先出(FIFO)的数据结构。

```python
from collections import deque

class Queue:
    def __init__(self):
        self.items = deque()

    def enqueue(self, item):
        self.items.append(item)

    def dequeue(self):
        if not self.is_empty():
            return self.items.popleft()
        raise IndexError("Queue is empty")

    def is_empty(self):
        return len(self.items) == 0

# 应用：广度优先搜索
from collections import deque

def bfs(graph, start, target):
    visited = set()
    queue = Queue()
    queue.enqueue(start)
    visited.add(start)

    while not queue.is_empty():
        current = queue.dequeue()

        if current == target:
            return True

        for neighbor in graph[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.enqueue(neighbor)

    return False
```

---

## 第3章：树结构

### 二叉树

二叉树是每个节点最多有两个子节点的树结构。

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class BinaryTree:
    def __init__(self):
        self.root = None

    def insert(self, val):
        if not self.root:
            self.root = TreeNode(val)
            return

        self._insert_recursive(self.root, val)

    def _insert_recursive(self, node, val):
        if val < node.val:
            if not node.left:
                node.left = TreeNode(val)
            else:
                self._insert_recursive(node.left, val)
        else:
            if not node.right:
                node.right = TreeNode(val)
            else:
                self._insert_recursive(node.right, val)

    # 中序遍历 - 左中右
    def inorder_traversal(self):
        result = []
        self._inorder_recursive(self.root, result)
        return result

    def _inorder_recursive(self, node, result):
        if node:
            self._inorder_recursive(node.left, result)
            result.append(node.val)
            self._inorder_recursive(node.right, result)

    # 前序遍历 - 中左右
    def preorder_traversal(self):
        result = []
        self._preorder_recursive(self.root, result)
        return result

    def _preorder_recursive(self, node, result):
        if node:
            result.append(node.val)
            self._preorder_recursive(node.left, result)
            self._preorder_recursive(node.right, result)

    # 后序遍历 - 左右中
    def postorder_traversal(self):
        result = []
        self._postorder_recursive(self.root, result)
        return result

    def _postorder_recursive(self, node, result):
        if node:
            self._postorder_recursive(node.left, result)
            self._postorder_recursive(node.right, result)
            result.append(node.val)
```

### 二叉搜索树 (BST)

二叉搜索树保持有序性：左子树小于根节点，右子树大于根节点。

```python
class BinarySearchTree:
    def __init__(self):
        self.root = None

    def search(self, val):
        return self._search_recursive(self.root, val)

    def _search_recursive(self, node, val):
        if not node or node.val == val:
            return node

        if val < node.val:
            return self._search_recursive(node.left, val)
        else:
            return self._search_recursive(node.right, val)

    def insert(self, val):
        self.root = self._insert_recursive(self.root, val)

    def _insert_recursive(self, node, val):
        if not node:
            return TreeNode(val)

        if val < node.val:
            node.left = self._insert_recursive(node.left, val)
        else:
            node.right = self._insert_recursive(node.right, val)

        return node

    def delete(self, val):
        self.root = self._delete_recursive(self.root, val)

    def _delete_recursive(self, node, val):
        if not node:
            return None

        if val < node.val:
            node.left = self._delete_recursive(node.left, val)
        elif val > node.val:
            node.right = self._delete_recursive(node.right, val)
        else:
            # 找到要删除的节点
            if not node.left:
                return node.right
            if not node.right:
                return node.left

            # 有两个子节点：找到右子树的最小值
            min_larger_node = self._find_min(node.right)
            node.val = min_larger_node.val
            node.right = self._delete_recursive(node.right, min_larger_node.val)

        return node

    def _find_min(self, node):
        while node.left:
            node = node.left
        return node
```

### 堆 (Heap)

堆是一种特殊的树结构，满足堆属性。

```python
class MaxHeap:
    def __init__(self):
        self.heap = []

    def insert(self, val):
        self.heap.append(val)
        self._heapify_up(len(self.heap) - 1)

    def _heapify_up(self, index):
        parent = (index - 1) // 2
        if index > 0 and self.heap[index] > self.heap[parent]:
            self.heap[index], self.heap[parent] = self.heap[parent], self.heap[index]
            self._heapify_up(parent)

    def extract_max(self):
        if not self.heap:
            return None

        max_val = self.heap[0]
        self.heap[0] = self.heap[-1]
        self.heap.pop()
        self._heapify_down(0)
        return max_val

    def _heapify_down(self, index):
        left_child = 2 * index + 1
        right_child = 2 * index + 2
        largest = index

        if (left_child < len(self.heap) and
            self.heap[left_child] > self.heap[largest]):
            largest = left_child

        if (right_child < len(self.heap) and
            self.heap[right_child] > self.heap[largest]):
            largest = right_child

        if largest != index:
            self.heap[index], self.heap[largest] = self.heap[largest], self.heap[index]
            self._heapify_down(largest)

# 应用：堆排序
def heap_sort(arr):
    max_heap = MaxHeap()
    for num in arr:
        max_heap.insert(num)

    sorted_arr = []
    while max_heap.heap:
        sorted_arr.append(max_heap.extract_max())

    return sorted_arr[::-1]  # 返回升序排列
```

---

## 第4章：排序算法

### 快速排序

```python
def quick_sort(arr):
    if len(arr) <= 1:
        return arr

    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]

    return quick_sort(left) + middle + quick_sort(right)

# 原地快速排序
def quick_sort_inplace(arr, low=0, high=None):
    if high is None:
        high = len(arr) - 1

    if low < high:
        pivot_index = partition(arr, low, high)
        quick_sort_inplace(arr, low, pivot_index - 1)
        quick_sort_inplace(arr, pivot_index + 1, high)

def partition(arr, low, high):
    pivot = arr[high]
    i = low - 1

    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]

    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1
```

### 归并排序

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

---

## 第5章：搜索算法

### 深度优先搜索 (DFS)

```python
def dfs(graph, start, visited=None):
    if visited is None:
        visited = set()

    visited.add(start)
    print(start, end=' ')

    for neighbor in graph[start]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)

    return visited

# 图表示
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}
```

### 广度优先搜索 (BFS)

```python
from collections import deque

def bfs(graph, start):
    visited = set()
    queue = deque([start])
    visited.add(start)

    while queue:
        node = queue.popleft()
        print(node, end=' ')

        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return visited
```

### Dijkstra算法（最短路径）

```python
import heapq

def dijkstra(graph, start):
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    pq = [(0, start)]

    while pq:
        current_distance, current_node = heapq.heappop(pq)

        if current_distance > distances[current_node]:
            continue

        for neighbor, weight in graph[current_node].items():
            distance = current_distance + weight

            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(pq, (distance, neighbor))

    return distances

# 图的邻接表表示
weighted_graph = {
    'A': {'B': 5, 'C': 1},
    'B': {'A': 5, 'C': 2, 'D': 1},
    'C': {'A': 1, 'B': 2, 'D': 4, 'E': 8},
    'D': {'B': 1, 'C': 4, 'E': 3, 'F': 6},
    'E': {'C': 8, 'D': 3},
    'F': {'D': 6}
}
```

---

## 总结

算法和数据结构是编程的基础：

1. **选择合适的数据结构**：根据操作需求选择
2. **分析算法复杂度**：确保效率满足要求
3. **实践编程**：通过练习加深理解
4. **持续学习**：学习新的算法和优化技术

记住：理解原理比记忆代码更重要。掌握了核心思想，就能灵活应用解决各种问题。

---

*更多算法和数据结构内容持续更新中...*