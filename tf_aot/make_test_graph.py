# Copyright 2017 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
"""Generate tensorflow graphs for testing tfcompile."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import argparse
import os
import sys

from tensorflow.python.framework import dtypes
from tensorflow.python.framework import ops
from tensorflow.python.ops import array_ops
from tensorflow.python.ops import math_ops
from tensorflow.python.platform import app

FLAGS = None


def tfmatmul(_):
  x = array_ops.placeholder(dtypes.float32, name='x_hold')
  y = array_ops.placeholder(dtypes.float32, name='y_hold')
  math_ops.matmul(x, y, name='x_y_prod')


def write_graph(build_graph, out_dir):
  """Build a graph using build_graph and write it out."""
  g = ops.Graph()
  with g.as_default():
    build_graph(out_dir)
    filename = os.path.join(out_dir, 'test_graph_%s.pb' % build_graph.__name__)
    with open(filename, 'wb') as f:
      f.write(g.as_graph_def().SerializeToString())


def main(_):
  write_graph(tfmatmul, FLAGS.out_dir)


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.register('type', 'bool', lambda v: v.lower() == 'true')
  parser.add_argument(
      '--out_dir',
      type=str,
      default='',
      help='Output directory for graphs, checkpoints and savers.')
  FLAGS, unparsed = parser.parse_known_args()
  app.run(main=main, argv=[sys.argv[0]] + unparsed)
