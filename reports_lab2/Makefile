# Creates the lab report
default:
		pandoc -S -o lab2_akkijyrkka_yrjola.pdf \
			--filter pandoc-crossref \
			--filter pandoc-citeproc \
			./lab2.md


# Installs all the dependencies to generate the report
build_deps_linux:
		sudo apt-get update
		sudo apt-get dist-upgrade -y
		sudo apt-get install -y texlive texlive-publishers python-pip graphviz
		sudo pip install pandocfilters
		cabal update
		cabal install pandoc
		cabal install pandoc-crossref pandoc-citeproc


build_deps_macos:
		brew tap homebrew/science
		brew install pandoc pandoc-citeproc pandoc-crossref R
		brew cask install mactex
