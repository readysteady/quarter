require 'yaml'

class Quarter
  def encode_with(coder)
    coder.represent_scalar(nil, to_s)
  end

  module ScalarScannerPatch
    QUARTER_AND_YEAR = /\AQ(\d) ?(\d{4})\z/

    YEAR_AND_QUARTER = /\A(\d{4})[\-\/]?Q(\d)\z/

    def tokenize(string)
      if !string.empty? && string.match(QUARTER_AND_YEAR)
        return Quarter.new($2.to_i, $1.to_i)
      end

      if !string.empty? && string.match(YEAR_AND_QUARTER)
        return Quarter.new($1.to_i, $2.to_i)
      end

      super string
    end

    YAML::ScalarScanner.prepend(self)
  end

  private_constant :ScalarScannerPatch
end
