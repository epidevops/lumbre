require "application_system_test_case"

class Static::ContactsTest < ApplicationSystemTestCase
  setup do
    @email = "test@example.com"
    @message = "Hello, world!"
  end

  test "should create contact us message successfully" do
    visit root_url

    assert_selector(:css, 'a[href="#contact"]')

    click_on "Contact"

    assert_selector(:css, 'form[action="/en/static/contacts"]')

    within("form[action='/en/static/contacts']") do
      fill_in "contact[email]", with: @email
      fill_in "contact[contact_messages_attributes][0][message]", with: @message
      click_button "Send message"
    end

    using_wait_time(0.2) do
      assert_text "Your message has been sent. We will get back to you as soon as possible."
    end
  end

  test "should not create contact us message after rate limit" do
    visit root_url

    click_on "Contact"

    # Make 10 successful requests (at the limit)
    10.times do |i|
      within("form[action='/en/static/contacts']") do
        fill_in "contact[email]", with: "test#{i}@example.com"
        fill_in "contact[contact_messages_attributes][0][message]", with: "Message #{i}"
        click_button "Send message"
      end

      using_wait_time(0.2) do
        assert_text "Your message has been sent. We will get back to you as soon as possible."
      end
    end

    # Make 11th request (should be rate limited)
    within("form[action='/en/static/contacts']") do
      fill_in "contact[email]", with: "test10@example.com"
      fill_in "contact[contact_messages_attributes][0][message]", with: "Message 10"
      click_button "Send message"
    end

    using_wait_time(0.2) do
      refute_text "Your message has been sent. We will get back to you as soon as possible."
      assert_text "Try again later."
    end
  end
end
