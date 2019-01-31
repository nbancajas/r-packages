# source: https://gist.github.com/bmaland/117293
require 'yaml'

module FastDcf
  def self.parse(input)
    input.split("\n\n").collect { |entry| YAML.load(entry) }
  end
end
