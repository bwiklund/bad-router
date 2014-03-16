require './lib/router'

describe Router do

  before :each do
    @router = Router.new
  end

  def expect_request_status(path,verb,status)
    response = @router.call('PATH_INFO' => path,'REQUEST_METHOD' => verb.to_s)
    response[0].should == status
  end

  it "should exist" do
    @router.should_not be_nil
  end

  it "should respond 404 if no routes are set" do
    expect_request_status '/', 'GET', 404
  end

  it "should be able to route based on regex" do
    @router.get '/' do [200,{},["acceptable."]] end
    expect_request_status '/', 'GET', 200
  end

  it "should be able to route paths other than /" do
    @router.get "/foo" do [500,{},["bad."]] end
    @router.get "/bar" do [200,{},["good."]] end
    @router.get "/baz" do [500,{},["bad."]] end
    expect_request_status '/foo', 'GET', 500
    expect_request_status '/bar', 'GET', 200
    expect_request_status '/baz', 'GET', 500
  end

  it "should be able to route based on method" do
    @router.get '/' do [500,{},["bad."]] end
    @router.post '/' do [200,{},["good!"]] end
    expect_request_status '/', 'POST', 200
  end

  it "can match all verbs" do
    @router.all '/' do [200,{},[["ok"]]] end
    expect_request_status '/', 'GET', 200
    expect_request_status '/', 'POST', 200
  end

  it "can match certain verbs" do
    @router.methods [:GET,:POST], '/' do [200,{},[["ok"]]] end
    expect_request_status '/', 'GET', 200
    expect_request_status '/', 'POST', 200
    expect_request_status '/', 'DELETE', 404
  end

  it "can exclude certain verbs" do
    @router.except [:GET,:POST], '/' do [200,{},[["ok"]]] end
    expect_request_status '/', 'GET', 404
    expect_request_status '/', 'POST', 404
    expect_request_status '/', 'DELETE', 200
  end
end
