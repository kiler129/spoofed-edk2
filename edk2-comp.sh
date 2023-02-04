#!/bin/bash

edk2_git="https://github.com/tianocore/edk2.git"
edk2_branch="edk2-stable202211"
edk2_dir="$(pwd)/edk2-comp"

function main()
{
  edk2_compile
}

function edk2_compile()
{
  if [[ -e $edk2_dir ]]; then
    rm -rf $edk2_dir
  fi

  mkdir -p $edk2_dir
  cd $edk2_dir

  git clone --branch $edk2_branch $edk2_git $edk2_dir
  git submodule update --init

  bios_vendor="American Megatrends"
  sed -i "s/\"EDK II\"/\"$bios_vendor\"/" $edk2_dir/MdeModulePkg/MdeModulePkg.dec
  sed -i "s/\"EDK II\"/\"$bios_vendor\"/" $edk2_dir/ShellPkg/ShellPkg.dec

  make -j$(nproc) -C BaseTools
  . edksetup.sh
  OvmfPkg/build.sh -p OvmfPkg/OvmfPkgX64.dsc -a X64 -b RELEASE -t GCC5
}
main
