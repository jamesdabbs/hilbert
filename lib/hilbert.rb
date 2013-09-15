%w{ 
  version
  formula
  atom conjunction disjunction implication
  parser
}.each { |f| require_relative "hilbert/#{f}" }
