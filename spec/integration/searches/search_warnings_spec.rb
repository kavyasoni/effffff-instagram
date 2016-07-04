describe "search warnings" do
  before :each do
    visit root_path
    set_omniauth
    click_button 'SIGN IN WITH INSTAGRAM'
  end

  it "user sees no warning messages when entering valid queries", js: true do
    fill_in :hashtag_one, with: 'one'
    fill_in :hashtag_two, with: 'two'
    fill_in :hashtag_three, with: 'three'
    expect(page).to have_selector('#duplicate-tags-warning', visible: false)
    expect(page).to have_selector('#empty-tags-warning', visible: false)
  end

  it "user sees a warning message when entering duplicate hashtags", js: true do
    fill_in :hashtag_one, with: 'one'
    fill_in :hashtag_two, with: 'two'
    fill_in :hashtag_three, with: 'two'
    expect(page).to have_selector('#duplicate-tags-warning', visible: true)
    expect(page).to have_selector('#empty-tags-warning', visible: false)
  end

  it "user sees the empty tags warning message even when entering duplicate hashtags after clicking the search button", js: true do
    fill_in :hashtag_one, with: 'one'
    fill_in :hashtag_two, with: 'two'
    click_button 'SEARCH'
    expect(page).to have_selector('#duplicate-tags-warning', visible: false)
    expect(page).to have_selector('#empty-tags-warning', visible: true)
  end

  it "user sees an message when searching with just one hashtag, after clicking the search button", js: true do
    fill_in :hashtag_one, with: 'one'
    click_button 'SEARCH'
    expect(page).to have_selector('#duplicate-tags-warning', visible: false)
    expect(page).to have_selector('#empty-tags-warning', visible: true)
  end

  it "user sees an message when searching without any hashtags, after clicking the search button", js: true do
    click_button 'SEARCH'
    expect(page).to have_selector('#duplicate-tags-warning', visible: false)
    expect(page).to have_selector('#empty-tags-warning', visible: true)
  end

  it "user sees an message when searching with just two hashtags, after clicking the search button", js: true do
    fill_in :hashtag_one, with: 'one'
    fill_in :hashtag_two, with: 'two'
    click_button 'SEARCH'
    expect(page).to have_selector('#duplicate-tags-warning', visible: false)
    expect(page).to have_selector('#empty-tags-warning', visible: true)
  end
end