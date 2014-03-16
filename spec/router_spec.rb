require './lib/router'

describe Router do

  # helper to dry up these cases
  def expect_request_status(router,path,verb,status)
    router.call('PATH_INFO' => path,'REQUEST_METHOD' => verb.to_s)[0].should == status
  end

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
    expect_request_status router, '/foo', 'GET', 500
    expect_request_status router, '/bar', 'GET', 200
    expect_request_status router, '/baz', 'GET', 500
  end

  it "should be able to route based on method" do
    router = Router.new
    router.get '/' do [500,{},["bad."]] end
    router.post '/' do [200,{},["good!"]] end
    expect_request_status router, '/', 'POST', 200
  end

  it "can match all verbs" do
    router = Router.new
    router.all '/' do [200,{},[["ok"]]] end
    expect_request_status router, '/', 'GET', 200
    expect_request_status router, '/', 'POST', 200
  end

  it "can match certain verbs" do
    router = Router.new
    router.methods [:GET,:POST], '/' do [200,{},[["ok"]]] end
    expect_request_status router, '/', 'GET', 200
    expect_request_status router, '/', 'POST', 200
    expect_request_status router, '/', 'DELETE', 404
  end
end
