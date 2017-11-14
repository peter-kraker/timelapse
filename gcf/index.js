// [START functions_timelapse_setup]
const exec = require('child_process').exec;
const fs = require('fs');
const path = require('path');
const Storage = require('@google-cloud/storage');
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
    
    checkAndGetImages(req.body);
    return createVideo(req.body.month, req.body.day);

  }).then((response) => {
    res.status(200).send('Success: ' + req.body.month + ' ' + req.body.day + ' - VideoID:' + res.json(response));
  }).catch((err) => {
    console.error(err);
    res.status(err.code || 500).send(err);
    return Promise.reject(err);
  });
};

function checkAndGetImages (body) {
// Make sure there are days defined in the request
  if(!body || body.day === undefined || body.month === undefined) {
    const error = new Error('Need to specify a date!');
	error.code = 400;
	throw error;
  };
	  
  const bucketName = 'timelapse-scratch';
  const prefix = body.month + '/' + body.day + '/';
  const delimiter = '/';
  const tempImageDir = '/tmp/images';
  console.log("Bucket Name: " + bucketName);
  console.log("Folder name: " + prefix);

  const options = {
    prefix: prefix,
  } 
  
  if (delimiter) {
    options.delimiter = delimiter;
  }

  // Make the tempDirectory
  try {
  fs.mkdirSync(tempImageDir);
} catch(err) {
  if (err.code !== 'EEXIST') throw err
}

  const storage = new Storage();

  console.log(storage.bucket(bucketName));

// Get all the files in the bucket	  
  storage
	.bucket(bucketName)
	.getFiles(options)
	.then(results => {
		const files = results[0];
		const numberOfFiles = files.length;
		console.log('Number of Files: ' + numberOfFiles);
		if (files.length == 0) {
			const error = new Error('No files found in bucket: ' + bucketName + '!');
			error.code = 400;
			throw error;
    		};
		for ( var i = 0; i < numberOfFiles; i++ ){
			destFilename = tempImageDir + '/' + i
			files[i].download(destFilename).then(() => {
				console.log(`gs://${bucketName}/files[${i}] downloaded to ${destFilename}.`);
			});
		}
  	}).catch(err => {
    		console.error('ERROR:', err);
  	});
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
      '-y', '/tmp/' + day + '-animated.mkv'
    ];
    console.log('AVconv parameters: ' + params);
    var stream = avconv(params);
    stream.on('error', function(data) {
      console.error(data);
      console.error(params);
      const error = new Error('AVconv had an issue: ' + data);
      error.code = 501;
      throw error;
    });
    // Output filename should be something like '/tmp/15-animated.mkv'
    const outputFile = '/tmp/' + day + '-animated.mkv';
    console.log("Writing to " + outputFile); 
    stream.on('message', function(data) {
      console.log(data);
    });  
    stream.pipe(fs.createWriteStream(outputFile));
    stream.on('progress', function(progress) {
      console.log(progress);
    });
    stream.once('exit', function(exitCode, signal) {
      console.log(exitCode, signal);
    });
  });
                          
};
