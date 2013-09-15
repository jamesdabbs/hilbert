module Hilbert
  class Implication
    attr_accessor :antecedent, :consequent

    def initialize antecedent, consequent
      @antecedent, @consequent = antecedent, consequent
    end

    def == other
      antecedent == other.antecedent && consequent == other.consequent
    end

    def contrapositive
      @contrapositive ||= (~consequent) >> ~antecedent
    end

    def converse
      @converse ||= consequent >> antecedent
    end
  end
end
