require 'test/unit'
require 'kayako_client'

class TestDepartment < Test::Unit::TestCase

    def test_department_readonly
        test = KayakoClient::Department.new(
            :id     => 1,
            :title  => 'Test',
            :type   => :public,
            :module => :tickets
        )
        assert_raise NoMethodError do
            test.id = 2
        end

        assert_nothing_raised do
            test.module = :livechat
        end

        test.loaded!
        assert_raise ArgumentError do
            test.module = :livechat
        end
    end

    def test_department_assign
        test = KayakoClient::Department.new

        test.type = "public"
        assert_equal test.type, :public

        test.module = "tickets"
        assert_equal test.module, :tickets

        test.display_order = "nan"
        assert_equal test.display_order, 0

        parent = KayakoClient::Department.new(
            :id => 1
        )

        test.parent_department_id = parent
        assert_equal test.parent_department_id, 1

        test.user_visibility_custom = 1
        assert_equal test.user_visibility_custom, true
    end

    def test_department_required
        test = KayakoClient::Department.new(
            :id => 1,
            :display_order => 1
        )
        assert_raise ArgumentError do
            test.put
        end

        test = KayakoClient::Department.new(
            :title => "Test"
        )
        assert_raise ArgumentError do
            test.post
        end
    end

    def test_department_validate
        test = KayakoClient::Department.new(
            :id    => 1,
            :title => "Test",
            :type => :test
        )
        assert_equal test.put, false
        assert test.has_errors?
    end

    def test_department_customs
        test = KayakoClient::Department.new(
            :id                   => 1,
            :title                => 'Test',
            :type                 => :public,
            :module               => :tickets
        )
        assert_equal test.has_parent_department?, false

        test.parent_department_id = 2
        assert test.has_parent_department?

        assert test.visible_to_user_group?(1)

        test.user_visibility_custom = true
        assert test.visible_to_user_group?(1) == false

        test.user_group_ids = [ 1 ]
        assert test.visible_to_user_group?(1)
    end

    def test_department_aliases
        test = KayakoClient::Department.new

        assert_nothing_raised do
            test.parentdepartmentid = 1
        end

        assert_nothing_raised do
            test.parentdepartmentid
        end
        assert_equal test.parentdepartmentid, 1

        assert_nothing_raised do
            test.usergroupid = [ 1 ]
        end

        assert_nothing_raised do
            test.usergroups
        end
        assert_instance_of Array, test.usergroups
        assert_equal test.usergroups.size, 1
        assert_equal test.usergroups[0], 1
    end

end
