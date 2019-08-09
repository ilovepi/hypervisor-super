#!/bin/bash -e
MC_C_FLAGS="-Xclang -nop-insertion -mllvm -nop-insertion-percentage=50 -mllvm -max-nops-per-instruction=5 -frandom-seed=42 "
MC_CXX_FLAGS=${MC_C_FLAGS}
MC_LD_FLAGS=""

pushd ..
MULTICOMPILER_C_FLAGS="${MC_C_FLAGS}" MULTICOMPILER_CXX_FLAGS="${MC_CXX_FLAGS}" \
MULTICOMPILER_LD_FLAGS="${MC_LD_FLAGS}" make hypervisor_using_multicompiler
popd
