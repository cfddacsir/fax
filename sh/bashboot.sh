# alias Spyder='/Applications/Spyder.app/Contents/MacOS/Spyder'
# alias spyder='/Applications/Spyder.app/Contents/MacOS/Spyder'
  alias spyder='/opt/homebrew/Caskroom/miniconda/base/bin/spyder'
  alias iterm='. ~/iterm.sh'
#  iterm(){ /Applications/iTerm.app/Contents/MacOS/iTerm2 & }
  function iterm(){
	bin_path_iterm2=/opt/homebrew/Caskroom/iterm2/3.5.5/iTerm.app/Contents/MacOS/iTerm2 
	bin_path_iterm2=/opt/homebrew/Caskroom/iterm2/3.5.5/iTerm.app/Contents/MacOS/ 
	${bin_path_iterm2}/iTerm2 &
  }
