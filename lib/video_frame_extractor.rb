require 'streamio-ffmpeg'

class VideoFrameExtractor
  Frame = Struct.new(:filename, :timestamp)

  def initialize(file_path, work_directory='/tmp')
    @file_path = file_path
    @work_directory = work_directory
  end

  def duration
    @duration ||= FFMPEG::Movie.new(@file_path).duration
  end

  def frames
    index_digits = Math.log10(duration).to_i + 1
    `ffmpeg -i #{@file_path} -r 1 #{@work_directory}/screenshot-%0#{index_digits}d.png -loglevel error`
    Dir.glob("#{@work_directory}/screenshot-*.png").map do |filename|
      Frame.new(filename, filename[/\d+/].to_i)
    end
  end

end
