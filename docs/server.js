var express = require('express')
var app = express();
var bodyParser = require('body-parser');
var engines = require('consolidate');
var hummus = require('hummus');
var path = require('path')

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(__dirname));
app.engine('html', engines.mustache);
app.set('view engine', 'html');

app.get('/', function (req, res) {
	res.render('index.html');
});

app.get('/professor', function(req,res){
  res.render('professors.html');
})

app.get('/student', function(req,res){
  res.render('students.html');
})

app.get('/page/:textbook/:page', function(req, res) {
	const sourcePDF = path.join(__dirname, '/../textbooks/' + req.params.textbook + '.pdf');
	const pdfWriter = hummus.createWriter(new hummus.PDFStreamForResponse(res));
	const page = parseInt(req.params.page)
    pdfWriter.appendPDFPagesFromPDF(sourcePDF, {type:hummus.eRangeTypeSpecific,specificRanges: [ [ page, page ] ]});
    pdfWriter.end();
})

app.post('/profile', function(req,res){
  console.log(req.body)
  res.render("profile.html", { name: req.body.name, school:req.body.school });
});

app.listen(8000)
console.log('8000');
