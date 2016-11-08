
source common.sh

echo ""
echo "***** Rebuilding ted2 *****"
echo ""

$mx2cc makeapp -apptype=gui -clean -build -config=release -target=desktop ../src/ted2go/ted2.monkey2

$mx2cc makeapp -apptype=gui -clean -build -config=release -target=desktop ../src/launcher/launcher.monkey2

if [ "$OSTYPE" = "linux-gnu" ]
then

	rm -r -f "$ted2"
	mkdir "$ted2"
	cp -R "$ted2go_new/assets" "$ted2/assets"
	cp "$ted2go_new/ted2" "$ted2/ted2"
	rm -r -f "$launcher"
	cp "$launcher_new" "$launcher"

elif [ "$OSTYPE" = "linux-gnueabihf" ]
then

	rm -r -f "$ted2"
	mkdir "$ted2"
	cp -R "$ted2go_new/assets" "$ted2/assets"
	cp "$ted2go_new/ted2" "$ted2/ted2"
	rm -r -f "$launcher"
	cp "$launcher_new" "$launcher"

else

	rm -r -f "$ted2"
	cp -R "$ted2go_new" "$ted2"
	rm -r -f "$launcher"
	cp -R "$launcher_new" "$launcher"
	
	cp ../src/launcher/info.plist "$launcher/Contents"
	cp ../src/launcher/Monkey2logo.icns "$launcher/Contents/Resources"
	
fi
