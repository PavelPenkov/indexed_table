require 'spec_helper'

describe Tuple do
  it "is equal to itself" do
    a = Tuple.new(1, "Adam")
    b = Tuple.new(1, "Adam")

    a.should == b
  end

  it "compares using first value" do
    a = Tuple.new(1, "Adam")
    b = Tuple.new(2, "Adam")

    a.should < b
  end

  it "compares using second value" do
    a = Tuple.new(1, "Adam")
    b = Tuple.new(1, "Eve")

    a.should < b
    b.should > a
  end

  it "raises error when compared to different type" do
    a = Tuple.new(1, "Adam")

    lambda { a < 1 }.should raise_error(ArgumentError)
  end

  it "compares tuples of different size" do
    a = Tuple.new(1, "Adam")
    b = Tuple.new(2)

    a.should < b
    b.should > a
  end

  it "compares tuples of different size" do
    a = Tuple.new(1, "Adam")
    b = Tuple.new(2)

    a.should < b
    b.should > a
  end

  it "compares tuples different size #2" do
    a = Tuple.new(1)
    b = Tuple.new(1, "Adam")

    (a < b).should be_true
    (b > a).should be_true
  end

  it "compares tuples different size #3" do
    a = Tuple.new(1, "Eve")
    b = Tuple.new(2, "Adam")

    (a < b).should be_true
    (b > a).should be_true
  end

end
