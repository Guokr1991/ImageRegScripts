PrintHeader $1 | grep 'Voxel Spacing' | awk 'BEGIN { FS = ":" } ; {print $2}'
