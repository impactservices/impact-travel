require "spec_helper"

feature "New Search" do
  scenario "subscriber creates a new search" do
    login_with_valid_credentials
    search = build(:search)
    stub_search_create_api(search.attributes)

    fill_in "search_destination", with: search.destination
    fill_in "search_check_in", with: search.check_in
    fill_in "search_check_out", with: search.check_out
    select "2 Guests", from: "search_guests"
    find("input#search_location_id", visible: false).set(
      search.location_id
    )

    click_on "Search"

    expect(page).to have_content("Looking for hotels in ..")
    expect(current_path).to match(/searches\/*\//)
  end

  def login_with_valid_credentials
    visit impact_travel.new_session_path
    subscriber = build(:login, name: "username")
    stub_session_create_api(subscriber.attributes)

    fill_in "login_name", with: subscriber.name
    fill_in "login_password", with: subscriber.password
    click_on "Login"
  end
end