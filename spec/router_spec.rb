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
    router.get '/' do [200,{},["acceptable."]] end
    response = router.call('PATH_INFO' => '/','REQUEST_METHOD' => 'GET')
    response[0].should == 200
  end

  it "should be able to route paths other than /" do
    router = Router.new
    router.get "/foo" do [500,{},["bad."]] end
    router.get "/bar" do [200,{},["good."]] end
    router.get "/baz" do [500,{},["bad."]] end
    router.call('PATH_INFO' => '/foo','REQUEST_METHOD' => 'GET')[2]
      .should == ["bad."]
    router.call('PATH_INFO' => '/bar','REQUEST_METHOD' => 'GET')[2].should == ["good."]
    router.call('PATH_INFO' => '/baz','REQUEST_METHOD' => 'GET')[2].should == ["bad."]
  end

  it "should be able to route based on method" do
    router = Router.new
    router.get '/' do [500,{},["bad."]] end
    router.post '/' do [200,{},["good!"]] end
    response = router.call('PATH_INFO' => '/','REQUEST_METHOD' => 'POST')
    response[2].should == ["good!"]
  end
end
