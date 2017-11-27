// [START functions_timelapse_setup]
// const exec = require('child_process').exec;
// const fs = require('fs');
// const path = require('path');
// const util = require('util');
const Storage = require('@google-cloud/storage');
// const ffmpegPath = require('@ffmpeg-installer/ffmpeg').path;
const ffmpeg = require('fluent-ffmpeg');
// [END functions_timelapse_setup]

/**
 * Makes a video of the images in the cloud bucket timelapse-scratch
 *
 * @param {Object} req Cloud Function request object.
 * @param {Object} req.body The request payload.
 * @param {String} req.body.month The month of the video.
 * @param {String} req.body.day The day of the video.
 * @param {Object} res Cloud Function response object.
 */

exports.makeVideo = function makeVideo(req, res) {
    return Promise.resolve()
        .then(() => {
            if (req.method !== 'POST') {
                const error = new Error('Only POST requests are accepted');
                error.code = 405;
                throw error;
            }

            // START MAIN LOGIC
            return checkAndGetImages(req.body);
            // createVideo(req.body.month, req.body.day, "/tmp/images");
        }).then(function(response) {
            res.status(200);
            res.send('Success: ' + req.body.month + ' ' + req.body.day +
                     ' - VideoID:' + response);
        }).catch(function(err) {
            console.error(err);
            res.status(err.code || 500).send(err);
            return Promise.reject(err);
        });
};

/**
 * Looks for images in a GCS bucket and copies them locally.
 *
 * @param {object} body The request payload
 * @return {Promise} Number of files copied locally
 */
function checkAndGetImages(body) {
    return new Promise((resolve, reject) => {
        // Make sure there are days defined in the request
        if (!body || body.day === undefined || body.month === undefined) {
            const error = new Error('Need to specify a date!');
            error.code = 400;
            throw error;
        }

        const bucketName = 'timelapse-scratch';
        const tempImageDir = '/tmp/images';
        console.log('Bucket Name: ' + bucketName);

        // Make the tempDirectory
        try {
            //  fs.mkdirSync(tempImageDir);
        } catch (err) {
            console.log('Couldn\'t create temp image directory '+tempImageDir+
'!');
            if (err.code !== 'EEXIST') throw err;
        }

        const storage = new Storage();
        console.log(storage.bucket(bucketName));
        let numFiles = 0;

        // Get all the files in the bucket
        storage
            .bucket(bucketName)
            .getFilesStream()
            .on('data', function(file) {
            // console.log("Downloading " + file.name + " to " + tempImageDir);
                numFiles++;
                /*
                file.download({
                    destination: '/tmp/images/'+file.name,
                }, function(err) {}
                );
		*/
            })
            .on('error', console.error)
            .on('end', function() {
                resolve(numFiles);
                createVideo(body.month, body.day, tempImageDir);
            });
    });
}

/**
  * Creates a video using ffmpeg.
  *
  * @param {String} month The month of the video to make
  * @param {String} day The day of the video to make
  * @param {String} imageDir The GCS directory where the static images live
  *
  */
function createVideo(month, day, imageDir) {
    const inputImages = imageDir + '/*.jpg';
    console.log('Input images are here: '+inputImages);
    ffmpeg()
        .addInput(inputImages)
        .inputOption([
            // '-f', 'image2',
            '-pattern_type', 'glob',
            '-framerate', '25',
            // '-s', '1280x720',
            // '-pix_fmt', 'yuv420p',
            // '-c:v', 'h264'
        ])
        .on('start', function(commandLine) {
            console.log('Ffmpeg started with command: ' + commandLine);
        })
        .on('progress', function(progress) {
            console.log('Processing: ' + progress.percent + '% done');
        })
        .on('error', function(err, stdout, stderr) {
            console.log('Cannot process video: ' + err.message);
        })
        .on('end', function(stdout, stderr) {
            console.log('Render Succeded!');
        })
        .save('/tmp/'+day+'-animated.mkv');
}
