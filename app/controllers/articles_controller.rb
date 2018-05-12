class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    @meta_description = 'mm\'s 所有博客文章.'
  end

  def show
    @article = Article.find(params[:id]).to_html
    @comment = Comment.new
    @comments = @article.comments.order(created_at: :desc)
  end

  def search
    params[:page] = 1 if params[:page].blank?
    @articles = Article.where("title like ? OR content like ?", "%#{params[:search]}%", "%#{params[:search]}%")
    @articles = @articles.page params[:page]
    if @articles.blank?
      flash.now[:error] = '没有你要找的内容'
      return
    end
    @articles.map do |a|
      a.title = a.title.gsub(params[:search].to_s, "<em>#{params[:search]}</em>")
      unless a.content.include?('/uploads/photo/image')
        a.content = a.content.gsub(params[:search].to_s, "<em>#{params[:search]}</em>")
      end
      htmlstring = TruncateHtml::HtmlString.new(a.to_html.content)
      a.content = TruncateHtml::HtmlTruncator.new(htmlstring).truncate
    end
  end
end
