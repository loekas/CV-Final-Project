:beginner: **EPIPOLAR GEOMETRY**
===

The objective of this assignment is to write a function that takes two images as input and computes Fundamental matrix by Normalized 8 point Algorithm with RANSAC.

:beginner: **_FUNDAMENTAL MATRIX ESTIMATION_**

Overall scheme for fundamental matrix and epipolar geometry is defined as follows:

- Detect interest points in each image
- Describe the local appearance of the regions around interest points
- Get a set of supposed matches between region descriptors in each image. Select 20 correspondences from them. _Matched points are needed to be well distributed on the images for an accurate estimation of the fundamental matrix_.
- Estimate the fundamental matrix for the given two images.


:beginner: **_EIGHT POINT ALGORITHM_**



:beginner: **_NORMALIZED EIGHT POINT ALGORITHM_**



:beginner: **_RANSAC NORMALISED EIGHT POINT ALGORITHM_**




**_INCOMPLETE README TO BE COMPLETED, CODE PRESENTED WORKS FINE THOUGH_**

N.B. Affine covariant region detection with the help of : http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
