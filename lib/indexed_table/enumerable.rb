module Enumerable
  # is xs head of ys?
  def head?(xs)
    if self.length > xs.length
      false
    else
      self.zip(xs).all?{|y,x| y == x || y.nil?}
    end
  end
end
