xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do

   xml.title       'mm\'s Blog'
   xml.link        'http://lumengmeng0401.me'
   xml.description 'hello world'

   @articles.each do |article|
     xml.item do
       xml.title       article.title
       xml.link        article_url(article)
       xml.description article.to_html.content
       xml.guid        article_url(article)
     end
   end

 end
end
