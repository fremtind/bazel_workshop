# Case 2: Shell scripts in Bazel

## About the case
This case has a genrule which produces a textfile ( :hello ) and a sh_binary rule. 
The sh_binary rule is used to declare executable shell scripts and has the script as srcs and textfile as data.

![graph](case2.png)
