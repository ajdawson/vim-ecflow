# Synatx highlighting for ecFlow scripts

ecFlow scripts are just regular shell scripts with additional pre-processing
directives available. This syntax highlighting package extends the built-in
shell script syntax to include these post-processing directives.

The ecFlow syntax is automatically selected for scripts with file extension
.ecf. It is also activated for scripts with file extension .sms, which share
pre-processing directives with ecFlow (but this syntax definiton does not
highlight CDP scripts within .sms files).

# Install

I highly recommend using pathogen to install:

    cd ~/.vim/bundle
    git clone ssh://git@software.ecmwf.int:7999/~diad/vim-ecflow.git    

You will need to run the ``./build_syntax`` script before the package can be
used:

    cd vim-ecflow
    ./build_syntax
