require "application_system_test_case"

class Static::ContactsTest < ApplicationSystemTestCase
  setup do
    skip "Skipping this test for now"

    @email = "test@example.com"
    @message = "Hello, world!"
  end

  test "should create contact us message successfully" do
    skip "Skipping this test for now"

    visit root_url

    assert_selector(:css, 'a[href="#contact"]')

    click_on "Contact"

    assert_selector(:css, 'form[action="/en/static/contacts"]')

    debugger

    within("form[action='/en/static/contacts']") do
      fill_in "contact[email]", with: @email
      fill_in "contact[contact_messages_attributes][0][message]", with: @message
      turbo_click "commit"
    end

    # assert_text "Message sent successfully"
  end
end
