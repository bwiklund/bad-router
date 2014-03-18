require 'simplecov'
SimpleCov.start

require './lib/capturer'

module BadRouter

  describe Capturer do

    it "exists" do
      Capturer.should_not be_nil
    end

    it "can parse paths with no params" do
      Capturer.new('/').parse('/').should == {}
      Capturer.new('/asdf').parse('/asdf').should == {}
      Capturer.new('/asdf/qwer').parse('/asdf/qwer').should == {}
    end

    it "can parse paths with params" do
      Capturer.new('/:foo').parse('/bar').should == {'foo' => 'bar'}
      Capturer.new('/:foo/:bar').parse('/fizz/buzz').should == {'foo' => 'fizz', 'bar' => 'buzz'}
    end

  end

end