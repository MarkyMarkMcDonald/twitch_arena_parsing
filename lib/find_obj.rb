# A Demo Ruby/OpenCV Implementation of SURF
# See https://code.ros.org/trac/opencv/browser/tags/2.3.1/opencv/samples/c/find_obj.cpp
require 'opencv'
require 'benchmark'

class FindObj
  include OpenCV

  CV_SURF_PARAMS = CvSURFParams.new(1500)

  def initialize(object_filename)
    object = IplImage.load(object_filename, CV_LOAD_IMAGE_GRAYSCALE)
    @object_keypoints, @object_descriptors = object.extract_surf(CV_SURF_PARAMS)
  end

  def execute!(scene_filename)
    image = IplImage.load(scene_filename, CV_LOAD_IMAGE_GRAYSCALE)

    image_keypoints, image_descriptors = image.extract_surf(CV_SURF_PARAMS)

    ptpairs = find_pairs(@object_keypoints, @object_descriptors, image_keypoints, image_descriptors)
    ptpairs.size
  end

  private

  def compare_surf_descriptors(d1, d2, best, length)
    raise ArgumentError unless (length % 4) == 0
    total_cost = 0
    0.step(length - 1, 4) { |i|
      t0 = d1[i] - d2[i]
      t1 = d1[i + 1] - d2[i + 1]
      t2 = d1[i + 2] - d2[i + 2]
      t3 = d1[i + 3] - d2[i + 3]
      total_cost += t0 * t0 + t1 * t1 + t2 * t2 + t3 * t3
      break if total_cost > best
    }
    total_cost
  end

  def naive_nearest_neighbor(vec, laplacian, model_keypoints, model_descriptors)
    length = model_descriptors[0].size
    neighbor = nil
    dist1 = 1e6
    dist2 = 1e6

    model_descriptors.size.times { |i|
      kp = model_keypoints[i]
      mvec = model_descriptors[i]
      next if laplacian != kp.laplacian

      d = compare_surf_descriptors(vec, mvec, dist2, length)
      if d < dist1
        dist2 = dist1
        dist1 = d
        neighbor = i
      elsif d < dist2
        dist2 = d
      end
    }

    return (dist1 < 0.6 * dist2) ? neighbor : nil
  end

  def find_pairs(object_keypoints, object_descriptors,
                 image_keypoints, image_descriptors)
    object_descriptors.zip(object_keypoints).each_with_index.inject([]) do |memo, ((descriptor, kp), i)|
      nearest_neighbor = naive_nearest_neighbor(descriptor, kp.laplacian, image_keypoints, image_descriptors)
      unless nearest_neighbor.nil?
        memo << i
        memo << nearest_neighbor
      end
      memo
    end
  end
end
