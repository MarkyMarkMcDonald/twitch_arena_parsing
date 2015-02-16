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
    Parallel.map(VideoFrameExtractor.new(video_file.path).frames, in_threads: 16, progress: 'Reticulating Splines') do |frame|
      descriptor_count = find_obj.execute!(frame.filename)
      DescriptorPairing.new(descriptor_count, frame.timestamp)
    end.select do |pair|
      pair.descriptor_count > 100
    end.map(&:timestamp).sort
  end
end

module Parallel
  def self.add_progress_bar!(items, options)
    if title = options[:progress]
      raise "Progressbar and producers don't mix" if items.producer?
      require 'ruby-progressbar'
      progress = ProgressBar.create(
        :title => title,
        :total => items.size,
        :format => '%t |%E | %B | %a',
        :output => $stderr
      )
      old_finish = options[:finish]
      options[:finish] = lambda do |item, i, result|
        old_finish.call(item, i, result) if old_finish
        progress.increment
      end
    end
  end
end

