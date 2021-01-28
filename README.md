# populate
A hacky script to quickly populate a directory with standard ruby files using 
ultra simple syntax. 

Call from the command line like this:
```populate LIB Model View Controller other_class SPEC VIEWS index about help .erb```

The idea is to quickly populate a folder with standard files in a single command. 
When finished, this should:
* create the necessary folder structure
* automatically generate spec files if it detects ```lib``` and ```spec``` folders
* name files in each folder with the extension given, or ```.rb``` by default
* add class definition boilerplate to files named in lower_snake or UpperCamel case
* be quick, simple, fuss-free and reliable

Not currently working quite right, but we'll get there!
The example above should generate the following structure:
```
📦./
 ┣ 📂lib
 ┃ ┣ 📜controller.rb
 ┃ ┣ 📜model.rb
 ┃ ┣ 📜other_class.rb
 ┃ ┗ 📜view.rb
 ┣ 📂spec
 ┃ ┣ 📜controller_spec.rb
 ┃ ┣ 📜model_spec.rb
 ┃ ┣ 📜other_class_spec.rb
 ┃ ┗ 📜view_spec.rb
 ┗ 📂views
 ┃ ┣ 📜about.erb
 ┃ ┣ 📜help.erb
 ┃ ┗ 📜index.erb
```
