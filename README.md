# populate
A hacky script to quickly populate a directory with standard ruby files using 
ultra simple syntax.

Call from the command line like this:
```populate LIB Model View Controller SPEC VIEWS index about help .erb```

The idea is to quickly populate a folder with standard files in a single command. 
When finished, this should:
* create the necessary folder structure
* automatically generate spec files if it detects ```lib``` and ```spec``` folders
* name files in each folder with the extension given, or ```.rb``` by default
* add class definition boilerplate to files named in lower_snake or UpperCamel case
* be quick, simple, fuss-free and reliable

Not currently working, but we'll get there
