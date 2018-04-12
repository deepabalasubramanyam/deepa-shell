# This script helps to analyze the output of the "sar -q" command.
# It prints columns 1, 4, 5, and 6 of every output line. On
# the first line of the ouput, it prints a header line and filters
# out all other lines.
#
# Usage: sar -q | awk -f advbash4.awk

BEGIN { printf "Time\theader 1\theader 2\theader 3\theader 4\n" }
/^[[:digit:][:punct:][:space:][:alpha:]]+$/ { print $1, $4, $5, $6 }

