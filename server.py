import PyPDF2
import textract
from nltk.tokenize import word_tokenize
from sklearn.feature_extraction.text import TfidfVectorizer
from bottle import route, run, template, static_file, get, post, request, BaseRequest, Bottle, abort

def get_pdf_object(filename):
    pdfFileObj = open(filename,'rb')
    pdfReader = PyPDF2.PdfFileReader(pdfFileObj)
    num_pages = pdfReader.numPages
    return pdfReader, num_pages

def extract_sentences(reader, count):
    text = ""
    pageObj = reader.getPage(count)
    count +=1
    text += pageObj.extractText().replace('\n', '')
    # sentences = text.split('.')
    return text

def compare(reader, text, num_pages):
    vect = TfidfVectorizer(min_df=1)
    page_number = -1
    max_score = -1
    scores = []
    for x in range(0,num_pages):
        page_text = extract_sentences(reader, x)
        tfidf = vect.fit_transform([page_text,
                                    text])
        similarity_score = (tfidf * tfidf.T).A[0][1]
        scores.append(similarity_score)
        if(similarity_score > 0.6):
            page_number = x
            max_score = similarity_score
            break

    return page_number, max_score


# file_name = 'psych.pdf'

def everything(textbook, text):
    reader, num_pages = get_pdf_object(textbook)
    # remove this
    # text = extract_sentences(reader, 0)
    #
    select_num, score = compare(reader, text, 5)
    return select_num, score

@route('/')
def send_static2():
    return "hello"

@route('/compare', method='POST')
def do_uploadc():
    textbook = request.forms.get("textbook")
    text = request.forms.get("text")
    textbook = textbook + ".pdf"

    same, score = everything(textbook, text)
    print (same)
    print (score)
    return same, score

run(host="0.0.0.0", port=8000)
