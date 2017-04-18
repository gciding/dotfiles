[ -n "$PS1" ] && source ~/.bash_profile;

# added by Pew
source $(pew shell_config)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gorans/projects/google-cloud-sdk/path.bash.inc' ]; then source '/Users/gorans/projects/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gorans/projects/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/gorans/projects/google-cloud-sdk/completion.bash.inc'; fi
