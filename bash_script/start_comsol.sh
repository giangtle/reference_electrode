#!/bin/bash
set -e


script_dir=`dirname $0`
echo script_dir

cd "$script_dir"
cd ../

./comsol_job/master.sh