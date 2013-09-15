require 'spec_helper'

describe Hilbert::Formula do
  def a n, value=true
    Hilbert::Atom.new n, value
  end

  let(:c) {   a(1) + a(2)   + a(3) }
  let(:d) {   a(3) | a(4)   | a(5) }
  let(:e) { ( a(6) + a(7) ) | a(8) }

  let(:i) { d >> e }

  it 'is immutable' do
    [c, d, e].each do |f|
      expect( f ).to be_frozen
    end
  end

  it 'can build conjuctions' do
    expect( c ).to be_a Hilbert::Conjunction
    expect( c ).to have(3).subformulae
  end

  it 'can build disjunctions' do
    expect( d ).to be_a Hilbert::Disjunction
    expect( d ).to have(3).subformulae
  end

  it 'can build mixed formulae' do
    expect( e ).to be_a Hilbert::Disjunction
    expect( e ).to have(2).subformulae
    expect( e ).to have(3).atoms
  end

  context 'implications' do
    subject { d >> e }

    its(:class)          { should eq Hilbert::Implication }
    its(:converse)       { should eq (   e  >>   d ) }
    its(:contrapositive) { should eq ( (~e) >> (~d)) }
  end
end
