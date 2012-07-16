class Tuple
  include Comparable

  def initialize(*args)
    @values = args.clone
  end

  def [](i)
    @values[i]
  end

  def size
    @values.length
  end

  alias :length :size

  def <=>(anOther)
    raise ArgumentError, "Can't compare Tuple with #{anOther.class}" unless anOther.is_a?(Tuple)

    n = [size, anOther.size].max

    n.times do |i|
      if @values[i] == nil && anOther[i] != nil
        return -1
      elsif @values[i] != nil && anOther[i] == nil
        return 1
      elsif @values[i] < anOther[i]
        return -1
      elsif @values[i] > anOther[i]
        return 1
      end
    end
    0
  end

  def to_s
    "#<Tuple values:#{@values}>"
  end
end
