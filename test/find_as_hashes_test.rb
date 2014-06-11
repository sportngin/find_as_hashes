require File.dirname(__FILE__) + "/test_helper"

class FindAsHashesTest < ActiveSupport::TestCase
  context "#all_as_hashes" do
    context "on a relation" do
      setup do
        @records = User.where(:active => true)
        @hashes = @records.all_as_hashes
      end

      should "return an array of attribute hashes" do
        assert_equal Array, @hashes.class
        assert @hashes.all? { |hash| hash.class == Hash }
      end

      should "return the same number of results as `all`" do
        assert_equal @records.size, @hashes.size
      end

      should "return the same results as `all`" do
        assert_equal @records.first.name_before_type_cast, @hashes.first["name"]
        assert_equal @records.first.birthday_before_type_cast, @hashes.first["birthday"]
        assert_equal @records.first.active_before_type_cast, @hashes.first["active"]
      end
    end

    context "on a model" do
      setup do
        @records = User.all
        @hashes = User.all_as_hashes
      end

      should "return the same results as `all`" do
        assert_equal @records.first.name_before_type_cast, @hashes.first["name"]
        assert_equal @records.first.birthday_before_type_cast, @hashes.first["birthday"]
        assert_equal @records.first.active_before_type_cast, @hashes.first["active"]
      end
    end

    context "using `includes`" do
      setup do
      end

      should "use the included relation in the query" do
        assert_nothing_raised do
          @hashes = User.includes(:role).where("roles.admin" => true).all_as_hashes
          assert Role.where(@hashes.first["role_id"]).first.admin?
        end
      end
    end
  end

  context "#first_as_hash" do
    context "on a relation" do
      setup do
        relation = User.where(:active => false)
        @record = relation.first
        @hash = relation.first_as_hash
      end

      should "return a hash of attributes" do
        assert_equal Hash, @hash.class
      end

      should "return the same result as `first`" do
        assert_equal @record.name_before_type_cast, @hash["name"]
        assert_equal @record.birthday_before_type_cast, @hash["birthday"]
        assert_equal @record.active_before_type_cast, @hash["active"]
      end
    end

    context "on a model" do
      setup do
        @record = User.first
        @hash = User.first_as_hash
      end

      should "return the same result as `first`" do
        assert_equal @record.name_before_type_cast, @hash["name"]
        assert_equal @record.birthday_before_type_cast, @hash["birthday"]
        assert_equal @record.active_before_type_cast, @hash["active"]
      end
    end

    context "using `includes`" do
      setup do
      end

      should "use the included relation in the query" do
        assert_nothing_raised do
          @hash = User.includes(:role).where("roles.admin" => true).first_as_hash
          assert Role.where(@hash["role_id"]).first.admin?
        end
      end
    end
  end
end
