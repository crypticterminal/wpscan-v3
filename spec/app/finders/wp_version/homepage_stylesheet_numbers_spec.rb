require 'spec_helper'

describe WPScan::Finders::WpVersion::HomepageStylesheetNumbers do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url).extend(CMSScanner::Target::Server::Apache) }
  let(:url)        { 'http://ex.lo/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'wp_version', 'homepage_stylesheet_numbers') }

  xit
end
