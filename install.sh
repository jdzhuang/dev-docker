#!/bin/bash
set -e
set -u
_tmp_file="/tmp/tmp.$$.install"
trap "rm -f $_tmp_file; echo bye." EXIT
_progname=$(basename $0)
_progpath=$(cd $(dirname $0);pwd)

_dtarget="$HOME/bin" 
mkdir -p "$_dtarget/resource"
echo "$_progname $_progpath"

cd $_progpath
ls | grep -v "install.sh" > $_tmp_file
while read f; do
	if [[ -f $f && -x $f ]]; then
		echo "copying.. '$f' to $_dtarget/"
		cp "$f" "$_dtarget/"
	fi
done < $_tmp_file

ls resource > $_tmp_file
while read f ; do
	echo "copying.. 'resource/$f' to $_dtarget/resource/"
	cp "resource/$f" "$_dtarget/resource/"
done < $_tmp_file
cp -i resource/glide-mirrors.yaml $HOME/.glide/mirrors.yaml
cp -i resource/dircolors.256dark $HOME/.dircolors


