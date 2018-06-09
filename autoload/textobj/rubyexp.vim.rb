require 'json'

module Rubyexp
  def self.silencer
    $stderr = StringIO.new
    yield
  ensure
    $stderr = STDERR
  end

  silencer do
    require 'parser/current'
  end

  def self.range(line, col, source)
    parser.range(line, col, source)
  end

  def self.parser
    @parsr ||= Parser.new
  end

  class Parser
    def initialize
      @ranges = {}
    end

    def range(line, col, source)
      r = ranges(source)
      res = []
      r.each do |pos|
        bl, bc, el, ec = pos
        next if el < line
        next if el == line && ec < col

        break if line < bl
        break if line == bl && col < bc
        res << pos
      end
      return res.min_by{|p| p[2,2]}
    end

    def ranges(source)
      @ranges[source.to_sym] ||= begin
        node = ::Parser::CurrentRuby.parse(source)
        positions = []
        traverse(node, positions)
        positions.sort!
      end
    end

    def traverse(node, positions)
      r = node.loc.expression
      return unless r
      b = r.begin
      e = r.end
      positions << [b.line, b.column, e.line, e.column]
      node.children.each do |child|
        traverse(child, positions) if child.is_a?(::Parser::AST::Node)
      end
    end
  end
end
