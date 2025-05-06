function tilde_mount --wraps='sshfs troubadour@tilde.club:/home/troubadour ~/tilde.club -o IdentityFile=~/.ssh/id_rsa_troubadour' --description 'alias tilde_mount=sshfs troubadour@tilde.club:/home/troubadour ~/tilde.club -o IdentityFile=~/.ssh/id_rsa_troubadour'
  sshfs troubadour@tilde.club:/home/troubadour ~/tilde.club -o IdentityFile=~/.ssh/id_rsa_troubadour $argv
        
end
