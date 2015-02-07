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
    descriptor_pairings = `find /tmp/ -name 'screenshot-*.png' -type f -print0 -maxdepth 1 | xargs -0 -n1 -P4 ./find_obj.rb warcraft_logo.png | pv -l | tee /tmp/rspec.log`

    descriptor_pairings = descriptor_pairings.split("\n").map do |line|
      DescriptorPairing.from_line(line).tap {|x| p x }
    end.select do |pair|
      pair.descriptor_count > 100
    end.map(&:timestamp).sort
  end

end

