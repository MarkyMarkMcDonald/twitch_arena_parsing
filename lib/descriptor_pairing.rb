class DescriptorPairing
  def initialize(descriptor_count, timestamp)
    @descriptor_count, @timestamp = descriptor_count, timestamp
  end

  attr_reader :descriptor_count, :timestamp
end
