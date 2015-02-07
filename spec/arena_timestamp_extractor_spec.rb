require_relative '../lib/arena_timestamp_extractor'

describe ArenaTimestampExtractor do
  describe '.extract' do
    let :arena_timestamp_extractor do
      ArenaTimestampExtractor.new(File.new(File.join(__dir__, 'fixtures', 'short-load-screen-clip.mp4')))
    end

    it 'returns event timestamps' do
      timestamps = arena_timestamp_extractor.extract
      expect(timestamps.first).to be_within(2).of(8)
    end
  end
end
