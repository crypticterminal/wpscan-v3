module WPScan
  module Finders
    module DynamicFinder
      module Version
        # Version finder using by parsing config files, such as composer.json
        # and so on
        class ConfigParser < WPScan::Finders::DynamicFinder::Version::Finder
          ALLOWED_PARSERS = [JSON, YAML].freeze

          def self.child_class_constants
            @child_class_constants ||= super.merge(
              PARSER: nil, KEY: nil, PATTERN: /(?<v>\d+\.[\.\d]+)/, CONFIDENCE: 70
            )
          end

          # @param [ String ] body
          # @return [ Hash, nil ] The parsed body, with an available parser, if possible
          def parse(body)
            parsers = ALLOWED_PARSERS.include?(self.class::PARSER) ? [self.class::PARSER] : ALLOWED_PARSERS

            parsers.each do |parser|
              begin
                parsed = parser.respond_to?(:safe_load) ? parser.safe_load(body) : parser.load(body)

                return parsed if parsed.is_a?(Hash)
              rescue StandardError
                next
              end
            end

            nil # Make sure nil is returned in case none of the parsers manage to parse the body correctly
          end

          # No Passive way
          def passive(opts = {}); end

          # @param [ Typhoeus::Response ] response
          # @param [ Hash ] opts
          # @return [ Version ]
          def find(response, _opts = {})
            parsed_body = parse(response.body)

            return unless (data = parsed_body&.dig(*self.class::KEY.split(':'))) && data =~ self.class::PATTERN

            create_version(
              Regexp.last_match[:v],
              interesting_entries: ["#{response.effective_url}, Match: '#{Regexp.last_match}'"]
            )
          end
        end
      end
    end
  end
end
