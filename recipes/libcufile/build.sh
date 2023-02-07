#!/bin/bash

# Install to conda style directories
[[ -d lib64 ]] && mv lib64 lib
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/gds
mv samples ${PREFIX}/gds/samples
mv tools ${PREFIX}/gds/tools
[[ -d pkg-config ]] && mv pkg-config ${PREFIX}/lib/pkgconfig
[[ -d "$PREFIX/lib/pkgconfig" ]] && sed -E -i "s|cudaroot=.+|cudaroot=$PREFIX|g" $PREFIX/lib/pkgconfig/cufile*.pc

[[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

for i in `ls`; do
	[[ $i == "build_env_setup.sh" ]] && continue
	[[ $i == "conda_build.sh" ]] && continue
	[[ $i == "metadata_conda_debug.yaml" ]] && continue
	if [[ $i == "lib" ]] || [[ $i == "gds" ]] || [[ $i == "include" ]]; then
		mkdir -p ${PREFIX}/${targetsDir}
		mkdir -p ${PREFIX}/$i
		cp -rv $i ${PREFIX}/${targetsDir}
		for j in `ls $i`; do
			ln -s ../${targetsDir}/$i/$j ${PREFIX}/$i/$j
		done
	else
		cp -rv $i ${PREFIX}
	fi
done
