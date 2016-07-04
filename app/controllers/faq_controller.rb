class FaqController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests, only: [:faq]

  def faq
  end

  def privacy
  end

  def terms
  end
end