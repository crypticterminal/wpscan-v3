module WPScan
  module Controller
    # Wp Version Controller
    class WpVersion < CMSScanner::Controller::Base
      def cli_options
        [
          OptBoolean.new(['--wp-version-all', 'Check all the version locations']),
          OptChoice.new(
            ['--wp-version-detection MODE',
             'Use the supplied mode for the WordPress version detection, ' \
             'instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive),
            normalize: :to_sym
          )
        ]
      end

      def run
        output(
          'version',
          version: target.wp_version(
            mode: parsed_options[:wp_version_detection] || parsed_options[:detection_mode],
            confidence_threshold: parsed_options[:wp_version_all] ? 0 : 100,
            show_progression: user_interaction?
          )
        )
      end
    end
  end
end
