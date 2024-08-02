# Case 2: My first Java executable


## Additional things to try out

bazel query "deps(//examples/case3:hello)" 

vs

bazel query "deps('//examples/case3:hello') intersect //..."