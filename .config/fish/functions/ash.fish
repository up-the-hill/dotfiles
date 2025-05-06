function ash --wraps='sshfs 48092231@ash.science.mq.edu.au:/home/48092231 ~/ash/' --wraps='ssh 48092231@ash.science.mq.edu.au' --description 'alias ash=ssh 48092231@ash.science.mq.edu.au'
  ssh 48092231@ash.science.mq.edu.au $argv
        
end
