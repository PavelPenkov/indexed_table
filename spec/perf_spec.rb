require 'benchmark'

describe "Performance", :perf => true do
  before(:all) do
    n = 100_000
    @queries = 10
    @rows = []
    ts = Benchmark.realtime do
      n.times {|i| @rows << {:id => i, :gender => rand(2) % 2 == 0 ? true : false, :age => rand(100), :height => rand(200), :balance => rand * 100} }
    end
    message "Generation: #{ts}"
    @t_s_i = Table.new
    @t_c_i = Table.new
  end

  context "without index" do
    before(:all) do
      @t1 = Table.new
      ts = Benchmark.realtime do 
        @rows.each {|row| @t1.insert row}
      end
      message "Insert without index: #{ts}"
    end

    it "selects results" do
      ts = Benchmark.realtime do
        @queries.times do 
          @t1.query { age == 50 }
        end
      end
      message "Query without index: #{ts}"
    end

    it "selects results multiple conditions" do
      ts = Benchmark.realtime do
        @queries.times do
          @t1.query do
            age >= 50
            balance >= 50.0
          end
        end
      end
      message "Query without index 2 conditions: #{ts}"
    end

    it "selects raw results" do
      ts = Benchmark.realtime do
        @queries.times do
          @t1.select{|row| row[:age] == 50}.to_a
        end
      end
      message "Raw iteration single condition: #{ts}"
    end

    it "selects raw results 2 conditions" do
      ts = Benchmark.realtime do
        @queries.times do
          @t1.select{|row| row[:age] == 50 && row[:height] == 150}.to_a
        end
      end
      message "Raw iteration 2 conditions: #{ts}"
    end
  end

  context "with simple key index" do
    before(:all) do
      @t_s_i.create_index :age
      ts = Benchmark.realtime do
        @rows.each {|row| @t_s_i.insert row}
      end
      message "Insert with simple index: #{ts}"
    end

    it "selects results" do
      ts = Benchmark.realtime do
        @queries.times do
          @t_s_i.query { age == 50 }
        end
      end
      message "Query with simple index: #{ts}"
    end
  end

  context "with composite-key index" do
    before(:all) do
      @t_c_i.create_index :age, :balance
      ts = Benchmark.realtime do
        @rows.each {|row| @t_c_i.insert row}
      end
      message "Insert with composite index: #{ts}"
    end

    it "selects results multiple conditions" do
      ts = Benchmark.realtime do
        @queries.times do
          @t_c_i.query do
            age == 50
            balance == 50.0
          end
        end
      end
      message "Query composite index 2 conditions: #{ts}"
    end

    it "selects results single condition first part" do
      ts = Benchmark.realtime do
        @queries.times do 
          @t_c_i.query { age == 50 }
        end
      end
      message "Query composite index first part condition: #{ts}"
    end

    it "selects results single condition second part" do
      ts = Benchmark.realtime do
        @queries.times do 
          @t_c_i.query { height >= 50.0 }
        end
      end
      message "Query composite index second part condition: #{ts}"
    end
  end
end
