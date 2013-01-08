require File.dirname(__FILE__) + "/test_helper"
require 'fakeweb'
require 'active_resource/find_as_hashes'

module Resource
  class User < ActiveResource::Base
    self.site = 'http://api.test.com/'
    self.format = :json
  end
end

class ActiveResourceTest < ActiveSupport::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, "http://api.test.com/users.json", :body => User.all.to_json, :status => ["200", "OK"])
  end

  def teardown
    FakeWeb.allow_net_connect = true
    FakeWeb.clean_registry
  end

  context "#all_as_hashes" do
    setup do
      @records = Resource::User.all
      @hashes = Resource::User.all_as_hashes
    end

    should "return an array of attribute hashes" do
      assert_equal Array, @hashes.class
      assert @hashes.all? { |hash| hash.class == Hash }
      assert @records.all? { |record| record.class != Hash }
    end
  end

  context "#first_as_hash" do
    setup do
      @record = Resource::User.first
      @hash = Resource::User.first_as_hash
    end

    should "return a single hash" do
      assert_equal Hash, @hash.class
      assert_equal Resource::User, @record.class
      assert_equal @hash["user"]["name"], User.first.name
    end
  end

  context "#last_as_hash" do
    setup do
      @record = Resource::User.last
      @hash = Resource::User.last_as_hash
    end

    should "return a single hash" do
      assert_equal Hash, @hash.class
      assert_equal Resource::User, @record.class
      assert_equal @hash["user"]["name"], User.last.name
    end
  end
end