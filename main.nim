import tables, sequtils, deques

type
    Symbol = enum Triangle, Square, Circle
    Cell = object
        id: int
        hasTriangle: bool
        neighbours: array[Triangle..Circle, int]

proc `$`(cell: Cell): string =
    result = "(id: " & $cell.id & ",\n" &
    "hasTriangle: " & $cell.hasTriangle & ",\n" &
    "neighbours[Triangle]: " & $(cell.neighbours[Triangle]) & ",\n" &
    "neighbours[Square]: " & $cell.neighbours[Square] & ",\n" &
    "neighbours[Circle]: " & $cell.neighbours[Circle] & ")"

proc isCompleted(state: Table[int, Cell]): bool = toSeq(state.values).filterIt(it.hasTriangle).len == 1

proc initializeLevel4(): Table[int, Cell] = 
    # Usado para teste
    var cell1 = Cell(hasTriangle: true, id: 1)
    var cell2 = Cell(hasTriangle: true, id: 2)
    var cell3 = Cell(hasTriangle: true, id: 3)
    cell1.neighbours[Triangle] = 0
    cell1.neighbours[Square] = 2
    cell1.neighbours[Circle] = 2
    cell2.neighbours[Triangle] = 3
    cell2.neighbours[Square] = 1
    cell2.neighbours[Circle] = 0
    cell3.neighbours[Triangle] = 2
    cell3.neighbours[Square] = 0
    cell3.neighbours[Circle] = 0
    result.add(1, cell1)
    result.add(2, cell2)
    result.add(3, cell3)

proc initializeLevel20(): Table[int, Cell] = 
    var cell1 = Cell(hasTriangle: true, id: 1)
    var cell2 = Cell(hasTriangle: true, id: 2)
    var cell3 = Cell(hasTriangle: true, id: 3)
    var cell4 = Cell(hasTriangle: true, id: 4)
    var cell5 = Cell(hasTriangle: true, id: 5)
    cell1.neighbours[Triangle] = 0
    cell1.neighbours[Square] = 0
    cell1.neighbours[Circle] = 3
    cell2.neighbours[Triangle] = 3
    cell2.neighbours[Square] = 0
    cell2.neighbours[Circle] = 0
    cell3.neighbours[Triangle] = 2
    cell3.neighbours[Square] = 0
    cell3.neighbours[Circle] = 4
    cell4.neighbours[Triangle] = 5
    cell4.neighbours[Square] = 1
    cell4.neighbours[Circle] = 3
    cell5.neighbours[Triangle] = 4
    cell5.neighbours[Square] = 0
    cell5.neighbours[Circle] = 0
    result.add(1, cell1)
    result.add(2, cell2)
    result.add(3, cell3)
    result.add(4, cell4)
    result.add(5, cell5)

proc changeState(state: Table[int, Cell], symbol: Symbol): Table[int, Cell] =
    result = state
    for id in state.keys:
        result[id].hasTriangle = false
    for cell in state.values:
        if cell.neighbours[symbol] != 0:
            result[cell.neighbours[symbol]].hasTriangle = state[cell.id].hasTriangle or result[cell.neighbours[symbol]].hasTriangle
        else:
            result[cell.id].hasTriangle = result[cell.id].hasTriangle or state[cell.id].hasTriangle

proc bfs(state: Table[int, Cell], maxDepth = 20): seq[Symbol] =
    var queue = initDeque[(Table[int, Cell], seq[Symbol])]()
    queue.addFirst((state.changeState(Square), @[Square]))
    queue.addFirst((state.changeState(Circle), @[Circle]))
    var i = 0
    while queue.len > 0:
        i += 1
        let now = queue.popLast()
        let currentState = now[0]
        let currentPath = now[1]
        if currentPath.len > maxDepth:
            echo i
            return @[]
        if currentState.isCompleted():
            echo i
            return currentPath
        let newStateTriangle = currentState.changeState(Triangle)
        let newStateSquare = currentState.changeState(Square)
        let newStateCircle = currentState.changeState(Circle)
        if toSeq(currentState.values).mapIt((it.id, it.hasTriangle)) != toSeq(newStateTriangle.values).mapIt((it.id, it.hasTriangle)):
            queue.addFirst((newStateTriangle, currentPath & @[Triangle]))
        if toSeq(currentState.values).mapIt((it.id, it.hasTriangle)) != toSeq(newStateSquare.values).mapIt((it.id, it.hasTriangle)):
            queue.addFirst((newStateSquare, currentPath & @[Square]))
        if toSeq(currentState.values).mapIt((it.id, it.hasTriangle)) != toSeq(newStateCircle.values).mapIt((it.id, it.hasTriangle)):
            queue.addFirst((newStateCircle, currentPath & @[Circle]))
    echo i

let state = initializeLevel20()

echo bfs(state)
