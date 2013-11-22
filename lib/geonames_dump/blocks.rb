module GeonamesDump
  class Blocks
    attr_accessor :blocks
    def initialize
      reset
    end

    def reset
      self.blocks = []
    end

    def add_block(&block)
      self.blocks << block
    end

    def empty?
      blocks.empty?
    end

    def call_and_reset
      call
      reset
    end

    def call
      blocks.each do |block|
        block.call
      end
    end
  end
end
