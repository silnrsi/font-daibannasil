#!/usr/bin/python3
# this is a smith configuration file

# set the default output folders
DOCDIR = ['documentation', 'web']

# set the font name, version, licensing and description
APPNAME="DaiBannaSIL"
getufoinfo('source/masters/' + APPNAME + '-Light' + '.ufo')

# Set up the FTML tests
ftmlTest('tools/ftml-smith.xsl')

generated = 'generated/'

for dspace in ('Upright', 'Italic'):
    designspace('source/' + APPNAME + dspace + '.designspace',
        target = process('${DS:FILENAME_BASE}.ttf',
            cmd('psfchangettfglyphnames ${SRC} ${DEP} ${TGT}', ['${source}'])
        ),
        # graphite = gdl('source/main.gdl',
        #     no_make = 1,
        #     params = '-e gdlerr-${DS:FILENAME_BASE}.txt',
        #     ),
        version = VERSION,
        woff = woff('web/${DS:FILENAME_BASE}',
            metadata = '../source/${DS:FAMILYNAME_NOSPC}-WOFF-metadata.xml'),
        shortcircuit = False,
        pdf = fret(params='-oi')
    )

variable = package(
    appname = APPNAME + '-variable',
    version = VERSION,
    docdir = {'documentation': 'documentation', 'variable/web': 'web'}
)

for face in ('', '-Italic'):
    stem = f'{APPNAME}{face}'
    font(target = process(f'variable/{stem}.ttf',
        cmd('gftools fix-font --include-source-fixes -o ${TGT} ${DEP}'),
        cmd('../tools/genstat.sh ../source/stat.yaml ${DEP} ${TGT}')
        ),
        source = f'source/{stem}-VF.designspace',
        params = '--feature-writer None --filter DecomposeTransformedComponentsFilter',
        version = VERSION,
        woff = woff(f'variable/web/{stem}.woff2', type='woff2',
            metadata = f'../source/{APPNAME}-WOFF-metadata.xml',
            dontship = True),
        package = variable,
        no_test = True
    )
