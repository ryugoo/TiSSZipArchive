(function () {
    'use strict';
    var win = Ti.UI.iOS.createNavigationWindow({
        window: Ti.UI.createWindow({
            backgroundColor: '#FFFFFF',
            title: 'TiSSZipArchive'
        })
    });
    win.window.add(Ti.UI.createLabel({
        text: 'Module test application'
    }));

    win.addEventListener('open', function () {
        var zip = require('net.imthinker.ti.ssziparchive'),
            res = Ti.Filesystem.resourcesDirectory,
            temp = Ti.Filesystem.tempDirectory,
            data = Ti.Filesystem.applicationDataDirectory,
            target = temp + (Date.now()) + '.zip';


        /* ZIP archive test
        ---------------------------------------------------------------------- */
        // "archive" event handler
        zip.addEventListener('archive', function (e) {
            if (e.success) {
                console.log('ZIP archive is success');
                console.log(e);
            } else {
                console.error('ZIP archive is failure');
                console.error(e);
            }
        });

        // Processing
        zip.archive({ // New
            target: target,
            files: [
                res + 'a.png',
                res + 'b.png',
                res + 'c.png'
            ],
            overwrite: false
        }); // => success

        zip.archive({ // New
            target: temp + 'test.zip',
            files: [
                res + 'a.png',
                res + 'b.png',
                res + 'c.png'
            ],
            overwrite: true
        }); // => success

        zip.archive({ // Overwrite
            target: temp + 'test.zip',
            files: [
                res + 'a.png',
                res + 'b.png',
                res + 'c.png'
            ],
            overwrite: true
        }); // => success

        zip.archive({ // Overwrite
            target: temp + 'test.zip',
            files: [
                res + 'a.png',
                res + 'b.png',
                res + 'c.png'
            ],
            overwrite: false
        }); // => failure (ZIP file is already exist)


        /* ZIP extract test
        ---------------------------------------------------------------------- */
        // "extract" event listener
        zip.addEventListener('extract', function (e) {
            if (e.success) {
                console.log('ZIP extract is success');
                console.log(e);
            } else {
                console.error('ZIP extract is failure');
                console.error(e);
            }
        });

        // Processing
        zip.extract({
            target: temp + 'temp.zip',
            destination: data,
            password: '',
            overwrite: false
        }); // => failure (ZIP file is not exist)

        zip.extract({
            target: temp + 'test.zip',
            destination: data,
            password: '',
            overwrite: false
        }); // => success

        zip.extract({
            target: temp + 'test.zip',
            destination: data + 'NOT_EXIST_DIR',
            password: '',
            overwrite: false
        }); // => success
    });

    win.open();
}());
