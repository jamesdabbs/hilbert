require 'spec_helper'

# -- Example binding to an external class -----

class Space < OpenStruct
  def =~ formula
    formula.verify self
  end

  def error; raise; end
end


# -- Construction of the searchable universe -----

P = Hilbert::Atom.new :p,     true
Q = Hilbert::Atom.new :q,     true
R = Hilbert::Atom.new :r,     true
E = Hilbert::Atom.new :error, true

X = Space.new p: true,  q: true
Y = Space.new p: false, q: true

Spaces = [X, Y]

class Hilbert::Atom
  verify Space do |s|
    { property => value } if s.send(property) == value
  end

  search Space do |expected|
    Spaces.select { |s| expected == s.send(property) }
  end
end

describe Hilbert::Formula do
  context 'verification' do
    it 'atom' do
      expect( X =~ P ).to eq({ p: true })
      expect( Y =~ P ).to be_nil
    end

    it 'conjunction' do
      expect( X =~ (P + Q) ).to eq [{p: true}, {q: true}]
      expect( Y =~ (P + Q) ).to be_nil
    end

    it 'disjunction' do
      expect( X =~ (P | Q) ).to eq({ p: true })
      expect( Y =~ (P | Q) ).to eq({ q: true })
    end

    it 'nests' do
      f = P + ~Q
      g = ~P | Q
      expect( X =~ f | g ).to eq({ q: true })
    end

    it 'evaluates lazily' do
      expect{ X =~ (P + E) }.to raise_error
      expect{ X =~ (P | E) }.not_to raise_error
    end
  end


  context 'search' do
    it 'atom' do
      expect( P.search ).to eq Set.new([X])
      expect( Q.search ).to eq Set.new([X, Y])

      expect( P.search false ).to eq Set.new([Y])
      expect( P.search nil   ).to eq Set.new
      expect( R.search nil   ).to eq Set.new([X, Y])
    end

    it 'conjunction' do
      f = P + Q
      expect( f.search       ).to eq Set.new([X])
      expect( f.search false ).to eq Set.new([Y])
      expect( f.search nil   ).to eq Set.new
    end

    it 'disjunction' do
      f = P | Q
      expect( f.search       ).to eq Set.new([X, Y])
      expect( f.search false ).to eq Set.new
      expect( f.search nil   ).to eq Set.new
    end
  end
end
