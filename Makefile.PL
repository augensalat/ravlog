use inc::Module::Install;

name 'RavLog';
all_from 'lib/RavLog.pm';

requires 'Catalyst' => '5.800050';
requires 'Catalyst::Action::RenderView' => '0.09';
requires 'Catalyst::Authentication::Credential::Password';
requires 'Catalyst::Authentication::Store::DBIx::Class' => '0.1082';
requires 'Catalyst::Plugin::Authentication' => '0.10012';
# requires 'Catalyst::Plugin::Cache' => '0.08';
# requires 'Catalyst::Plugin::Cache::FileCache' => '0.5';
requires 'Catalyst::Plugin::ConfigLoader' => '0.23';
# requires 'Catalyst::Plugin::PageCache' => '0.21';
requires 'Catalyst::Plugin::Session' => '0.22';
requires 'Catalyst::Plugin::Session::State::Cookie' => '0.11';
requires 'Catalyst::Plugin::Session::Store::FastMmap' => '0.11';
requires 'Catalyst::Plugin::Static::Simple' => '0.21';
requires 'Catalyst::View::JSON' => '0.26';
requires 'Catalyst::View::TT' => '0.29';
requires 'CatalystX::SimpleLogin' => '0.08';
requires 'Config::Any::Perl';
requires 'Config::JFDI';
requires 'Crypt::Eksblowfish::Bcrypt';
requires 'DateTime';
requires 'DateTime::Format::MySQL';
requires 'DBIx::Class';
requires 'DBIx::Class::EncodedColumn';
requires 'DBIx::Class::TimeStamp';
requires 'Getopt::Long';
requires 'Gravatar::URL';
requires 'HTML::CalendarMonthSimple';
requires 'HTML::FormHandler';
requires 'HTML::FormHandler::Model::DBIC';
requires 'HTML::SBC';
requires 'HTML::Tree';
requires 'IO::String';
requires 'JSON::XS';
requires 'Module::Pluggable';
requires 'Pod::Usage';
requires 'Pod::Xhtml' => '1.57';
requires 'Quantum::Superpositions';
requires 'SQL::Translator';
requires 'Syntax::Highlight::Engine::Kate';
requires 'TeX::Hyphen';
requires 'Text::Autoformat';
requires 'Text::Highlight';
requires 'Text::Markdown';
requires 'Text::Textile';
requires 'Text::WikiFormat';
requires 'XML::Feed';

# current HTML::Tidy ( > 1.08) is a PITA to install
# test_requires 'Test::HTML::Tidy';
test_requires 'Test::More';
test_requires 'Test::XML::Valid';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
