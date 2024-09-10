//express server with image handling logic
const express = require('express');
const multer = require('multer');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 5000;

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/')
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({ storage: storage })

app.post('/segment', upload.single('image'), (req, res)=>{
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded'});
  }
  const imagePath = path.resolve(req.file.path);

  const pythonProcess = spawn('python', ['segment.py', imagePath]); 

  let stdoutData = '';
  let stderrData = '';

  pythonProcess.stdout.on('data', (data) => {
    stdoutData += data.toString();
  });

  pythonProcess.stderr.on('data', (data) => {
    stderrData += data.toString();
  })


  pythonProcess.on('close', (code) => {
    if (code !== 0) {
      console.log(`Python process exited with code ${code}`);
      console.log(stderrData);
      return res.status(500).json({ error: 'Failed to process the image'})
    }

    try {
      const results = JSON.parse(stdoutData);
      res.status(200).json({
        message: 'Segmentation successful',
        results
      });
    }catch (e) {
      console.error(`Failed to parse JSON: ${stdoutData}`);
      res.status(500).json({ error: 'Failed to process image'})
    }

    fs.unlinkSync(imagePath);//clean up uploaded file after processing
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
})