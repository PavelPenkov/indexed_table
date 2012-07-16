require 'spec_helper'

describe Predicate do
  before do
    @p = Predicate.new do
      x == 1
    end
  end

  it "creates eq condition" do
    cond = @p.conditions[0]

    cond.column.should == :x
    cond.arg.should == 1
  end

  it "compares row with single" do
    row = {:x => 1}

    @p.call(row).should be_true

    row = {:x => 2}

    @p.call(row).should be_false
  end

  it "compares row with multiple conditions" do
    row = {:x => 1, :first_name => "Adam", :age => 50, :parents => 0, :children => 2}

    p = Predicate.new do
      x < 2
      first_name == "Adam"
      age > 30
      parents >= 0
      children <= 2
    end

    p.call(row).should be_true
  end

  it "saves all conditions" do
    p = Predicate.new do
      id == 1
      amount == 100
    end

    p.conditions.length.should == 2
  end

  it "allows reserved words" do
    p = Predicate.new do
      id == 1
    end

    p.conditions.length.should == 1
    p.columns.should == [:id]
  end
end
