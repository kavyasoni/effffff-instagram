describe "search history" do
  before :each do
    visit root_path
    set_omniauth
    click_button 'SIGN IN WITH INSTAGRAM'
  end

  it "user can view their past searches" do
    create(:request_batch, user: User.last, query_terms: ['discontent', 'botryoidal', 'vermiculites'])
    visit search_history_path
    expect(page).to have_content('discontent')
    expect(page).to have_content('botryoidal')
    expect(page).to have_content('vermiculites')
  end

  it "user can see that a past search is still incomplete" do
    create(:request_batch, user: User.last, complete: false)
    visit search_history_path
    expect(page).to have_selector('.icon-clock-o')
    expect(page).to_not have_selector('.icon-check')
  end

  it "user can see that a past search is complete" do
    create(:request_batch, user: User.last, complete: true)
    visit search_history_path
    expect(page).to have_selector('.icon-check')
    expect(page).to_not have_selector('.icon-clock-o')
  end

  it "user can view the detailed results for a search" do
    h1 = create(:hashtag, label: 'unabridged')
    h2 = create(:hashtag, label: 'dictionary')
    h3 = create(:hashtag, label: 'defeated')
    create(:hashtag, label: 'a', related_hashtag_ids: [h1.id])
    create(:hashtag, label: 'b', related_hashtag_ids: [h2.id])
    create(:hashtag, label: 'c', related_hashtag_ids: [h3.id])
    create(:request_batch, user: User.last, complete: true, query_terms: ['a', 'b', 'c'])
    visit search_history_path
    click_link 'show top hashtags'
    expect(page).to have_content('unabridged')
    expect(page).to have_content('dictionary')
    expect(page).to have_content('defeated')
  end
end