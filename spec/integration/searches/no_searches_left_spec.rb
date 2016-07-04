describe "search limit reached for the day" do
  it "user sees a warning message" do
    visit root_path
    set_omniauth
    click_button 'SIGN IN WITH INSTAGRAM'
    create(:request_batch, user: User.last)
    visit root_path
    expect(page).to have_content("you've got no searches left for today!")
  end
end