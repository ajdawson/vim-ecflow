# Syntax highlighting for ecFlow scripts

ecFlow scripts are just regular shell scripts with additional pre-processing
directives available. This syntax highlighting package extends the built-in
shell script syntax to include these post-processing directives.

The ecFlow syntax is automatically selected for scripts with file extension
.ecf. It is also activated for scripts with file extension .sms, which share
pre-processing directives with ecFlow.

# Install

You must run the ``./build_syntax`` script to generate the necessary files
for the package to work. When you do this depends on installation method.

If you use [Pathogen](https://github.com/tpope/vim-pathogen) (recommended)
do this:

    cd ~/.vim/bundle
    git clone ssh://git@software.ecmwf.int:7999/~diad/vim-ecflow.git    
    cd vim-ecflow
    ./build_syntax

If you are installing manually then do this:

    git clone ssh://git@software.ecmwf.int:7999/~diad/vim-ecflow.git
    cd vim-ecflow
    ./build_syntax
    rsync -a ftdetect syntax ~/.vim
