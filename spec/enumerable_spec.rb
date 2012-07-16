require 'spec_helper'

describe Enumerable do
  describe "#head?" do
    it "is true if head" do
      [1].head?([1,2]).should be_true
    end

    it "is true if equal to" do
      [1,2].head?([1,2]).should be_true
    end

    it "is false if nothing match" do
      [3].head?([1,2]).should be_false
    end

    it "is false if longer" do
      [1,2,3].head?([1,2]).should be_false
    end

    it "is false if wrong order" do
      [2,1].head?([1,2]).should be_false
    end
    
  end
end

