module Hilbert
  class Conjunction < Formula

    # -- Common formula interface -----

    def ~
      Disjunction.new *subformulae.map(&:~)
    end

    def verify space
      flat_map { |sf| sf.verify(space) or return }
    end

    def search value=true, classes=nil
      subs = map { |sf| sf.search value, classes }
      # True if all are true
      # False if any is false
      # Nil if any is nil
      value ? intersection(subs) : union(subs)
    end

    def force space, assumptions, theorem, index
      each { |sf| sf.force(space, assumptions, theorem, index) rescue nil }
    end

    # ----------

    def symbol
      '+'
    end
  end
end
