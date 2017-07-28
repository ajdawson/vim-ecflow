" Vim syntax file
" Language:	    ecFlow (and SMS) script
" Maintainer:   Andrew Dawson <andrew.dawson@ecmwf.int>
" Last Change:  2017-07-28
" Remark:       A layer over the sh syntax to add ecFlow directives

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
if exists("b:current_syntax")
    unlet b:current_syntax
endif

" ----------------------------------------------------------------------
" Define a syntax group containing all top-level ecFlow syntax except
" ecfVariable:
" ----------------------------------------------------------------------
syntax cluster Ecf contains=ecfInclude,ecfNoppBlock,ecfComment,ecfManual,ecfMicro

" ----------------------------------------------------------------------
" Highlight ecFlow variables, they can be contained within any shell
" script syntax, but not within other ecFlow syntax:
" ----------------------------------------------------------------------
syntax match ecfVariable '\v\%\S{1,}\%' containedin=ALLBUT,@Ecf
highlight link ecfVariable Underlined

" ----------------------------------------------------------------------
" Handle the ecFlow "%include" directive:
" ----------------------------------------------------------------------
syntax match  ecfInclude '\v^\%include '     nextgroup=ecfIncludeRaw,ecfIncludeString,ecfIncludeAngle containedin=ALLBUT,@Ecf
syntax match  ecfInclude '\v^\%includeonce ' nextgroup=ecfIncludeRaw,ecfIncludeString,ecfIncludeAngle containedin=ALLBUT,@Ecf
syntax match  ecfInclude '\v^\%includenopp ' nextgroup=ecfIncludeRaw,ecfIncludeString,ecfIncludeAngle containedin=ALLBUT,@Ecf
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
syntax region ecfComment start='\v^\%comment\s*$' end='\v^\%end\s*$' containedin=ALLBUT,@Ecf
highlight link ecfComment Comment

" ----------------------------------------------------------------------
" Handle the "%manual" directive:
" ----------------------------------------------------------------------
syntax region ecfManual start='\v^\%manual\s*$' end='\v^\%end\s*$' contains=ecfInclude containedin=ALLBUT,@Ecf
highlight link ecfManual SpecialComment

" ----------------------------------------------------------------------
" Highlight the "%ecfmicro" directive:
" Note:
"   We don't account for this changing in the highlighting definition,
"   we just assume "%" is the micro throughout.
" ----------------------------------------------------------------------
syntax match ecfMicro '\v^\%ecfmicro' nextgroup=ecfMicroChar containedin=ALLBUT,@Ecf
syntax match ecfMicroChar '\v\s+\S' contained
highlight link ecfMicro Macro
highlight link ecfMicroChar String

" ----------------------------------------------------------------------
" Highlight plain shell script inside a "%nopp" directive block:
" ----------------------------------------------------------------------
" Refer to the syntax sh-hack.vim as @Sh, we use sh-hack.vim instead of
" sh.vim because we have added implicit contains=ecfVariable to the
" sh.vim syntax but we don't want that to apply within the %nopp
" directive:
try
    syntax include @ShHack syntax/sh-hack.vim
    try
        " Also attempt to load any user-specified extensions to sh.vim into
        " the @Sh syntax:
        syntax include @ShHack after/syntax/sh.vim
    catch
    endtry
    " Define the "%nopp" directive region, and highlight anything in it as
    " normal sh.vim would, and give the directive itself the constant color
    " (inidcative that variables within are actually constants):
    syntax region ecfNoppBlock matchgroup=ecfNopp start='\v^\%nopp\s*$' end='\v^\%end\s*$' contains=@ShHack
catch
    echoerr "failed to load sh-hack.vim, did you forget to run the build_syntax script?"
endtry
highlight link ecfNopp Constant

" ----------------------------------------------------------------------
" Highlighting for ecFlow syntax errors:
" ----------------------------------------------------------------------

" An %include directive with leading space is invalid:
syntax match ecfError '\v^\s+\%include.*' containedin=ALL

" A %comment directive with leading space characters or trailing
" non-space characters is invalid:
syntax match ecfError '\v^\s+\%comment.*' containedin=ALL
syntax match ecfError '\v^\%comment\s*\S+.*' containedin=ALL

" A %manual directive with leading space characters or trailing
" non-space characters is invalid:
syntax match ecfError '\v^\s+\%manual.*' containedin=ALL
syntax match ecfError '\v^\%manual\s*\S+.*' containedin=ALL

" An %ecfmicro directive with leading space or any trailing non-space
" characters is invalid:
syntax match ecfError '\v^\s+\%ecfmicro.*' containedin=ALL
syntax match ecfError '\v^\%ecfmicro\s+\S\s*\S+.*' containedin=ALL

" A %nopp directive with leading space characters or trailing non-space
" characters is invalid:
syntax match ecfError '\v^\s+\%nopp.*' containedin=ALL
syntax match ecfError '\v^\%nopp\s*\S+.*' containedin=ALL

" An %end directive without a starting directive is invalid:
syntax match ecfError '\v^\%end.*'
" Space before an %end directive is invalid:
syntax match ecfError '\v^\s+\%end.*'  containedin=ALL
" Any non-space characters on the same line as an %end directive is
" invalid:
syntax match ecfError '\v^\%end\s*\S+.*' containedin=ALL

highlight link ecfError Error

" ----------------------------------------------------------------------
" Set the name of the current syntax to "ecflow", must be done last:
" ----------------------------------------------------------------------
let b:current_sytnax = "ecflow"
