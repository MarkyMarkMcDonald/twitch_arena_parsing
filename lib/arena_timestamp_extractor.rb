require 'parallel'
require 'ruby-progressbar'

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
    Parallel.map(
      VideoFrameExtractor.new(video_file.path).frames,
      in_threads: 16,
      progress: {
        title: 'Reticulating Splines',
        output: $stderr
      }
    ) do |frame|
      descriptor_count = find_obj.execute!(frame.filename)
      DescriptorPairing.new(descriptor_count, frame.timestamp)
    end.select do |pair|
      pair.descriptor_count > 100
    end.map(&:timestamp).sort
  end
end
