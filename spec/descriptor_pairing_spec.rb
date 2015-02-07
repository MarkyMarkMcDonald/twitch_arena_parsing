require_relative '../lib/descriptor_pairing.rb'

describe DescriptorPairing do
  describe '#from_line' do
    it 'parses the number of matching pairs and the frame' do
      descriptor_pairing = DescriptorPairing.from_line('8 /tmp//screenshot-1713.png')
      expect(descriptor_pairing.descriptor_count).to equal(8)
      expect(descriptor_pairing.timestamp).to equal(1713)
    end
  end
end
