import numpy
import matplotlib.pyplot

xpoints = numpy.array([3, 8])
ypoints = numpy.array([3, 40])

matplotlib.pyplot.plot(xpoints, ypoints)

moduleAtRootSpaceString = ' '

numpy.random.random(50000)**2


# next two lines are for a regression test
from tensorflow.python.ops import variable_scope

variable_scope.variable_scope()