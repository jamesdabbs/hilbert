require 'spec_helper'

describe Hilbert::Atom do
  (:a .. :e).each do |name|
    let(name) { Hilbert::Atom.new name, true }
  end

  it 'is immutable' do
    expect( a ).to be_frozen
  end

  it 'can be compared to others' do
    a2 = Hilbert::Atom.new :a, true

    expect( a ).to eq a2
  end
  
  it 'supports property objects'
  it 'supports value objects'
end
