function copy --wraps='xclip -sel clip' --description 'alias copy=xclip -sel clip'
  xclip -sel clip $argv
        
end
