require 'pry'

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end


require_relative '../lib/hilbert'

RSpec.configure do |config|
  config.order = "random"

  config.fail_fast = false

  # The following settings allow you to add :focus to a spec or context
  # and run only those specs
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.filter_run_excluding slow: true
  config.run_all_when_everything_filtered = true
end
