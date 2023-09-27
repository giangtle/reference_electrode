#!/bin/bash
set -e

script_dir=`dirname $0`
cd "$script_dir"
cd ../comsol_job/

rm -f *.mph*