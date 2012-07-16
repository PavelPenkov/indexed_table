require 'spec_helper'

describe Index do
  context "multiple columns" do
    before do
      @ix = Index.new :id, :amount
      @ix.insert({:id => 1, :amount => 101})
      @ix.insert({:id => 2, :amount => 101})
    end

    it "returns exact match" do
      pr = Predicate.new do
        id == 1
        amount == 101
      end

      @ix.select(pr).length.should == 1
    end

    it "returns empty result when no exact match" do
      pr = Predicate.new do
        id == 1000
        amount == 1000
      end

      @ix.select(pr).length.should == 0
    end

    it "returns when all rows match" do
      pr = Predicate.new do
        id >= 0
        amount >= 0
      end

      @ix.select(pr).length.should == 2
    end

    it "returns when second part matches part" do
      pr = Predicate.new do
        id >= 2
        amount >= 101
      end

      @ix.select(pr).length.should == 1
    end

    it "returns when first part matches part" do
      pr = Predicate.new do
        id >= 2
        amount >= 0
      end

      @ix.select(pr).length.should == 1
    end

    it "returns when predicate incomplete" do
      pr = Predicate.new do
        id >= 2
      end

      @ix.select(pr).length.should == 1
    end

    it "returns when one condition fails" do
      pr = Predicate.new do
        id >= 1000
        amount >= 101
      end

      @ix.select(pr).length.should == 0
    end
  end
end
