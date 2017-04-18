" Vim syntax file
" Language:	    ecFlow script (and SMS without CDP)
" Maintainer:   Andrew Dawson <andrew.dawson@ecmwf.int>
" Last Change:  2017-04-18
" Remark:       A small extra layer over the sh syntax to add ecFlow
"               directives

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
" Include all syntax files for sh before defining extra syntax:
" ----------------------------------------------------------------------
runtime! syntax/sh.vim syntax/sh/*.vim

" ----------------------------------------------------------------------
" Define a syntax group containing all top-level ecFlow syntax except
" ecfVariable:
" ----------------------------------------------------------------------
syntax cluster Ecf contains=ecfInclude,ecfNoppBlock,ecfComment,ecfManual,ecfMicro

" ----------------------------------------------------------------------
" Highlight ecFlow variables, they can be contained within any shell
" script syntax, but not within other ecFlow syntax:
" ----------------------------------------------------------------------
syntax match ecfVariable '\v\%\S{-}\%' containedin=ALLBUT,@Ecf
highlight link ecfVariable Underlined

" ----------------------------------------------------------------------
" Handle the ecFlow "%include" directive:
" ----------------------------------------------------------------------
syntax match  ecfInclude '\v^\%include '     nextgroup=ecfIncludeRaw,ecfIncludeString,ecfIncludeAngle
syntax match  ecfInclude '\v^\%includeonce ' nextgroup=ecfIncludeRaw,ecfIncludeString,ecfIncludeAngle
syntax match  ecfInclude '\v^\%includenopp ' nextgroup=ecfIncludeRaw,ecfIncludeString,ecfIncludeAngle
syntax match  ecfIncludeRaw '\v\S+' contained
syntax region ecfIncludeString matchgroup=ecfIncludeText start='\V"' end='\V"' contained
syntax region ecfIncludeAngle  matchgroup=ecfIncludeBrackets start="\V<" end="\V>" contained
highlight link ecfIncludeString   String
highlight link ecfIncludeAngle    String
highlight link ecfIncludeBrackets String
highlight link ecfIncludeRaw      String
highlight link ecfInclude         Include

" ----------------------------------------------------------------------
" Handle the "%comment" directive:
" ----------------------------------------------------------------------
syntax region ecfComment start='\v^\%comment\s*$' end='\v^\%end\s*$'
highlight link ecfComment Comment

" ----------------------------------------------------------------------
" Handle the "%manual" directive:
" ----------------------------------------------------------------------
syntax region ecfManual start='\v^\%manual\s*$' end='\v^\%end\s*$' contains=ecfInclude
highlight link ecfManual SpecialComment

" ----------------------------------------------------------------------
" Highlight the "%ecfmicro" directive:
" Note:
"   We don't account for this changing in the highlighting definition,
"   we just assume "%" is the micro throughout.
" TODO:
"   Re-write in a similar style to include.
" ----------------------------------------------------------------------
"syntax match ecfMicro '\v^\%ecfmicro +\S'
"highlight link ecfMicro Macro

syntax match ecfMicro '\v^\%ecfmicro' nextgroup=ecfMicroChar
syntax match ecfMicroChar '\v\s+\S' contained
highlight link ecfMicro Macro
highlight link ecfMicroChar String

" ----------------------------------------------------------------------
" Highlight plain shell script inside a "%nopp" directive block:
" ----------------------------------------------------------------------
if exists("b:current_syntax")
    " Record the b:current_syntax variable before un-letting it:
    let s:current_syntax = b:current_syntax
    unlet b:current_syntax
endif
" Refer to the syntax sh-hack.vim as @Sh, we use sh-hack.vim instead of
" sh.vim because we have added implicit "contains=ecfVariable" to the
" sh.vim syntax for shDoubleQuote and shSingleQuote, but we don't want
" that to apply within the "%nopp" directive:
syntax include @ShHack syntax/sh-hack.vim
try
    " Also attempt to load any user-specified extensions to sh.vim into
    " the @Sh syntax:
    syntax include @ShHack after/syntax/sh.vim
catch
endtry
if exists("s:current_syntax")
    " Reset the b:current_syntax to whatever it was before we unset it:
    let b:current_syntax = s:current_syntax
else
    " Ensure b:current syntax remains unset as it was before we started
    " (it may become set when loading syntax):
    unlet b:current_syntax
endif
" Define the "%nopp" directive region, and highlight anything in it as
" normal sh.vim would, and give the directive itself the constant color
" (inidcative that variables within are actually constants):
syntax region ecfNoppBlock matchgroup=ecfNopp start='\v^\%nopp\s*$' end='\v^\%end\s*$' contains=@ShHack
highlight link ecfNopp Constant

" ----------------------------------------------------------------------
" Highlighting for ecFlow syntax errors:
" ----------------------------------------------------------------------

" An %include directive with leading space is invalid:
syntax match ecfError '\v^\s+\%include.*'

" A %comment directive with leading space characters or trailing
" non-space characters is invalid:
syntax match ecfError '\v^\s+\%comment.*'
syntax match ecfError '\v^\%comment\s*\S+' containedin=ecfComment

" A %manual directive with leading space characters or trailing
" non-space characters is invalid:
syntax match ecfError '\v^\s+\%manual.*'
syntax match ecfError '\v^\%manual\s*\S+' containedin=ecfManual

" An %ecfmicro directive with leading space or any trailing non-space
" characters is invalid:
syntax match ecfError '\v^\s+\%ecfmicro.*'
syntax match ecfError '\v^\%ecfmicro\s+\S\s*\S+'

" A %nopp directive with leading space characters or trailing non-space
" characters is invalid:
syntax match ecfError '\v^\s+\%nopp.*'
syntax match ecfError '\v^\%nopp\s*\S+' containedin=ecfNoppBlock

" An %end directive without a starting directive is invalid:
syntax match ecfError '\v^\%end.*'
" Space before an %end directive is invalid:
syntax match ecfError '\v^\s+\%end.*'  containedin=ecfComment,ecfManual,ecfNoppBlock
" Any non-space characters on the same line as an %end directive is
" invalid:
syntax match ecfError '\v^\%end\s*\S+' containedin=ecfComment,ecfManual,ecfNoppBlock

highlight link ecfError Error

" ----------------------------------------------------------------------
" Set the name of the current syntax to "ecflow", must be done last:
" ----------------------------------------------------------------------
let b:current_sytnax = "ecflow"
