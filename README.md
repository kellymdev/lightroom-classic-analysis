# Lightroom Classic Analysis

This app takes a Lightroom Classic database (Lightroom Catalog.lrcat) file, which is a SQLite database and allows you to view data based on camera, lens, year and genre of photography.


As it is built around an existing database which does not follow Rails conventions, the following points should be noted:

* Table names are inconsistently named, e.g. AgHarvestedExifCameraModel, Adobe_images

* Columns within tables are inconsistently named, e.g. cameraModelRef, id_global

* There is no id column, id_local is used instead

* Data is sometimes stored as a decimal when it should be an integer, e.g. dateMonth, dateYear


To set up the database:

* Create a copy of the Lightroom Catalog and put it into the db folder

* Rename the Lightroom database to development.sqlite3
