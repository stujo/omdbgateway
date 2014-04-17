require 'spec_helper'


module OMDB

  describe Gateway::ResponseWrapper do

    let!(:error_500) { Gateway::ResponseWrapper.new({'anything' => 'value'}, 500, 'X500 Error') }
    let!(:empty_array) { Gateway::ResponseWrapper.new([]) }
    let!(:array_one_item) { Gateway::ResponseWrapper.new([{'a' => 'A', 'b' => 'B'}]) }
    let!(:array_two_item) { Gateway::ResponseWrapper.new([{'a' => 'A', 'b' => 'B'}, {'c' => 'C', 'd' => 'D'}]) }

    let!(:empty_hash) { Gateway::ResponseWrapper.new({}) }
    let!(:simple_hash) { Gateway::ResponseWrapper.new({'a' => 'A'}) }
    let!(:app_fail_hash) { Gateway::ResponseWrapper.new({"Response" => "False", "Error" => "App Error"}) }

    describe "#error_message" do
      it "should be nil" do
        empty_array.error_message.should eq nil
      end
      it "should be 'X500 Error'" do
        error_500.error_message.should eq 'X500 Error'
      end
      it "should be 'X500 Error'" do
        app_fail_hash.error_message.should eq 'App Error'
      end
    end

    describe "#success?" do
      it "should be true" do
        empty_array.success?.should eq true
      end
      it "should be true" do
        error_500.success?.should eq false
      end
      it "should be false" do
        app_fail_hash.success?.should eq false
      end
    end


    describe "#as_hash" do
      it "should be {}" do
        empty_array.as_hash.should eq({})
      end
      it "should be {}" do
        error_500.as_hash.should eq({})
      end
      it "should be {}" do
        app_fail_hash.as_hash.should eq({})
      end
      it "should be {'a' => 'A'}" do
        simple_hash.as_hash.should eq({'a' => 'A'})
      end
    end


    describe "#as_hash" do
      it "should be []" do
        empty_array.as_array.should eq([])
      end
      it "should be []" do
        error_500.as_array.should eq([])
      end
      it "should be []" do
        app_fail_hash.as_array.should eq([])
      end
      it "should be []" do
        simple_hash.as_array.should eq([])
      end
      it "should be [{'a' => 'A', 'b' => 'B'}]" do
        array_one_item.as_array.should eq([{'a' => 'A', 'b' => 'B'}])
      end
    end

    describe "#prune_hash" do
      it "should be nil for empty array" do
        empty_array.prune_hash('tag')
        empty_array.body.should eq(nil)
      end
      it "should be 5" do
        error_500.prune_hash('tag', 5)
        error_500.body.should eq(5)
      end
      it "should not expose Error or Report" do
        app_fail_hash.prune_hash('Error', 100)
        app_fail_hash.body.should eq(100)
      end
      it "should be return hash element" do
        simple_hash.prune_hash('a')
        simple_hash.body.should eq('A')
      end
      it "should be nil for any array" do
        array_one_item.prune_hash('tag')
        array_one_item.body.should eq(nil)
      end
    end

    describe "#prune_array" do
      it "should be nil for empty array" do
        empty_array.prune_array(0)
        empty_array.body.should eq(nil)
      end
      it "should be default 700" do
        error_500.prune_array(3, 700)
        error_500.body.should eq(700)
      end
      it "should not expose Error or Report" do
        app_fail_hash.prune_array(0, 1000)
        app_fail_hash.body.should eq(1000)
      end
      it "should not return hash element but the default" do
        simple_hash.prune_array(0)
        simple_hash.body.should eq(nil)
      end
      it "should be {'a' => 'A', 'b' => 'B'} for any array" do
        array_one_item.prune_array(0)
        array_one_item.body.should eq({'a' => 'A', 'b' => 'B'})
      end
      it "should be default (500) for out of bound index for any array" do
        array_one_item.prune_array(1, 500)
        array_one_item.body.should eq(500)
      end
    end


    describe "#array_first" do
      it "should be nil for empty array" do
        empty_array.array_first.should eq(nil)
      end
      it "should be {'a' => 'A', 'b' => 'B'} for any array" do
        array_one_item.array_first.should eq({'a' => 'A', 'b' => 'B'})
      end
    end
  end

end