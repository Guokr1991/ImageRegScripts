PrintHeader $1 | grep ' dim\[3\]' | awk 'BEGIN { FS = "=" } ; {print $2}'
