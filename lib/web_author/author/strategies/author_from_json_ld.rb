# typed: strict
# frozen_string_literal: true

module WebAuthor
  module Author
    module Strategies
      class AuthorFromJsonLd
        extend T::Sig

        sig { params(page_content: Nokogiri::HTML::Document).returns(T.nilable(String)) }
        def initialize(page_content)
          @page_content = page_content
        end

        sig { returns(T.nilable(String)) }
        def author
          json_ld = @page_content.at_css('script[type="application/ld+json"]')
          json_ld&.text&.match(/"author":\s*"([^"]+)"/)&.captures&.first
        end

        private

          def load_json_lds
            json_ld_scripts = doc.css('script[type="application/ld+json"]')

            json_ld_scripts.filter_map do |script|
              JSON.parse(script.text)
            rescue JSON::ParserError => e
              puts "Error parsing JSON-LD: #{e.message}"
              nil
            end
          end
      end
    end
  end
end
