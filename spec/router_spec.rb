require './lib/router'

describe Router do
  it "should exist" do
    Router.new
  end

  it "should respond to calls from rack" do
    response = Router.new.call '/'
    response[0].should == 404
  end

  it "should be able to route based on regex" do
    router = Router.new
    router.get '/' do [200,{},"acceptable."] end
    response = router.call(REQUEST_PATH:'/',REQUEST_METHOD:'GET')
    response[0].should == 200
  end

  it "should be able to route based on method" do
    router = Router.new
    router.get '/' do [200,{},"bad."] end
    router.post '/' do [200,{},"good!"] end
    response = router.call(REQUEST_PATH:'/',REQUEST_METHOD:'POST')
    response[2].should == "good!"
  end
end
