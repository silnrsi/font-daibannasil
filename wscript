#!/usr/bin/python3
# this is a smith configuration file

# set the default output folders
DOCDIR="doc"

# set the font name, version, licensing and description
APPNAME="DaiBannaSIL"
getufoinfo('source/masters/' + APPNAME + 'Master-Regular' + '.ufo')

DESC_LONG = """
Dai Banna SIL is a Unicode font package for the New Tai Lue script used by the Xishuangbanna Dai people.  It includes two font families which differ only in weight.  It has complete coverage of the Unicode 8.0 New Tai Lue block and smart code in Graphite.
"""
DESC_NAME = "DaiBannaSIL"

# Set up the FTML tests
ftmlTest('tools/ftml-smith.xsl')

generated = 'generated/'

for dspace in ('Upright', 'Italic'):
    designspace('source/' + APPNAME + dspace + '.designspace',
        target = process('${DS:FILENAME_BASE}.ttf',
            cmd('psfchangettfglyphnames ${SRC} ${DEP} ${TGT}', ['source/instances/${DS:FILENAME_BASE}.ufo'])
        ),
        instanceparams = '-W',
        graphite = gdl('source/main.gdl',
            no_make = 1,
            params = '-e gdlerr-${DS:FILENAME_BASE}.txt',
            ),
        version = VERSION,
        woff = woff('woff/${DS:FILENAME_BASE}',
            metadata = '../source/${DS:FAMILYNAME_NOSPC}-WOFF-metadata.xml'),
        pdf = fret(params='-oi')
    )
