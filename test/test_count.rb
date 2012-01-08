require 'test/unit'
require 'kayako_client'

class TestCount < Test::Unit::TestCase

    def test_count_embedded
        test = KayakoClient::TicketCount.new(
            :departments => {
                :department => [ {
                        :id                   => 1,
                        :lastactivity         => 1311888965,
                        :totalitems           => 100,
                        :totalunresolveditems => 50,
                        :ticketstatus         => {
                            :id               => 1,
                            :lastactivity     => 1311888965,
                            :totalitems       => 100
                        },
                        :tickettype           => [ {
                                :id                   => 0,
                                :lastactivity         => 1311888965,
                                :totalitems           => 50,
                                :totalunresolveditems => 25
                            }, {
                                :id                   => 1,
                                :lastactivity         => 1311887337,
                                :totalitems           => 50,
                                :totalunresolveditems => 25
                            }
                        ],
                        :ownerstaff               => {
                            :id                   => 1,
                            :lastactivity         => 1311888965,
                            :totalitems           => 15,
                            :totalunresolveditems => 10
                        }
                    }, {
                        :id                   => 2,
                        :lastactivity         => 75,
                        :totalunresolveditems => 25
                    }
                ]
            },
            :statuses => {
                :id               => 1,
                :lastactivity     => 1311888965,
                :totalitems       => 100
            },
            :owners => [ {
                    :id                   => 1,
                    :lastactivity         => 1311888965,
                    :totalitems           => 15,
                    :totalunresolveditems => 10
                }, {
                    :id                   => 2,
                    :lastactivity         => 1311888396,
                    :totalitems           => 80,
                    :totalunresolveditems => 30
                }
            ],
            :unassigned  => {
                :id                   => 1,
                :lastactivity         => 1311888965,
                :totalitems           => 15,
                :totalunresolveditems => 10
            }
        )

        assert_instance_of Array, test.departments
        assert_instance_of KayakoClient::TicketCountDepartment, test.departments.first
        assert_equal test.departments.size, 2

        assert_equal test.departments.first.id, 1
        assert_instance_of Time, test.departments.first.last_activity
        assert_equal test.departments.first.last_activity.to_i, 1311888965
        assert_equal test.departments.first.total_items, 100
        assert_equal test.departments.first.total_unresolved_items, 50

        assert_instance_of Array, test.departments.first.statuses
        assert_instance_of Array, test.departments.first.types
        assert_instance_of Array, test.departments.first.owners

        assert_instance_of KayakoClient::TicketCountStatus, test.departments.first.statuses.first
        assert_instance_of KayakoClient::TicketCountType, test.departments.first.types.first
        assert_instance_of KayakoClient::TicketCountOwner, test.departments.first.owners.first

        assert_equal test.departments.first.statuses.size, 1
        assert_equal test.departments.first.types.size, 2
        assert_equal test.departments.first.owners.size, 1

        assert_instance_of Array, test.statuses
        assert_instance_of KayakoClient::TicketCountStatus, test.statuses.first
        assert_equal test.statuses.size, 1

        assert_equal test.statuses.first.id, 1
        assert_equal test.statuses.first.last_activity.to_i, 1311888965
        assert_equal test.statuses.first.total_items, 100

        assert_instance_of Array, test.owners
        assert_instance_of KayakoClient::TicketCountOwner, test.owners.first
        assert_equal test.owners.size, 2

        assert_equal test.owners.first.id, 1
        assert_equal test.owners.first.last_activity.to_i, 1311888965
        assert_equal test.owners.first.total_items, 15
        assert_equal test.owners.first.total_unresolved_items, 10

        assert_instance_of Array, test.unassigned
        assert_instance_of KayakoClient::TicketCountUnassigned, test.unassigned.first
        assert_equal test.unassigned.size, 1

        assert test.departments.first.respond_to?(:department)
        assert test.departments.first.types.first.respond_to?(:ticket_type)
        assert test.statuses.first.respond_to?(:ticket_status)
        assert test.owners.first.respond_to?(:owner_staff)
    end

    def test_count_methods
        assert_raise NotImplementedError do
            KayakoClient::TicketCount.all
        end

        test = KayakoClient::TicketCount.new(
            :unassigned  => {
                :id                   => 1,
                :lastactivity         => 1311888965,
                :totalitems           => 15,
                :totalunresolveditems => 10
            }
        )
        assert_raise NotImplementedError do
            test.put
        end

        assert_raise NotImplementedError do
            KayakoClient::TicketCount.post
        end

        assert_raise NotImplementedError do
            test.delete
        end

        assert_raise NotImplementedError do
            KayakoClient::TicketCount.delete(1)
        end
    end

end
