require 'spec_helper'

describe Index do
  before do
    @ix = Index.new :age
  end

  describe "#key" do
    it "returns correct simple key" do
      row = {:id => 1, :name => "Adam", :age => 50}

      @ix.key(row).should == [50]
    end

    it "returns correct composite key" do
      row = {:id => 1, :name => "Adam", :age => 50}
      ix = Index.new :name, :age
      ix.key(row).should == ["Adam", 50]
    end
  end

  describe "#insert" do
    it "stores unique keys" do
      @ix.insert({:id => 1, :name => "Alice", :age => 23})
      @ix.insert({:id => 1, :name => "Beth", :age => 24})

      @ix.all.size.should == 2
    end

    it "stores non-unique keys" do
      @ix.insert({:id => 1, :name => "Alice", :age => 24})
      @ix.insert({:id => 1, :name => "Beth", :age => 24})

      @ix.all.size.should == 2
    end
  end

  describe "#select" do
    context "single column" do
      before(:each) do
        @ix = Index.new :age
        @ix.insert({:id => 1, :name => "Alice", :age => 23})
        @ix.insert({:id => 2, :name => "Beth", :age => 24})
        @ix.insert({:id => 3, :name => "Carol", :age => 25})
      end


      context "exact match" do 
        it "returns 1 row when value found" do
          pr = Predicate.new { age == 23 }
          res = @ix.select(pr)
          res.length.should == 1
        end

        it "returns empty array when value absent" do
          pr = Predicate.new { age == 99 }
          res = @ix.select(pr)
          res.should be_empty
        end
      end

      context "range query" do
        it "returns 0 rows if predicate is false" do
          pr = Predicate.new { age < 0 }
          res = @ix.select(pr)
          res.should be_empty
        end

        it "returns all rows for true predicate" do
          pr = Predicate.new { age > 0 }
          res = @ix.select(pr)
          res.length.should == 3
        end

        it "returns all rows for between condition" do
          pr = Predicate.new { age.between?(24, 100) }
          res = @ix.select(pr)
          res.length.should == 2
        end
      end
    end
  end
end
