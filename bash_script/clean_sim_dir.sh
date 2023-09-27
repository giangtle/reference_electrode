#!/bin/bash
set -e

script_dir=`dirname $0`
cd "$script_dir"
cd ../simulation_result/

rm -f *.temp