require 'nokogiri'

module Lita
  module Handlers
    class Howdoi < Handler
      GOOGLE_SEARCH_URL = "http://stackoverflow.com/search"

      route(/^howdoi (.*)$/, :howdoi, command: true, help: {
        "howdoi QUERY" => "Searches Stack Overflow for the first answer it finds with a solution to QUERY.",
      })

      def get_url(url, q="")
        http.get(url, q: q).body
      end

      def is_question?(stackoverflow_url)
        stackoverflow_url =~ %r(/questions/\d+/)
      end

      def get_google_links(args)
        page = get_url(GOOGLE_SEARCH_URL, args)
        html = Nokogiri.HTML(page)
        posts = []
        html.css('.result-link a').each do |link|
          posts << "http://stackoverflow.com#{link[:href]}"
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
        args = chat.matches[0].last.split.join("+")
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

            unless instruction.empty?
              chat.reply "```\n#{instruction}```"
            else
              p ans.at_css('.post-text').content
              chat.reply "```\n#{ans.at_css('.post-text').content}```"
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
