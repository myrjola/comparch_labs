CABAL_PATH=~/.cabal/bin

# Creates the lab report
default:
		${CABAL_PATH}/pandoc -S -o lab1_akkijyrkka_yrjola.pdf \
			--filter ${CABAL_PATH}/pandoc-crossref \
			--filter ${CABAL_PATH}/pandoc-citeproc \
			lab1.md


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
