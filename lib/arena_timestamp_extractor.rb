require_relative 'find_obj'
require_relative 'video_frame_extractor'
require_relative 'descriptor_pairing'

class ArenaTimestampExtractor

  def initialize(video_file)
    @video_file = video_file
  end

  def video_file
    @video_file ||= video_file
  end

  def extract
    find_obj = FindObj.new("warcraft_logo.png")
     VideoFrameExtractor.new(video_file.path).frames.map do |frame|
      puts "processing #{frame.filename}" if ENV['TWITCH_DEBUG']
      descriptor_count = find_obj.execute!(frame.filename)
      DescriptorPairing.new(descriptor_count, frame.timestamp)
    end.select do |pair|
      pair.descriptor_count > 100
    end.map(&:timestamp).sort
  end

end

