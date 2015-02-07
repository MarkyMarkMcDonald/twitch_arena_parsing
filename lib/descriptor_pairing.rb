class DescriptorPairing
  def self.from_line(line)
    new(*line.scan(/\d+/).map(&:to_i))
  end

  def initialize(descriptor_count, timestamp)
    @descriptor_count, @timestamp = descriptor_count, timestamp
  end

  attr_reader :descriptor_count, :timestamp
end
