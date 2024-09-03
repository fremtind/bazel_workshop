# Case 1

## About the case

`genrule` is a generic Bazel rule that lets you execute shell commands.

The given example shows how to create a simple `genrule` that prints "Hello, World!" to a file.

It also shows how to consume a file produced by another target.

```
bazel build //workshop/case1:hello
cat bazel-bin/workshop/case1/hello.txt
```
```
bazel build //workshop/case1:hello_replaced
cat bazel-bin/workshop/case1/replaced.txt
```

## Things to try out

### Change one of the targets
Does all or only some of the targets rebuild?
Try changing different targets, and run `bazel build //workshop/case1:hello_replaced` to see what happens.

### Does the tests fail if you change the `genrule` to produce a file with a different content?
Try changing a file and run `bazel test //workshop/case1:all`

## Additional things to try out

### Query the build graph
One of Bazels strengths is the query language on the build graph.

To see dependencies for the `hello_replaced` target, run:
`bazel query 'deps(//workshop/case1:hello_replaced)'`

To see which targets depend on the `hello` target, run:
`bazel query 'rdeps(//..., //workshop/case1:hello)'`

![graph](case1.png)

### Inspect the bazel output tree
In the root of the repository, you should notice 4 `bazel-` directories:
```
<workspace-name>/                         <== The workspace root
  bazel-bazel_workshop => <..._main>      <== Symlink to execRoot
  bazel-out => <...bazel-out>             <== Convenience symlink to outputPath
  bazel-bin => <...bin>                   <== Convenience symlink to most recent written bin dir $(BINDIR)
  bazel-testlogs => <...testlogs>         <== Convenience symlink to the test logs directory
```

Bazel uses the `execRoot` to store build outputs in the tree.
When you run an action, the default is that Bazel creates a sandboxed environment for the action to run in. Then the output of the action is stored in the `execRoot`, according to the directory layout.

You can inspect the `bazel-out` directory to see the outputs of the build actions, including runfiles.

Read more about the [Bazel output tree](https://bazel.build/remote/output-directories).
