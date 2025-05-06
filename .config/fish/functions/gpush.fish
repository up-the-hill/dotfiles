function gpush --wraps='git push -u origin main' --description 'alias gpush=git push -u origin main'
  git push -u origin main $argv
        
end
