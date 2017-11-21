#!/bin/bash 
set -e; set -u
_tmp_file="/tmp/tmp.$$.install"
trap "rm -f $_tmp_file; echo bye." EXIT
_progname=$(basename $0)
_progpath=$(cd $(dirname $0);pwd)
_destpath="$HOME/bin" 

mkdir -p "$_destpath/resource"
cd $_progpath

func_install_binaries(){
	ls | grep -v "install.sh" > $_tmp_file
	while read f; do
		test -f $f && test -x $f || continue
		echo "copying.. '$f' to $_destpath/"
		cp "$f" "$_destpath/"
	done < $_tmp_file

	ls resource/*.tpl > $_tmp_file
	while read f ; do
		echo "copying.. '$f' to $_destpath/resource/"
		cp "$f" "$_destpath/resource/"
	done < $_tmp_file
}

func_install_glide_mirrors(){
	dest="$HOME/.glide"
	test -d $dest || (echo "$dest doesnot exist.">&2 && exit 1)
	cp -i $_progpath/resource/glide-mirrors.yaml $dest/mirrors.yaml
}

func_install_dircolors(){
	cp -i $_progpath/resource/dircolors.256dark $HOME/.dircolors
	echo "APPEND 'eval \"\$(dircolors \$HOME/.dircolors)\"' "
	echo "TO YOUR ~/.bashrc OR ~/.profile"
}

func_options(){
	_list="binaries glide_mirrors dircolors"
	> $_tmp_file
	echo "---OPTIONS---"
	i=0; for n in $_list; do
		i=$(($i+1)); echo "func_install_$n">>$_tmp_file
		echo "$i : INSTALL $n"
	done
	echo -n "option: "; read idx
	re='^[0-9]+$'; if ! [[ $idx =~ $re && $idx -ge 1 && $idx -le $i ]];then return 1; fi
	$(head -n $idx $_tmp_file |tail -n 1 ) || return 1
}

while true; do
	func_options && break
done

