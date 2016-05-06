# Graph

A graph is something that looks like this:

![A graph](pics/Graph2.png)

In computer-science lingo, a graph is a set of *vertices* paired with a set of *edges*. The vertices are the round things and the edges are the lines between them. Edges connect a vertex to other vertices.

> **Note:** Vertices are sometimes also called "nodes" and edges are also called "links".

For example, a graph can represent a social network. Each person is a vertex, and people who know each other are connected by edges. A somewhat historically inaccurate example:

![Social network](pics/SocialNetwork.png)

Graphs come in all kinds of shapes and sizes. The edges can have a *weight*, where a positive or negative numeric value is assigned to each edge. Consider an example of a graph representing airplane flights. Cities can be vertices, and flights can be edges. Then an edge weight could describe flight time or the price of a ticket.

![Airplane flights](pics/Flights.png)

With this hypothetical airline, flying from San Francisco to Moscow is cheapest by going through New York.

Edges can also be *directed*. So far the edges you've seen have been undirected, so if Ada knows Charles, then Charles also knows Ada. A directed edge, on the other hand, implies a one-way relationship. A directed edge from vertex X to vertex Y connects X to Y, but *not* Y to X.

Continuing from the flights example, a directed edge from San Francisco to Juneau in Alaska would indicate that there is a flight from San Francisco to Juneau, but not from Juneau to San Francisco (I suppose that means you're walking back).

![One-way flights](pics/FlightsDirected.png)

The following are also graphs:

![Tree and linked list](pics/TreeAndList.png)

On the left is a [tree](../Tree/) structure, on the right a [linked list](../Linked List/). Both can be considered graphs, but in a simpler form. After all, they have vertices (nodes) and edges (links).

The very first graph I showed you contained *cycles*, where you can start off at a vertex, follow a path, and come back to the original vertex. A tree is a graph without such cycles.

Another very common type of graph is the *directed acyclic graph* or DAG:

![DAG](pics/DAG.png)

Like a tree this does not have any cycles in it (no matter where you start, there is no path back to the starting vertex), but unlike a tree the edges are directional and the shape doesn't necessarily form a hierarchy.

## Why use graphs?

Maybe you're shrugging your shoulders and thinking, what's the big deal? Well, it turns out that graphs are an extremely useful data structure.

If you have some programming problem where you can represent some of your data as vertices and some of it as edges between those vertices, then you can draw your problem as a graph and use well-known graph algorithms such as [breadth-first search](../Breadth-First Search/) or [depth-first search](../Depth-First Search) to find a solution. 

For example, let's say you have a list of tasks where some tasks have to wait on others before they can begin. You can model this using an acyclic directed graph:

![Tasks as a graph](pics/Tasks.png)

Each vertex represents a task. Here, an edge between two vertices means that the source task must be completed before the destination task can start. So task C cannot start before B and D are finished, and B nor D can start before A is finished.

Now that the problem is expressed using a graph, you can use a depth-first search to perform a [topological sort](../Topological Sort/). This will put the tasks in an optimal order so that you minimize the time spent waiting for tasks to complete. (One possible order here is A, B, D, E, C, F, G, H, I, J, K.)

Whenever you're faced with a tough programming problem, ask yourself, "how can I express this problem using a graph?" Graphs are all about representing relationships between your data. The trick is in how you define "relationship".

If you're a musician you might appreciate this graph:

![Chord map](pics/ChordMap.png)

The vertices are chords from the C major scale. The edges -- the relationships between the chords -- represent how [likely one chord is to follow another](http://mugglinworks.com/chordmaps/genmap.htm). This is a directed graph, so the direction of the arrows shows how you can go from one chord to the next. It's also a weighted graph, where the weight of the edges -- portrayed here by line thickness -- shows a strong relationship between two chords. As you can see, a G7-chord is very likely to be followed by a C chord, and much less likely by a Am chord.

You're probably already using graphs without even knowing it. Your data model is also a graph (from Apple's Core Data documentation):

![Core Data model](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreDataVersioning/Art/recipe_version2.0.jpg)

Another common graph that's used by programmers is the state machine, where edges depict the conditions for transitioning between states. Here is a state machine that models my cat:

![State machine](pics/StateMachine.png)

Graphs are awesome. Facebook made a fortune from their social graph. If you're going to learn any data structure, it should be the graph and the vast collection of standard graph algorithms.

## Vertices and edges, oh my!

In theory, a graph is just a bunch of vertex objects and a bunch of edge objects. But how do you describe these in code?

There are two main strategies: adjacency list and adjacency matrix.

**Adjacency List.** In an adjacency list implementation, each vertex stores a list of edges that originate from that vertex. For example, if vertex A has an edge to vertices B, C, and D, then vertex A would have a list containing 3 edges.

![Adjacency list](pics/AdjacencyList.png)

The adjacency list describes outgoing edges. A has an edge to B but B does not have an edge back to A, so A does not appear in B's adjacency list.

**Adjacency Matrix.** In an adjacency matrix implementation, a matrix with rows and columns representing vertices stores a weight to indicate if vertices are connected, and by what weight. For example, if there is a directed edge of weight 5.6 from vertex A to vertex B, then the entry with row for vertex A, column for vertex B would have value 5.6:

![Adjacency matrix](pics/AdjacencyMatrix.png)

So which one should you use? Most of the time, the adjacency list is the right approach. What follows is a more detailed comparison between the two.

Let *V* be the number of vertices in the graph, and *E* the number of edges.  Then we have:

| Operation       | Adjacency List | Adjacency Matrix |
|-----------------|----------------|------------------|
| Storage Space   | O(V + E)       | O(V^2)           |
| Add Vertex      | O(1)           | O(V^2)           |
| Add Edge        | O(1)           | O(1)             |
| Check Adjacency | O(V)           | O(1)             |

"Checking adjacency" means that we try to determine that a given vertex is an immediate neighbor of another vertex. The time to check adjacency for an adjacency list is **O(V)**, because in the worst case a vertex is connected to *every* other vertex.

In the case of a *sparse* graph, where each vertex is connected to only a handful of other vertices, an adjacency list is the best way to store the edges. If the graph is *dense*, where each vertex is connected to most of the other vertices, then a matrix is preferred.

We'll show you sample implementations of both adjacency list and adjacency matrix.

## The code: adjacency list

The adjacency list for each vertex consists of `Edge` objects:

```swift
public struct Edge<T> {
  public let from: Vertex<T>
  public let to: Vertex<T>
  public let weight: Double
}
```

This struct describes the "from" and "to" vertices and a weight value. Note that an `Edge` object is always directed, a one-way connection (shown as arrows in the illustrations above). If you want the connection to go both ways, you also need to add an `Edge` object to the adjacency list of the destination vertex.

The `Vertex` looks like this:

```swift
private var uniqueIDCounter = 0

public struct Vertex<T> {
  public var data: T
  public let uniqueID: Int
  
  private(set) public var edges: [Edge<T>] = []
  
  public init(data: T) {
    self.data = data
    uniqueID = uniqueIDCounter
    uniqueIDCounter += 1
  }
```

It stores arbitrary data with a generic type `T`. The vertex also has a unique identifier, which we use to compare equality later. The `edges` array is the adjacency list.

To connect two vertices using a directed edge:

```swift
  public mutating func connectTo(destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
    edges.append(Edge(from: self, to: destinationVertex, weight: weight))
  }
```

As mentioned, to create an undirected edge you need to make two directed edges:

```
  public mutating func connectBetween(inout otherVertex: Vertex<T>, withWeight weight: Double = 0) {
    connectTo(otherVertex, withWeight: weight)
    otherVertex.connectTo(self, withWeight: weight)
  }
```

There is also a method for checking adjacency, i.e. to determine if there is an edge between two vertices:

```swift
  public func edgeTo(otherVertex: Vertex<T>) -> Edge<T>? {
    for e in edges where e.to.uniqueID == otherVertex.uniqueID {
      return e
    }
    return nil
  }
```

Here's an example of a very simple graph:

![Demo](pics/Demo1.png)

This is how you'd create it using `Vertex` objects:

```swift
var v1 = Vertex(data: 1)
var v2 = Vertex(data: 2)
var v3 = Vertex(data: 3)
var v4 = Vertex(data: 4)
var v5 = Vertex(data: 5)

v1.connectTo(v2, withWeight: 1.0)
v2.connectTo(v3, withWeight: 1.0)
v3.connectTo(v4, withWeight: 4.5)
v4.connectTo(v1, withWeight: 2.8)
v2.connectTo(v5, withWeight: 3.2)
```

> **Note:** There are many, many ways to implement graphs. The code given here is just one possible implementation. You probably want to tailor the graph code to each individual problem you're trying to solve. For instance, your edges may not need a `weight` property, or you may not have the need to distinguish between directed and undirected edges.

## The code: adjacency matrix

We'll keep track of the adjacency matrix in a two-dimensional `[[Double?]]` array. An entry of `nil` indicates no edge, while any other value indicates an edge of the given weight.

```swift
public struct Graph<T> {
  private var adjacencyMatrix: [[Double?]] = []
}
```

If `adjacencyMatrix[i][j]` is not nil, then there is an edge from vertex `i` to vertex `j`.

To index into the matrix using vertices, we give each `Vertex` a unique integer index:

```swift
public struct Vertex<T> {
  public var data: T
  private let index: Int
}
```

To create a new vertex, the graph must resize the matrix:

```swift
  public mutating func createVertex(data: T) -> Vertex<T> {
    let vertex = Vertex(data: data, index: adjacencyMatrix.count)
    
    // Expand each existing row to the right one column.
    for i in 0..<adjacencyMatrix.count {
      adjacencyMatrix[i].append(nil)
    }
    
    // Add one new row at the bottom.
    let newRow = [Double?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
    adjacencyMatrix.append(newRow)

    return vertex
  }
```

Once we have the matrix properly configured, adding edges and querying for edges are simple indexing operations into the matrix:

```swift
public mutating func connect(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
  adjacencyMatrix[sourceVertex.index][destinationVertex.index] = weight
}

public func weightFrom(sourceVertex: Vertex<T>, toDestinationVertex: Vertex<T>) -> Double? {
  return adjacencyMatrix[sourceVertex.index][toDestinationVertex.index]
}
```

You use these objects as follows:

```swift
var graph = Graph<Int>()
let v1 = graph.createVertex(1)
let v2 = graph.createVertex(2)
let v3 = graph.createVertex(3)
let v4 = graph.createVertex(4)
let v5 = graph.createVertex(5)

graph.connect(v1, to: v2, withWeight: 1.0)
graph.connect(v2, to: v3, withWeight: 1.0)
graph.connect(v3, to: v4, withWeight: 4.5)
graph.connect(v4, to: v1, withWeight: 2.8)
graph.connect(v2, to: v5, withWeight: 3.2)
```

Then the adjacency matrix looks like this:

	[[nil, 1.0, nil, nil, nil]    v1
	 [nil, nil, 1.0, nil, 3.2]    v2
	 [nil, nil, nil, 4.5, nil]    v3
	 [2.8, nil, nil, nil, nil]    v4
	 [nil, nil, nil, nil, nil]]   v5
	 
	  v1   v2   v3   v4   v5


## See also

This article described what a graph is and how you can implement the basic data structure. But we have many more articles on practical uses for graphs, so check those out too!

*Written by Donald Pinckney and Matthijs Hollemans*
