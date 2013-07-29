require 'rss'

module YYFeed
  class FeedItem
    attr_accessor :title, :date

    def initialize
      @title = nil
      @date = nil
    end
  end

  #rss2.0 & rss1.0 & atom specs are integrated within this class.
  class Feed
    attr_accessor :content, :items

    def initialize
      @content = nil
      @items = Array.new
    end

    def title
      if @content.feed_type == "atom"
        return @content.title.content
      elsif @content.feed_type == "rss"
        return @content.channel.title
      end
    end

    def items
      if @content.feed_type == "atom"
        @content.entries.each do |t|
          itemObj = FeedItem.new
          itemObj.title = t.title.content
          itemObj.date = t.updated.content
          @items.push(itemObj)
        end
      elsif @content.feed_type == "rss"
        @content.channel.items.each do |t|
          itemObj = FeedItem.new     
          itemObj.title = t.title
          itemObj.date = t.pubDate
          @items.push(itemObj)
        end
      end
      return @items
    end
  end

  class FeedMeta
    attr_accessor :feeds

    def initialize
      @feeds = Array.new
    end

    def appendFeed(feed)
      feedObj = Feed.new
      feedObj.content = feed
      @feeds.push(feedObj)
    end

    def feeds
      return @feeds
    end
  end 
end
