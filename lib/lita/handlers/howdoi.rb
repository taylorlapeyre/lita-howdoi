require 'nokogiri'

module Lita
  module Handlers
    class Howdoi < Handler
      SEARCH_URL = "http://stackoverflow.com/search"

      route(/^howdoi (.*)$/, :howdoi, command: true, help: {
        "howdoi QUERY" => "Searches Stack Overflow for the first answer it finds with a solution to QUERY.",
      })

      def search_stack_overflow_for(search_query)
        page = http.get(SEARCH_URL, q: search_query).body
        html = Nokogiri.HTML(page)
        html.css('.result-link a').map { |link| "http://stackoverflow.com#{link[:href]}" }
      end

      def howdoi(chat)
        search_query = chat.matches[0].last.split.join("+")
        first_result = search_stack_overflow_for(search_query).first

        if first_result
          html = Nokogiri.HTML(http.get(first_result).body)
          answer = html.at_css(".answer")

          if answer
            instruction = answer.css("pre").children.
              collect(&:content).
              join(" " * 5 + '-' * 50 + "\n") ||
              answer.at_css("code").content

            if !instruction.empty?
              chat.reply "```\n#{instruction}```"
            else
              chat.reply "```\n#{answer.at_css('.post-text').content}```"
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
