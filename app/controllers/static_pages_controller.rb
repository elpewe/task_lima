class StaticPagesController < ApplicationController
  def home
    if logged_in?
    @article = current_user.articles.build if logged_in?
    @feed_items = current_user.feed.paginate(page: params[:page], :per_page =>15)
    end
  end

  def about
  end

  def contact
  end
end
