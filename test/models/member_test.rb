require "test_helper"

class MemberTest < ActiveSupport::TestCase

  test "member requires a name" do
    member = Member.new(
      email: "test@example.com",
      phone: "+420123456789"
    )

    assert_not member.valid?
  end

  test "member requires an email" do
    member = Member.new(
      name: "Tomáš",
      phone: "+420123456789"
    )

    assert_not member.valid?
  end

  test "member requires a phone" do
    member = Member.new(
      name: "Tomáš",
      email: "test@example.com"
    )

    assert_not member.valid?
  end

  test "member requires unique name" do
    Member.create!(
      name: "Tomáš",
      email: "first@example.com",
      phone: "+420111111111"
    )

    member = Member.new(
      name: "Tomáš",
      email: "second@example.com",
      phone: "+420222222222"
    )

    assert_not member.valid?
  end

  test "member requires unique email" do
    Member.create!(
      name: "Tomáš",
      email: "test@example.com",
      phone: "+420111111111"
    )

    member = Member.new(
      name: "Petr",
      email: "test@example.com",
      phone: "+420222222222"
    )

    assert_not member.valid?
  end

  test "member requires unique phone" do
    Member.create!(
      name: "Tomáš",
      email: "first@example.com",
      phone: "+420111111111"
    )

    member = Member.new(
      name: "Petr",
      email: "second@example.com",
      phone: "+420111111111"
    )

    assert_not member.valid?
  end

end