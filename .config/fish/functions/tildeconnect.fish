function tildeconnect --wraps='ssh -i ~/.ssh/id_rsa_troubadour troubadour@tilde.club' --description 'alias tildeconnect ssh -i ~/.ssh/id_rsa_troubadour troubadour@tilde.club'
  ssh -i ~/.ssh/id_rsa_troubadour troubadour@tilde.club $argv
        
end
