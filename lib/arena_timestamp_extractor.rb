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
    VideoFrameExtractor.new(video_file.path).execute!
    Dir["/tmp/screenshot*.png"].map do |scene_filename|
      puts "processing #{scene_filename}" if $DEBUG
      descriptor_count = FindObj.new.execute!("warcraft_logo.png", scene_filename)
      timestamp = scene_filename[/\d+/].to_i
      DescriptorPairing.new(descriptor_count, timestamp)
    end.select do |pair|
      pair.descriptor_count > 100
    end.map(&:timestamp).sort
  end

end

