// [START functions_timelapse_setup]
const exec = require('child_process').exec;
const fs = require('fs');
const path = require('path');
const storage = require('@google-cloud/storage')();
const avconv = require('avconv');
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
    
    checkImages(req.body);
    
    return createVideo(req.body.month, req.body.day);
    
  }).then((response) => {
    res.status(200).send('Success: ' + req.body.month + ' ' + req.body.day + ' - VideoID:' + res.json(response));
  }).catch((err) => {
    console.error(err);
    res.status(err.code || 500).send(err);
    return Promise.reject(err);
  });
};

function checkImages (body) {
// Make sure there are days defined in the request
  if(!body || body.day === undefined || body.month === undefined) {
    const error = new Error('Need to specify a date!');
	error.code = 400
	throw error;
  };
	  
  const storage = new Storage();
  const bucketName = 'timelapse-scratch/' + body.month + '/' + body.day;

// Get all the files in the bucket	  
  storage
	  .bucket(bucketName)
	  .getfiles()
	  .then(results => {
    const files = results[0];
    
// Put the list of files in the logs.
    console.log('Files:');
    files.forEach(file => {
      console.log(file.name);
    });
  }).catch(err => {
    const error = new Error('Could not access storage');
    error.code = 401
    console.error('ERROR:', err);
    throw error;
    
  });
	  
// If you couldn't find any files, throw an error. 
  if (files.length == 0) {
    const error = new Error('No files found in bucket: ' + bucketName + '!');
	error.code = 400
	throw error;
  }

};
             

function createVideo (month, day) {
  const tempImageDir = '/tmp/images';
  return new Promise((resolve, reject) => {
    var params = [
      '-f', 'image2',
      '-framerate', '25',
      '-i', tempImageDir,
      '-c:v', 'h264',
      '-crf', '1',
      '/tmp/' + day + '-animated.mkv'
    ];
    console.log(`AVconv parameters: $(params)`);
    var stream = avconv(params);
    stream.pipe(fs.createWriteStream('/tmp/' + day + '-animated.mkv'));
    stream.once('exit', function(exitCode, signal) {
      callback(exitCode, signal, output, err);
    });
  });
                          
}
