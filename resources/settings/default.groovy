speaker {
  smooth {
    // presmoothing of scan
    sigma = 1
    // smoothing of structure tensor
    rho = 1
    // contrast parameter
    lambda = 0.1
    // explicit steps to take
    iter = 20
    // time step size
    stepSize = 0.12
  }

  segmentTongue{
    thresholdingType = "OTSU"
  }

  segmentPalate{
    thresholdingType = "OTSU"
  }

  purgeCloud{
    maxDistance = 1
    sideDistance = 140
  }

  matchTongue {
    // size of neighborhood for smoothness term
    geodesicNeighbors = 2
    // chosen weight for smoothness term
    smoothnessTermWeight = 10
    smoothnessTermWeightEnd = 6
    postSmoothnessTermWeight = 0.5
    // weight for landmark term
    landmarkTermWeight = 0.1
    landmarkTermWeightEnd = 0
    // iterations
    iter = 100
    searchRadius = 5
    maxDistance = 5
    // allowed maximum angle difference of normal of nearest neighbor
    maxAngle = 60
  }

  matchPalate {
    // size of neighborhood for smoothness term
    geodesicNeighbors = 2
    // chosen weight for smoothness term
    smoothnessTermWeight = 10
    smoothnessTermWeightEnd = 6
    postSmoothnessTermWeight = 1
    // weight for landmark term
    landmarkTermWeight = 10
    // do not deactivate landmark term -> avoids "shrinking"
    landmarkTermWeightEnd = 10
    // allowed maximum angle difference of normal of nearest neighbor
    maxAngle = 60
    // iterations
    iter = 40
    searchRadius = 4
    maxDistance = 4
  }

  reconstructPalate{

    iterationAmount = 20
    convergenceFactor = 10000000
    projectedGradientTolerance = 0.00001
    maxFunctionEvals = 1000

  }

  fitTongue{
    searchRadius = 4
    iter = 10
    priorSize = 0.5
    convergenceFactor = 10000000
    projectedGradientTolerance = 0.00001
    maxFunctionEvals = 1000
    maxAngle = 60
    maxDistance = 4
  }

  fitPalate{
    searchRadius = 4
    iter = 10
    priorSize = 1
    convergenceFactor = 10000000
    projectedGradientTolerance = 0.00001
    maxFunctionEvals = 1000
    maxAngle = 60
    maxDistance = 4
  }

}
