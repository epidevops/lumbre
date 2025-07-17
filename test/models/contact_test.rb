require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test "should normalize email" do
    contact = Contact.new(email: "test@example.com")
    assert_equal "test@example.com", contact.email

    contact = Contact.new(email: "Test@Example.com")
    assert_equal "test@example.com", contact.email

    contact = Contact.new(email: "test@example.com.br")
    assert_equal "test@example.com.br", contact.email

    contact = Contact.new(email: "test@example.com.br  ")
    assert_equal "test@example.com.br", contact.email
  end

  test "should sanitize message for javascript" do
    contact = Contact.new(email: "test@example.com")
    contact.contact_messages.build(message: "<script>alert('test')</script>")
    assert_equal "alert('test')", contact.contact_messages.first.message
  end

  test "should sanitize message for html" do
    contact = Contact.new(email: "test@example.com")
    contact.contact_messages.build(message: "<p>Lorem ipsum dol sit amet, consectetuer</p>")
    assert_equal "<p>Lorem ipsum dol sit amet, consectetuer</p>", contact.contact_messages.first.message
  end

  test "should have valid message length <= 5000" do
    contact = Contact.new(email: "test@example.com")
    contact.contact_messages.build(message: "a" * 5000)
    assert_equal true, contact.valid?
  end

  test "should have invalid message length > 5000" do
    contact = Contact.new(email: "test@example.com")
    contact.contact_messages.build(message: "a" * 5001)
    assert_equal false, contact.valid?
  end
end
