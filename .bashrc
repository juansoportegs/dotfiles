#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lah'
alias la='ls -A'

# Nicer prompt with colors and git status
prompt_color() {
  local usercolor='\[\e[1;32m\]'   # bold green
  local hostcolor='\[\e[1;33m\]'  # bold yellow
  local pathcolor='\[\e[1;34m\]'  # bold blue
  local gitcolor='\[\e[1;35m\]'   # bold magenta
  local reset='\[\e[0m\]'
  local promptchar='\$'

  # Git branch
  local gitinfo=""
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    gitinfo="${gitcolor} (${branch})${reset}"
  fi

  PS1="${usercolor}\u${reset}@${hostcolor}\h${reset} ${pathcolor}\w${reset}${gitinfo}\n${promptchar} "
}

PROMPT_COMMAND=prompt_color

# opencode
export PATH=/home/user0/.opencode/bin:$PATH
