# TiSSZipArchive

ZIP file manipulator for Titanium 3.2 (Using [SSZipArchive](https://github.com/soffes/ssziparchive/))

## Usage

See `example/app.js`

## Download the compiled release

* [iOS 1.0 (Compatible Titanium 3.2)](https://github.com/ryugoo/TiSSZipArchive/tree/master/dist)

## Feature

* Archive files
* Extract files

## Sample code

```
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
        zip.archive({
            target: target,
            files: [
                res + 'a.png',
                res + 'b.png',
                res + 'c.png'
            ],
            overwrite: false
        });


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
            target: target,
            destination: data,
            password: '',
            overwrite: false
        });
    });

    win.open();
}());
```

## License

```text
The MIT License (MIT)

Copyright (c) 2013 Ryutaro Miyashita

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

<hr>

### SSZipArchive

```text
Copyright (c) 2010-2012 Sam Soffes

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```