require 'spec_helper'

describe Hilbert::Formula do
  (:a .. :f).each do |name|
    let(name) { Hilbert::Atom.new name, true }
  end

  def standardize str
    Hilbert::Formula.dump Hilbert::Formula.load str
  end

  def preserves f
    d = Hilbert::Formula.dump f
    expect( d ).to eq standardize d
  end

  it { preserves a + b              }
  it { preserves a | b                 }
  it { preserves a + (b | c)           }
  it { preserves a | (b + c + (d | e)) }
  it { preserves d | (e + f)           }

  pending

  # let :f do
  #   FactoryGirl.create(:property, name: 'Escaped $\sigma$-math').atom
  # end

  # context 'condensed syntax parsing' do

  #   # Need to refer to these so that they are created
  #   before(:each) { a; b; c; }

  #   {
  #     ' ( a +   b) |  c' => '((a = True + b = True) | c = True)',
  #     ' (~a | ~ b) + ~c' => '((a = False | b = False) + c = False)',
  #     '~( a +   b)'      => '(a = False | b = False)'
  #   }.each do |shorthand, standard|
  #     it "parses '#{shorthand}'" do
  #       expect( standardize shorthand ).to eq standard
  #     end
  #   end
  # end
end