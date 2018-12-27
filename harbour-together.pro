# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-voyager

CONFIG += sailfishapp webkit

# Write version file
VERSION_H = \
"$${LITERAL_HASH}ifndef APP_VERSION" \
"$${LITERAL_HASH}   define APP_VERSION \"$$APP_VERSION\"" \
"$${LITERAL_HASH}endif"
write_file($$$$OUT_PWD/version.h, VERSION_H)

HEADERS += \
    src/settings.h

SOURCES += src/harbour-voyager.cpp \
    src/settings.cpp

DISTFILES += qml/*.qml \
    rpm/harbour-voyager.spec \
    rpm/harbour-voyager.yaml \
    rpm/harbour-voyager.changes \
    translations/*.ts \
    harbour-voyager.desktop \
    qml/python/*.py \
    qml/js/*.js \
    qml/fonts/*.ttf \
    qml/fonts/LICENSE.txt \
    LICENSE

SAILFISHAPP_ICONS = 86x86 108x108 128x128

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/harbour-voyager-de.ts
