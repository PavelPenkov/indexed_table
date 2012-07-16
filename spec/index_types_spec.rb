describe Index do
  context "floats" do
    before do
      @ix = Index.new :balance
      100.times do
        @ix.insert({:balance => rand * 100})
      end
    end

    it "returns the same result as raw query" do
      pr = Predicate.new { balance >= 50.0}
      i_r = @ix.select(pr)
      r_r = @ix.all.select{|x| x[:balance] >= 50.0}

      i_r.length.should == r_r.length
    end
  end
end
