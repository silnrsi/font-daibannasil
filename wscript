#!/usr/bin/python3
# this is a smith configuration file

# set the default output folders
DOCDIR="doc"
TESTDIR='test-suite'
TESTRESULTSDIR = 'test-results'

# set the font name, version, licensing and description
APPNAME="DaiBannaSIL"
VERSION="3.000"
TTF_VERSION="3.000"
COPYRIGHT="Copyright (c) 2008-2021, SIL International (http://www.sil.org)"
LICENSE='OFL.txt'

DESC_SHORT = "Unicode font for New Tai Lue"
DESC_LONG = """
Dai Banna SIL is a Unicode font package for the New Tai Lue script used by the Xishuangbanna Dai people.  It includes two font families which differ only in weight.  It has complete coverage of the Unicode 8.0 New Tai Lue block and smart code in Graphite.
"""
DESC_NAME = "DaiBannaSIL"

# Set up the FTML tests
ftmlTest('tools/ftml-smith.xsl')

# font source directory
fontsrcdir = "font-source/"

# base name of font file
fontbasename = "DBSIL"

# os/2 bits for the font, needed 'cos FL5.0.4 doesn't list NTL bit
os2bits = "800000100001200080000003"

# face and style names for the unique id
facenames = {
    'B' : 'Book',
    'L' : 'Light',
}

stylenames = {
    'B' : 'Bold',
    'C' : 'Bold Italic',
    'O' : 'Italic',
    'R' : '',
}

for fontface in ('B','L') :
    for fontstyle in ('B','C','O','R') :
        face_style = f'{facenames[fontface]} {stylenames[fontstyle]}'.strip()
        unique_id = f'SILInternational: Dai Banna SIL {face_style}: 2021'
        font(target = process(fontbasename + fontface + fontstyle + '.ttf',
            cmd('hackos2 -q -u ' + os2bits + ' ${DEP} ${TGT}'),
            cmd('ttfname -t 3 -n "' + unique_id + '" ${DEP} ${TGT}')
            ),
            source = fontsrcdir + fontbasename + fontface + fontstyle + '_src.ttf',
            graphite = gdl(fontsrcdir + 'tlue.gdl', no_make=1),
            version = VERSION,
            license = ofl('SIL'),
            pdf = fret(params = '-r'),
            woff = woff()
        )
