load("//tensorflow/compiler/aot:tfcompile.bzl", "tf_library")


tf_library(
    name = "test_graph_tfmatmul",
    cpp_class = "foo::bar::MatMulComp",
    graph = "test_graph_tfmatmul.pb",
    config = "test_graph_tfmatmul.config.pbtxt",
)

cc_binary(
    name = "experiment_binary",
    srcs = [
        "test_graph_tfmatmul.cc",
        "test_graph_tfmatmul.h",
    ],
    deps = [
        ":test_graph_tfmatmul",
        "//third_party/eigen3",
    ],
    linkopts = [
          "-lpthread",
    ],
)
