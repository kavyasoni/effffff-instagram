describe "access top page" do
  it "can sign a person in using their instagram account" do
    visit root_path
    set_omniauth
    click_button 'SIGN IN WITH INSTAGRAM'
    expect(page).to have_css('.icon-sign-out')
    expect(page).not_to have_css('.icon-sign-in')
  end

  it "can handle authentication error" do
    visit root_path
    set_invalid_omniauth
    click_button 'SIGN IN WITH INSTAGRAM'
    expect(page).to have_css('.icon-sign-in')
    expect(page).not_to have_css('.icon-sign-out')
  end
end