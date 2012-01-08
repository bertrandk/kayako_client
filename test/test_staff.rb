require 'test/unit'
require 'kayako_client'

class TestDepartment < Test::Unit::TestCase

    def test_staff_readonly
        test = KayakoClient::Staff.new(
            :id         => 1,
            :user_name  => 'test',
            :first_name => 'Test',
            :last_name  => 'Test'
        )

        assert_raise NoMethodError do
            test.id = 2
        end

        assert_raise NoMethodError do
            test.fullname = 'Test Test'
        end
    end

    def test_staff_assign
        test = KayakoClient::Staff.new

        group = KayakoClient::StaffGroup.new(
            :id    => 1,
            :title => 'Test'
        )
        test.staff_group_id = group
        assert_equal test.staff_group_id, 1

        test.is_enabled = true
        assert test.is_enabled

        test.is_enabled = 0
        assert test.is_enabled == false
    end

    def test_staff_required
        test = KayakoClient::Staff.new(
            :id         => 1,
            :user_name  => 'test',
            :first_name => 'Test',
            :last_name  => 'Test'
        )
        assert_raise ArgumentError do
            test.put
        end

        test = KayakoClient::Staff.new(
            :user_name      => 'test',
            :first_name     => 'Test',
            :last_name      => 'Test',
            :email          => 'test@test.com',
            :staff_group_id => 1
        )
        assert_raise ArgumentError do
            test.post
        end
    end

end
