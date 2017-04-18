" File type detection file
" Language:     ecFlow script (and SMS without CDP)
" Maintainer:   Andrew Dawson <andrew.dawson@ecmwf.int>
" Last Change:  2017-04-18
" Remark:       File type detection for ecFlow scripts with file
"               extension .ecf and .sms

au BufRead,BufNewFile *.ecf set filetype=ecflow
au BufRead,BufNewFile *.sms set filetype=ecflow
