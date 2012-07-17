# require 'java'
require 'rbtree'

class Index
  def initialize(*columns)
    @columns = columns.clone
    # @tree = java.util.TreeMap.new
    @tree = MultiRBTree.new
    @lower_bound = Array.new(columns.length)
    @upper_bound = Array.new(columns.length)
  end

  def insert(row)
    key = key(row)
    key.each_with_index do |x, i|
      @lower_bound[i] = x if @lower_bound[i] == nil or @lower_bound[i] > x
      @upper_bound[i] = x if @upper_bound[i] == nil or  @upper_bound[i] < x
    end
    @tree.store(key, row)
  end

  def tree
    @tree
  end

  def columns
    @columns.clone
  end

  def select(predicate)
    from_key = @lower_bound.clone
    to_key = @upper_bound.clone
    predicate.conditions.each do |cond|
      i = @columns.index cond.column
      case cond
      when EqCondition then
        from_key[i] = cond.arg
        to_key[i] = cond.arg
      when GtCondition, GteCondition then
        from_key[i] = cond.arg
      when LteCondition, LtCondition then
        to_key[i] = cond.arg
      when BetweenCondition then
        from_key[i] = cond.min
        to_key[i] = cond.max
      end
    end
    # puts "from_key: #{from_key.inspect}, to_key: #{to_key.inspect}"
    if (from_key <=> to_key) <= 0 # Java TreeMap fix
      # map_to_array(@tree.subMap(from_key, true, to_key, true))
      @tree.bound(from_key, to_key).map{|k,v| v}
    else
      []
    end
  end

  def key(row)
    @columns.map{|c| row[c]}
  end

  def all
    @tree.values.flatten
  end

  private

  def map_to_array(map)
    map.map{|k,v| v}.flatten
  end
end
