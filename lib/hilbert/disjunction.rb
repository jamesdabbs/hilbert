module Hilbert
  class Disjunction < Formula

    # -- Common formula interface -----

    def ~
      Conjunction.new *map(&:~)
    end

    def verify space
      # FIXME: memoize this verify call
      witness = find { |sf| sf.verify space }
      witness.nil? ? false : witness.verify(space)
    end

    def search value=true, classes=nil
      subs = map { |sf| sf.search value, classes }
      # True if any is true
      # False if all are false
      # Nil if any is nil
      value == false ? intersection(subs) : union(subs)
    end

    def force space, assumptions, theorem, index
      unknown = nil
      each do |sf|
        witnesses = (~sf).verify space
        if witnesses
          assumptions += witnesses
          index  += witnesses.length
        else
          if unknown
            Rails.logger.info "Unable to force #{self} - too many unknowns"
            return
          else
            unknown = sf
          end
        end
      end
      unknown.force space, assumptions, theorem, index
    end

    # ----------
    
    def symbol
      '|'
    end
  end
end
