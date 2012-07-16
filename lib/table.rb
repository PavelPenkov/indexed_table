require 'condition_builder'
require 'index'

class Table
  include Enumerable
  attr_reader :rows

  def initialize(*args)
    @rows = []
    @indexes = []
  end

  def query(&block)
    pr = Predicate.new(&block)
    if ix = find_index(pr)
      ix.select(pr)
    else
      @rows.select{|row| pr.call(row)}
    end
  end

  def insert(row)
    @rows << row
    @indexes.each{|i| i.insert row}
  end

  def create_index(*columns)
    @indexes << Index.new(*columns)
  end

  def find_index(predicate)
    columns = predicate.columns.uniq
    # puts columns.inspect
    @indexes.find do |ix|
      columns.permutation.any?{|vec| vec.head?(ix.columns)} # That's exactly why we have it, right?
    end
  end

  def indexes
    @indexes
  end

  def each(&block)
    if block_given?
      @rows.each {|row| yield row}
    else
      Enumerator.new do |yielder|
        @rows.each {|row| yielder.yield row}
      end
    end
  end
end
