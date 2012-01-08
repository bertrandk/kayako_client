require 'test/unit'
require 'kayako_client'

class TestUser < Test::Unit::TestCase

    def test_user_customs
        assert_raise ArgumentError do
            KayakoClient::User.all(0)
        end

        assert_raise ArgumentError do
            KayakoClient::User.all(1, 0)
        end

        assert_raise ArgumentError do
            KayakoClient::User.all(nil, 1)
        end

        assert_raise ArgumentError do
            KayakoClient::User.all(0, 1)
        end
    end

    def test_user_validate
        test = KayakoClient::User.new(
            :user_group_id => 1,
            :user_role     => :tester,
            :salutation    => 'Sir',
            :full_name     => 'Test',
            :emails        => 'test@test.com',
            :password      => 'test'
        )

        assert !test.save
        assert test.errors.has_key?(:user_role)
        assert test.errors.has_key?(:salutation)
    end

    def test_user_required
        test = KayakoClient::User.new(
            :full_name     => 'Test',
            :emails        => 'test@test.com',
            :password      => 'test'
        )
        assert_raise ArgumentError do
            test.save
        end

        test = KayakoClient::User.new(
            :user_group_id => 1,
            :emails        => 'test@test.com',
            :password      => 'test'
        )
        assert_raise ArgumentError do
            test.save
        end

        test = KayakoClient::User.new(
            :user_group_id => 1,
            :full_name     => 'Test',
            :password      => 'test'
        )
        assert_raise ArgumentError do
            test.save
        end

        test = KayakoClient::User.new(
            :user_group_id => 1,
            :full_name     => 'Test',
            :emails        => 'test@test.com'
        )
        assert_raise ArgumentError do
            test.save
        end
    end

end
