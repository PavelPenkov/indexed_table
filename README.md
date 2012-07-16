indexed_table
-------------
Задача десять раз решена создателями СУБД, соответственно, я написал in-memory таблицу с индексами. Свое красно-черное дерево писать не стал, взял гем rbtree, написал простенький DSL для создания запросов (его возможности ограничены возможностями backing container, если взять TreeMap из Явы, то можно было бы реализовать операторы "строго больше" и "строго меньше"). Индекс берется первый подходящий, если нет ни  одного индекса, полностью подходящего для выполнения запроса, то сразу table scan. Все это дело достаточно хрупкое (тестовое задание, все-таки).

Использование
-------------
```ruby
    table = Table.new
    table.create_index :x, :y

    100.times do |i|
      100.times do |j|
        table.insert({:x => i, :y => j})
      end
    end

    res = table.query do # will use index
      y <= 42
      x >= 42
    end

    res = table.query { x == 42 } # will use index

    res = table.query { y == 42 } # will use table scan
```

Тесты
-----
Все, кроме производительности `rake spec`

Все, включая производительность `perf=1 rake spec`

Производительность
------------------
(на дохлой виртуалке)

Insert without index: 0.007338149

Query without index: 4.524136761

Query without index 2 conditions: 5.715206423

Raw iteration: 0.864453755

Insert with simple index: 0.161951593

Query with simple index: 0.00581417

Insert with composite index: 0.573067718

Query composite index 2 conditions: 0.534834588

Query composite index first part condition: 0.011736373
