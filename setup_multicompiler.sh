#!/bin/bash -e

git clone git@github.com:/securesystemslab/multicompiler-automation.git multicompiler
 
pushd multicompiler

#./fetch_multicompiler.sh
./build.sh

# compiler-rt is not used by Bareflank, and currently it doesn't compile:
# https://github.com/securesystemslab/multicompiler-priv/blob/cfar_38/README.md#patch-printfh-from-glibc

rm -Rf llvm/projects/compiler-rt

popd
