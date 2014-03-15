require './lib/app'

describe App do
  it "should exist" do
    App.new
  end

  it "should respond to calls from rack" do
    app = App.new
    response = app.call '/'
    response[0].should == 404
  end
end
