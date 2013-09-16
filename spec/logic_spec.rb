require 'spec_helper'

class Space < OpenStruct
  def =~ formula
    formula.verify self
  end

  def error; raise; end
end

class Hilbert::Atom
  verify Space do |s|
    { property => value } if s.send(property) == value
  end
end

describe Hilbert::Formula do
  let(:x) { Space.new p: true,  q: true }
  let(:y) { Space.new p: false, q: true }
  
  let(:p) { Hilbert::Atom.new :p, true }
  let(:q) { Hilbert::Atom.new :q, true }

  let(:e) { Hilbert::Atom.new :error, true }

  context 'verification' do
    it 'atom' do
      expect( x =~ p ).to eq({ p: true })
      expect( y =~ p ).to be_nil
    end

    it 'conjunction' do
      expect( x =~ (p + q) ).to eq [{p: true}, {q: true}]
      expect( y =~ (p + q) ).to be_nil
    end

    it 'disjunction' do
      expect( x =~ (p | q) ).to eq({ p: true })
      expect( y =~ (p | q) ).to eq({ q: true })
    end

    it 'nests' do
      f = p + ~q
      g = ~p | q
      expect( x =~ f | g ).to eq({ q: true })
    end

    it 'evaluates lazily' do
      expect{ x =~ (p + e) }.to raise_error
      expect{ x =~ (p | e) }.not_to raise_error
    end
  end

  it 'can find objects matching formulae'
end
