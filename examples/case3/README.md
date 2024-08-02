# Case 2: My first Java executable


## Additional things to try out

bazel query "deps(//examples/case3:hello)"

![graph](case3_deps2.png)

vs

bazel query "deps('//examples/case3:hello') intersect //..."

![graph](case3_deps3.png)
