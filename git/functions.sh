# Show all commit since defined period
gwc() {
	local ago="$1"

	git whatchanged --since="${ago}"
}

# Remove all branch passed in param
gbrm() {
	for var in "$@"
	do
    	git branch -d "$var"
		git push origin --delete "$var"
	done
}
