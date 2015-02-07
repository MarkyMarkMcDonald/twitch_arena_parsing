# A Demo Ruby/OpenCV Implementation of SURF
# See https://code.ros.org/trac/opencv/browser/tags/2.3.1/opencv/samples/c/find_obj.cpp
require 'opencv'
require 'benchmark'

class FindObj
  include OpenCV

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
    ptpairs = []
    object_descriptors.size.times { |i|
      kp = object_keypoints[i]
      descriptor = object_descriptors[i]
      nearest_neighbor = naive_nearest_neighbor(descriptor, kp.laplacian, image_keypoints, image_descriptors)
      unless nearest_neighbor.nil?
        ptpairs << i
        ptpairs << nearest_neighbor
      end
    }
    ptpairs
  end

  def locate_planar_object(object_keypoints, object_descriptors,
                           image_keypoints, image_descriptors, src_corners)
    ptpairs = find_pairs(object_keypoints, object_descriptors, image_keypoints, image_descriptors)
    n = ptpairs.size / 2
    return nil if n < 4

    pt1 = []
    pt2 = []
    n.times { |i|
      pt1 << object_keypoints[ptpairs[i * 2]].pt
      pt2 << image_keypoints[ptpairs[i * 2 + 1]].pt
    }

    _pt1 = CvMat.new(1, n, CV_32F, 2)
    _pt2 = CvMat.new(1, n, CV_32F, 2)
    _pt1.set_data(pt1)
    _pt2.set_data(pt2)
    h = CvMat.find_homography(_pt1, _pt2, :ransac, 5)

    dst_corners = []
    4.times { |i|
      x = src_corners[i].x
      y = src_corners[i].y
      z = 1.0 / (h[6][0] * x + h[7][0] * y + h[8][0])
      x = (h[0][0] * x + h[1][0] * y + h[2][0]) * z
      y = (h[3][0] * x + h[4][0] * y + h[5][0]) * z
      dst_corners << CvPoint.new(x.to_i, y.to_i)
    }

    dst_corners
  end

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
end
