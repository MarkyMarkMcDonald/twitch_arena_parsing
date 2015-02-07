require 'streamio-ffmpeg'

class VideoFrameExtractor

  def initialize(file_path='spec/fixtures/605443292-0.flv', work_directory='/tmp')
    @file_path = file_path
    @work_directory = work_directory
  end

  def duration
    @duration ||= FFMPEG::Movie.new(@file_path).duration
  end

  def extracted_frames
    Dir.glob("#{@work_directory}/screenshot-*.png")
  end

  def execute!
    index_digits = Math.log10(duration).to_i + 1
    `ffmpeg -i #{@file_path} -r 1 #{@work_directory}/screenshot-%0#{index_digits}d.png -loglevel error`
  end

end
