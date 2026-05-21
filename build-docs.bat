:: Builds the documentation for Flixel3D.
:: The documentation will appear in the docs/pages folder once built.
:: You can then run your http server of choice in the docs/pages folder to view the docs.
:: e.g
:: cd docs/pages
:: python -m http.server

haxe dox.hxml
haxelib run dox -i docs -D source-path https://github.com/CodenameCrew/flixel3d/blob/main/src -o docs/pages --include "flixel3d" -o docs/pages