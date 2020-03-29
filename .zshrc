export LANG=ja_JP.UTF-8

## zshの基本的な設定

# ディレクトリ名だけでcdする
setopt AUTO_CD

# cdしたら自動的にpushdする
setopt AUTO_PUSHD

# 重複したディレクトリを追加しない
setopt PUSHD_IGNORE_DUPS

# emacs風キーバインドにする
bindkey -e
# vi風キーバインドにする
#bindkey -v

# 単語の区切り設定
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# プロンプトに関する設定
PROMPT="%F{blue}[%n@%m]%f %# "
RPROMPT="%F{magenta}[%~]"

# 補完機能を有効にする
autoload -Uz compinit
compinit

# コマンド訂正
setopt correct

# 補完候補を詰めて表示する
setopt list_packed 

# メニュー選択モード
zstyle ':completion:*:default' menu select=2

# 大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


##  コマンド履歴

# コマンド履歴を保存する
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

#  コマンド履歴をインクリメンタル検索する
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# すでに入力した内容を使ってコマンド履歴を検索する
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^p" history-beginning-search-backward-end

# 同時に起動したzshの間でヒストリを共有する
setopt SHARE_HISTORY

# 同じコマンドをヒストリに残さない
setopt HIST_IGNORE_ALL_DUPS

# ヒストリに保存するときに余分なスペースを削除する
setopt HIST_REDUCE_BLANKS

# スペースから始まるコマンド行はヒストリに残さない
setopt HIST_IGNORE_SPACE


## プラグイン

## プラグインの管理はzplugで行う
## https://github.com/zplug/zplug

source ~/.zplug/init.zsh

# 補完する
zplug "zsh-users/zsh-completions"

# シンタクスハイライト
zplug "zsh-users/zsh-syntax-highlighting"

# 文字入力時に直近の履歴を表示させる
zplug "zsh-users/zsh-autosuggestions"

## 最近移動したディレクトリに移動する : cdr
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# 履歴として保存するディレクトリの最大数を指定する
zstyle ':chpwd:*' recent-dirs-max 200
# cdrコマンドがcdコマンドを兼ねるようにする
zstyle ":chpwd:*" recent-dirs-default true

## 複数のファイルを一括でリネームする : zmv
autoload -Uz zmv
alias zmv='noglob zmv -W'

## バージョン管理システムのリポジトリの情報を表示する : vcs_info
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'


## Theme

## spaceship-promptを使う場合、brewでインストールして以下のコメントを外す
#eval "$(starship init zsh)"


## zplugのロード

# check コマンドで未インストール項目があるかどうか verbose にチェックし
# false のとき（つまり未インストール項目がある）y/N プロンプトで
# インストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load

# zsh-completionsの設定
fpath=(/usr/local/share/zsh-completions(N-/) $fpath)


## シンタクスハイライトの設定
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
