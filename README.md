# Syntax highlighting for ecFlow scripts in Vim

ecFlow scripts are just regular shell scripts with additional pre-processing
directives available. This syntax highlighting package extends the built-in
shell script syntax to include these post-processing directives.

The ecFlow syntax is automatically selected for scripts with file extension
.ecf. It is also activated for scripts with file extension .sms, which share
pre-processing directives with ecFlow.

# Install

You must run the ``./build_syntax`` script to generate the necessary files
for the package to work.

Probably the easiest way to install is to clone the project into the
`~/.vim/pack/bundle/start/` directory so it is loaded when Vim starts up
(assuming Vim version 8 or higher), then run the build script:

    mkdir -p ~/.vim/pack/bundle/start
    cd ~/.vim/pack/bundle/start
    git clone https://github.com/ajdawson/vim-ecflow.git
    cd vim-ecflow
    ./build_syntax

