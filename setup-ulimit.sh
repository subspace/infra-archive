#!/bin/bash

# file size
ulimit -f unlimited
# cpu time
ulimit -t unlimited
# virtual memory
ulimit -v  unlimited
# locked-in-memory size
ulimit -l unlimited
# open files
ulimit -n 64000
# memory size
ulimit -m unlimited
# processes/threads
ulimit -u 64000
