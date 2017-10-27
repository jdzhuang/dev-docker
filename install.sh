#!/bin/bash

_flist="go-build " # and more...
_dtarget="$HOME/bin" 
mkdir -p "$_dtarget"
for f in $_flist; do 
	echo "copying.. '$f' to $_dtarget/"
	cp "$PWD/$f" "$_dtarget/"
done

