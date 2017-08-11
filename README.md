# hypervisor-super

A super project to simplify building the Bareflank Hypervisor using the Secure
Systems Lab Multicompiler. This project no longer requires a second "Native"
version of the Multicompiler to correctly build Bareflank. As a result, the
project configuration is greatly simplified. We only require the Bareflank
Hypervisor be cloned into this repository, and make should take care of the
rest.

Either the official Bareflank repository or our fork will work equally well now
that we have support for custom build scripts from Bareflank.

## Automated Installation Instructions
### Invoke Setup Scripts

`./setup`


### Build the Multicompiler

`make multicompiler`

### Configure the Hypervisor

`./configure_hypervisor.sh`


### Build the Bareflank Hypervisor and the Hyperkernel

```
cd hypervisor
export CROSS_CCFLAGS="<desired compile flags for the hypevisor>"
export CROSS_CXXFLAGS="<desired compile flags for the hypevisor>"
export CROSS_LDFLAGS="<desired compile flags for the hypevisor>"
make
```

For example:

```
cd hypervisor
export CROSS_CCFLAGS="-Xclang -nop-insertion -mllvm -shuffle-stack-frames -mllvm -max-stack-pad-size=64 -mllvm -randomize-machine-registers -mllvm -shuffle-globals -mllvm -global-padding-percentage=50 -mllvm -global-padding-max-size=64 -frandom-seed=123"
export CROSS_CXXFLAGS="-Xclang -nop-insertion -mllvm -shuffle-stack-frames -mllvm -max-stack-pad-size=64 -mllvm -randomize-machine-registers -mllvm -shuffle-globals -mllvm -global-padding-percentage=50 -mllvm -global-padding-max-size=64 -frandom-seed=123"
export CROSS_LDFLAGS="--random-seed=123"
make
```

### Run Test

```
make driver_load
make quick

./makefiles/hyperkernel/bfexec/bin/native/bfexec ./makefiles/hyperkernel/tests/basic_driver/bin/cross/basic_driver ./makefiles/hyperkernel/tests/basic_c/bin/cross/basic_c
./makefiles/hyperkernel/bfexec/bin/native/bfexec ./makefiles/hyperkernel/tests/basic_cxx/bin/cross/basic_cxx

make stop
```

## Manual Installation Instructions
### Checkout the Bareflank Hypervisor Source Code

`git clone git@github.com:/securesystemslab/hypervisor.git hypervisor`

or

`git clone https://github.com/Bareflank/hypervisor.git hypervisor`


### Invoke Make

`$ CROSS_CXXFLAGS="<desired compile flags for the hypevisor>" make`

This should build Bareflank's Cross compiler using the Multicompiler source
code and install any package dependencies. By default we use the Bareflank's
`setup_ubuntu_.sh` so if your version of Linux is not ubuntu, please change the
`build_cross_compiler.sh` script to reflect the change in OS. You may also want
to check which packages and software the setup scripts will install on your
system, and comment out the sections you find objectionable.

If you require no package dependencies, and want to build a local version of the cross compiler you may also substitute the following commands inplace of what is done in the build scripts:

```
cd hypervisor
CROSS_COMPILER=clang_38 ./tools/scripts/create_cross_compiler.sh`
touch .cross_compiler_created
cd ..
```

To build the hypervisor:

`CROSS_CXXFLAGS="<desired compile flags for the hypevisor>" make`

Note: the Makefile mirrors all `CROSS_CXXFLAGS` to `CROSS_CCFLAGS` and `CROSS_LDFLAGS`


## To use the Multicompiler as the Bareflank 'Native' Compiler

### Checkout the Multicompiler Super Project

`git clone git@github.com:/ilovepi/multicompiler-automation.git multicompiler`

#### Clone LLVM, Clang, Compiler-rt, Poolalloc, and SVF into the Multicompiler
project:

`git clone -b cfar_38 git@github.com:/securesystemslab/multicompiler-priv.git
multicompiler/llvm`

`git clone -b cfar_38 git@github.com:/securesystemslab/multicompiler-clang-priv.git multicompiler/llvm/tools/clang`

`git clone -b cfar_38 git@github.com:/securesystemslab/multicompiler-compiler-rt-priv.git multicompiler/llvm/projects/compiler-rt`

`git clone -b cfar_38 git@github.com:/securesystemslab/poolalloc multicopilerllvm/projects/poolalloc`

`git clone git@github.com:/rboggild/SVF multicompiler/llvm/projects/svf`


### Using Ansible

If you build on Ubuntu, you may use Ansible to automate installing and building
the Multicompiler. There is a project that will build and install this project
and all of its dependencies, including OS packages. If building on a remote
system you will need to provide the correct credentials through Ansible, and
may need to edit the inventory file to reflect not installing on the local
host. This role was developed for use in a Jenkins job, as the branch name
indicates. In the future these roles may be available on Ansible-Galaxy.

The project can installed by:

```
git clone -b jenkins https://github.com/ilovepi/vagrant-ansible-provisioning.git provision

cd provision

ansible-galaxy install -r requirements.yml ansible-playbook -i inventory playbook.yml --tags initialize

```

NOTE: omit the `--tags initialize` to also immediately build the Multicompiler and Hypervisor

This will install the project to a folder named project, but that can be
changed by providing the variable `project_root` the desired location to
install in either the command line invocation, in `playbook.yml`, or in a `vars`
file.

See http://docs.ansible.com/ansible/playbooks_roles.html for more detailed
information.
