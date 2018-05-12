require 'markdown'
class Article < ActiveRecord::Base
  has_many :comments

  validates :title, :content, presence: true

  default_scope -> { where(self_info: false) }

  def self.self_info
    Article.unscoped.where(self_info: true).first || Article.create(title: '个人信息', content: 'mm', self_info: true)
  end

  def short_title
    if title.length > 10
      title[0..10] + '...'
    else
      title
    end
  end

  def to_html
    self.content = content_html
    self
  end

  def content_html
    self.class.render_html(self.content)
  end

  def self.render_html(content)
    rd = CodeHTML.new
    md = Redcarpet::Markdown.new(rd, autolink: true, fenced_code_blocks: true)
    md.render(content)
  end
end
