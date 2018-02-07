# textbook-comparison

iOS application that compares text between two versions of textbooks to show what differences exist between each. Professors can buy the newest version of the book and "sell" the different pages between versions so that both the publisher and the professor both gain money, while the student is able to learn off a cheaper, older textbook version and simply buy pages that they lack.

### Table of Contents
- [Installation](#Installation)
- [Requirements](#Requirements)
- [Usage](#Usage)

### Installation
    git clone https://github.com/emily-yu/textbook-comparison.git
    cd textbook-comparison
    pip install -r requirements.txt
    
### Requirements
- PyPDF2
- textract
- nltk.tokenize
- sklearn.feature_extraction.text
- bottle
    
### Usage

Running iOS application: 

    ./ngrok http 5000
    python server.py
    cd textbook-app
    cd textbook-app
    
In `ViewController.swift`, replace variable `ngrok` with new ngrok URL. Open `textbook-app.xcworkspace` and hit run button to destination device.

To run `docs` web application, `node server.js`, then open `localhost: 8000`.