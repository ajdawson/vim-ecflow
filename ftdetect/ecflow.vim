" File type detection file
" Language:     ecFlow (and SMS) script
" Maintainer:   Andrew Dawson <andrew.dawson@ecmwf.int>
" Last Change:  2017-07-28
" Remark:       File type detection for ecFlow scripts with file
"               extensions .ecf and .sms

au BufRead,BufNewFile *.ecf set filetype=ecflow
au BufRead,BufNewFile *.sms set filetype=ecflow
