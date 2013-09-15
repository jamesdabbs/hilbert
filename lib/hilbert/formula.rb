module Hilbert
  class Formula
    class ParseError < StandardError
    end

    include Enumerable

    attr_accessor :subformulae

    def initialize *subformulae
      @subformulae = subformulae

      freeze
    end

    def + other
      Conjunction.new(self, other).flatten
    end
    alias_method :&, :+

    def | other
      Disjunction.new(self, other).flatten
    end

    def >> other
      Implication.new self, other
    end

    def == other
      # This is a somewhat restrictive definition, but suffices for our
      # purposes. Note that the general problem of determining if two
      # formulae are logically equivalent is NP-complete.
      self.class == other.class && self.subformulae == other.subformulae
    end

    def each &block
      subformulae.each &block
    end

    # -- Common formula interface -----

    def self.load str
      return str if str.nil? || str.is_a?(Formula)
      p = Parser.new str
      f = if p.conjunction.nil?
        Atom.load str
      else
        p.subformulae.map { |s| load s }.inject &p.conjunction.to_sym
      end
      p.negated? ? ~f : f
    end

    def self.dump formula
      formula.to_s { |atom| Atom.dump atom }
    end

    def to_s &block
      '(' + map { |s| s.to_s(&block) }.join(" #{symbol} ") + ')'
    end

    def atoms
      map(&:atoms).flatten
    end

    # ----------

    def flatten
      self.class.new(*inject([]) do |fs, f|
        if f.class == self.class
          fs += f.subformulae
        else
          fs << f
        end
      end)
    end

    private # ----------

    # TODO: improve using the fact that each array is sorted
    def intersection arrays
      arrays.inject &:&
    end

    def union arrays
      arrays.inject &:|
    end
  end
end
