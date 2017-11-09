// [START functions_timelapse_setup]
const exec = require('child_process').exec;
const fs = require('fs');
const path = require('path');
const storage = require('@google-cloud/storage')();
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
    
    createVideo(
    return
    
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
    console.error('ERROR:', err);
  });
	  
// If you couldn't find any files, throw an error. 
  if (files.length == 0) {
    const error = new Error('No files found in bucket: ' + bucketName + '!');
	error.code = 400
	throw error;
  }

// Now, Make the video.
	  
};
             

    
    
                            
                          
    
}
  
/**
 * Copyright 2017, Google, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';



// [START functions_makevideo]
// Stiches uploaded images together into a video
exports.makeGIF = (event) => {
  const object = event.data;

  // Exit if this is a deletion or a deploy event.
  if (object.resourceState === 'not_exists') {
    console.log('This is a deletion event.');
    return;
  } else if (!object.name) {
    console.log('This is a deploy event.');
    return;
  } else if (object.

  const file = storage.bucket(object.bucket).file(object.name);

  console.log(`Analyzing ${file.name}.`);

  return vision.detectSafeSearch(file)
    .catch((err) => {
      console.error(`Failed to analyze ${file.name}.`, err);
      return Promise.reject(err);
    })
    .then(([safeSearch]) => {
      if (safeSearch.adult || safeSearch.violence) {
        console.log(`The image ${file.name} has been detected as inappropriate.`);
        return blurImage(file, safeSearch);
      } else {
        console.log(`The image ${file.name} has been detected as OK.`);
      }
    });
};
// [END functions_makevideo]
// [END functions_imagemagick_analyze]

// [START functions_imagemagick_blur]
// [START functioins_upload_to_youtube]
// Uploads the video we just made to YouTube
function upload (file) {
  const tempLocalFilename = `/tmp/${path.parse(file.name).base}`;

  // Download file from bucket.
  return file.download({ destination: tempLocalFilename })
    .catch((err) => {
      console.error('Failed to download file.', err);
      return Promise.reject(err);
    })
    .then(() => {
      console.log(`Image ${file.name} has been downloaded to ${tempLocalFilename}.`);

      // Blur the image using ImageMagick.
      return new Promise((resolve, reject) => {
        exec(`convert ${tempLocalFilename} -channel RGBA -blur 0x24 ${tempLocalFilename}`, { stdio: 'ignore' }, (err, stdout) => {
          if (err) {
            console.error('Failed to blur image.', err);
            reject(err);
          } else {
            resolve(stdout);
          }
        });
      });
    })
    .then(() => {
      console.log(`Image ${file.name} has been blurred.`);

      // Upload the Blurred image back into the bucket.
      return file.bucket.upload(tempLocalFilename, { destination: file.name })
        .catch((err) => {
          console.error('Failed to upload blurred image.', err);
          return Promise.reject(err);
        });
    })
    .then(() => {
      console.log(`Blurred image has been uploaded to ${file.name}.`);

      // Delete the temporary file.
      return new Promise((resolve, reject) => {
        fs.unlink(tempLocalFilename, (err) => {
          if (err) {
            reject(err);
          } else {
            resolve();
          }
        });
      });
    });
}
// [END functions_imagemagick_blur]
