// [START functions_timelapse_setup]
const exec = require('child_process').exec;
const fs = require('fs');
const path = require('path');
const util = require('util');
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
    //return createVideo(req.body.month, req.body.day);

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
  var numFiles = 0;

// Get all the files in the bucket	  
  storage
	.bucket(bucketName)
	.getFilesStream()
	.on('data', function(file) {
		console.log("Downloading " + file.name + " to " + tempImageDir);
		file.download({
			// TODO: Fix this business
			destination: '/tmp/images/'+util.format("%d.JPG",numFiles)
			}, function(err) {});
		numFiles++;
	})
	.on('error', console.error)
	.on('end', function(){
		for ( var i; i < numFiles; i++) {
			
		} 
		//createVideo(body.month, body.day, tempImageDir + "/%04d.JPG");
	});
// createVideo(body.month, body.day, tempImageDir + "/%04d.JPG");
};

function createVideo (month, day, ImageDir) {
  return new Promise((resolve, reject) => {
    var params = [
      '-f', 'image2',
      '-framerate', '25',
      '-i', ImageDir,
      '-c:v', 'h264',
      '-crf', '1',
      '-y', '/tmp/' + day + '-animated.mkv'
    ];
    var stream = avconv(params);
    console.log('AVconv parameters: ' + params);
    // Output filename should be something like '/tmp/15-animated.mkv'
    const outputFile = '/tmp/' + day + '-animated.mkv';
    console.log("Writing to " + outputFile); 
    stream.pipe(fs.createWriteStream(outputFile))
    .on('error', function(data) {
      console.error(data);
      console.error(params);
      const error = new Error('AVconv had an issue: ' + data);
      error.code = 501;
      throw error;
    })
    .on('message', function(data) {
      console.log(data);
    })  
    .on('progress', function(progress) {
      console.log(progress);
    })
    .once('exit', function(exitCode, signal) {
      console.log(exitCode, signal);
    });
  });
                          
};
