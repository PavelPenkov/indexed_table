class Builder
  # Ruby 1.8.7 fix
  instance_methods.each do |m|
    undef_method(m)  unless m.match(/^__|instance_eval/)
  end

  def initialize
    @builders = []
  end

  def method_missing(name, *args)
    builder = ColumnConditionBuilder.new(name.to_sym)
    @builders << builder
    builder
  end

  def column_conditions
    @builders.map{|b| b.condition}
  end
end

class Predicate
  def initialize(&block)
    @builder = Builder.new
    @builder.instance_eval(&block)
  end

  def conditions
    @builder.column_conditions
  end

  def columns
    @builder.column_conditions.map{|c| c.column}
  end

  def call(row)
    conditions.reduce(true){|result, cond| result && cond.call(row) }
  end

  def condition_for(column)
    conditions.select{|c| c.column == column}.first
  end
end

class Condition
  attr_reader :column, :arg

  def initialize(column, arg)
    @column, @arg = column, arg
  end
end

class EqCondition < Condition
  def initialize(column, arg)
    super
  end

  def call(row)
    row[column] == arg
  end

  def to_s
    "#{column} == #{arg}"
  end
end

class GteCondition < Condition
  def initialize(column, arg)
    super
  end

  def call(row)
    row[column] >= arg
  end

  def to_s
    "#{column} >= #{arg}"
  end
end

class LteCondition < Condition
  def initialize(column, arg)
    super
  end

  def call(row)
    row[column] <= arg
  end

  def to_s
    "#{column} <= #{arg}"
  end
end

class GtCondition < Condition
  def initialize(column, arg)
    super
  end

  def call(row)
    row[column] > arg
  end

  def to_s
    "#{@column} > #{@arg}"
  end
end

class LtCondition < Condition
  def initialize(column, arg)
    super
  end

  def call(row)
    row[column] < arg
  end

  def to_s
    "#{column} < #{arg}"
  end
end

class BetweenCondition < Condition
  attr_reader :min, :max

  def initialize(column, min, max)
    @column, @min, @max = column, min, max
  end

  def call
    row[column].between(@min, @max)
  end

  def to_s
    "#{@column}.between?(#{@min}, #{@max})"
  end
end

class ColumnConditionBuilder
  def initialize(column)
    @column = column
  end

  def ==(arg)
    @condition = EqCondition.new(@column, arg)
  end

  def <(arg)
    @condition = LtCondition.new(@column, arg)
  end

  def >(arg)
    @condition = GtCondition.new(@column, arg)
  end

  def >=(arg)
    @condition = GteCondition.new(@column, arg)
  end

  def <=(arg)
    @condition = LteCondition.new(@column, arg)
  end

  def between?(min, max)
    @condition = BetweenCondition.new(@column, min, max)
  end

  def condition
    @condition
  end
end
