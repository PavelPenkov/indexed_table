require 'spec_helper'

describe Table do
  before(:each) do 
    @table = Table.new
  end

  describe "#create_index" do
    it "creates index on proper columns" do
      @table.create_index :age

      @table.indexes.length.should == 1
      @table.indexes.first.columns.should == [:age]
    end
  end

  describe "#find_index" do
    before do
      @table.create_index :name, :balance
      @table.create_index :age
    end

    it "finds proper single column index" do
      pr = Predicate.new { age == 100 }
      ix = @table.find_index(pr)

      ix.columns.should == [:age]
    end

    it "returns nothing if no single column index found" do
      pr = Predicate.new { id == 1 }
      ix = @table.find_index(pr)

      ix.should be_nil
    end

    it "finds proper composite index for 2 condition predicate if wrong order" do
      pr = Predicate.new do
        balance == 100.0
        name == "Alice"
      end

      ix = @table.find_index(pr)

      ix.should_not be_nil
      ix.columns.should == [:name, :balance]
    end

    it "finds proper composite index for 2 condition predicate if same order" do
      pr = Predicate.new do
        name == "Alice"
        balance == 100.0
      end

      ix = @table.find_index(pr)

      ix.should_not be_nil
      ix.columns.should == [:name, :balance]
    end
  end

  describe "#query" do
    before do
      @table.insert(:gender => true, :age => 50, :height => 150, :index => 1, :balance => 0.0)
    end

    it "returns all rows if no query given" do
      res = @table.query
      res.count.should == 1
      res.first[:age].should == 50
    end

    context "single predicate" do
      context "eq predicate" do
        it "returns rows when true" do 
          rows = @table.query { gender == true }
          rows.length.should == 1
        end

        it "returns nothing when false" do
          rows = @table.query { gender == false } 
          rows.should be_empty
        end
      end

      context "gt predicate" do
        it "returns rows when true" do
          rows = @table.query { age > 25 }
          rows.length.should == 1
        end

        it "returns rows when true" do
          rows = @table.query { age > 100 } 
          rows.should be_empty
        end
      end
    end
  end
end
