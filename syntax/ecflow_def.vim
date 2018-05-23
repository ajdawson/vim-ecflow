" Vim syntax file
" Language:	    ecFlow (and SMS) definitions
" Maintainer:   Andrew Dawson <andrew.dawson@ecmwf.int>
" Last Change:  2018-02-19
" Remark:       Basic syntax for ecFlow definition files.

" ----------------------------------------------------------------------
" Check for "b:current_syntax". If it is defined, some other syntax file,
" earlier in 'runtimepath' was already loaded:
" ----------------------------------------------------------------------
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" ----------------------------------------------------------------------
" Include all syntax files for sh before defining extra syntax, this
" allows support for SMS definitions with IOI and CDP commands as well
" as ecFlow definitions (can be removed when SMS support is removed):
" ----------------------------------------------------------------------
runtime! syntax/tcsh.vim syntax/tcsh/*.vim
if exists("b:current_syntax")
    unlet b:current_syntax
endif
"-----------------------------------------------------------------------

" Comments
syntax match ecfDefComment '\v#.*'
highlight link ecfDefComment Comment

" Syntax elements describing nodes of the suite tree (suite/family/task)
syntax match ecfDefNode '\v(suite|family|task)' nextgroup=ecfDefNodeName skipwhite
syntax match ecfDefNodeName '\v[a-z|A-Z|0-9|_]+' contained
syntax keyword ecfDefNodeEnd endfamily endsuite
highlight link ecfDefNode Identifier
highlight link ecfDefNodeEnd Identifier
highlight link ecfDefNodeName Identifier

" Elements that contain ecFlow attributes:
syntax match ecfDefAttribute '\v(edit|label|event|limit|inlimit|meter)' nextgroup=ecfDefAttributeName skipwhite
syntax match ecfDefAttributeName '\v[A-Z|a-z|0-9|_|:|/]+' contained nextgroup=ecfDefAttributeValue skipwhite
syntax match ecfDefAttributeValue '\v.*' contained
highlight link ecfDefAttribute Operator
highlight link ecfDefAttributeName Constant
highlight link ecfDefAttributeValue String

" Elements that contain ecFlow expressions (e.g. trigger, complete, late)
syntax match ecfDefExpr '\v^\s*(trigger|complete|late)' nextgroup=ecfDefExprValue skipwhite
syntax match ecfDefExprValue '\v.*' contained
highlight link ecfDefExpr Operator
highlight link ecfDefExprValue Function

" Defstatus is highlighted differently to other attributes/expressions
" to draw attention to it
syntax match ecfDefDefstatus '\vdefstatus (complete|queued|aborted|active)'
highlight link ecfDefDefstatus Underlined

" Repeats have a type as well as a name and value
syntax match ecfDefRepeat '\vrepeat' nextgroup=ecfDefRepeatType skipwhite
syntax match ecfDefRepeatType '\v(date|day|month|year|integer|enumerated|string)' nextgroup=ecfDefAttributeName skipwhite
highlight link ecfDefRepeat Todo
highlight link ecfDefRepeatType Todo
