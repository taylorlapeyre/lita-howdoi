require 'nokogiri'

module Lita
  module Handlers
    class Howdoi < Handler
      GOOGLE_SEARCH_URL = "http://www.google.com/search?q=site:stackoverflow.com+"

      route(/^howdoi (.*)$/, :howdoi, command: true, help: {
        "howdoi QUERY" => "Searches Stack Overflow for the first answer it finds with a solution to QUERY.",
      })

      def get_url(url)
        http.get(url).body
      end

      def is_question?(stackoverflow_url)
        stackoverflow_url =~ %r(/questions/\d+/)
      end

      def get_google_links(args)
        page = get_url(URI.escape(GOOGLE_SEARCH_URL + args.join("+")))
        html = Nokogiri.HTML(page)
        posts = []
        html.css('.r a').each do |link|
          posts << link[:href].gsub("/url?q=", "").gsub(/&(.*)/, "") if is_question?(link[:href])
        end
        posts
      end

      def get_link_at_pos(links, pos)
        link = nil
        pos.times do |i|
          break if i > links.size
          link = links[i]
        end
        link
      end

      def howdoi(chat)
        args = chat.matches[0].last.split
        links = get_google_links(args)
        link = get_link_at_pos(links, 1)

        if link
          page = get_url link
          html = Nokogiri.HTML(page)
          ans = html.at_css(".answer")

          if ans
            instruction = ans.css("pre").children.
              collect(&:content).
              join(" " * 5 + '-' * 50 + "\n") ||
              ans.at_css("code").content
            if instruction
              chat.reply "```\n#{instruction}```"
            else
              chat.reply "```\n#{ans.at('.post-text').content}```"
            end
          end
        else
          chat.reply "Sorry, couldn't find any help with that topic"
        end
      end
    end

    Lita.register_handler(Howdoi)
  end
end
