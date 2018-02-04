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

def extract_sentences(reader, page):
    text = ""
    pageObj = reader.getPage(int(page))
    text += pageObj.extractText().replace('\n', '')

    return text

def compare(reader, text, pg_num):
    vect = TfidfVectorizer(min_df=1)
    # page_number = -1
    # max_score = -1
    # for x in range(0,num_pages):
    page_text = extract_sentences(reader, pg_num)
    tfidf = vect.fit_transform([page_text,
                                text])
    similarity_score = (tfidf * tfidf.T).A[0][1]
    # scores.append(similarity_score)
    # if(similarity_score > 0.6):
        # page_number = x
    max_score = similarity_score

    return page_text, max_score


def everything(textbook, text, pg):
    reader, num_pages = get_pdf_object(textbook)

    select_num, score = compare(reader, text, pg)
    return select_num, score

@route('/')
def send_static2():
    return "hello"

@route('/compare', method='POST')
def do_uploadc():
    textbook = request.forms.get("textbook")
    text = request.forms.get("text")
    version = request.forms.get("version")
    page_number = request.forms.get("pg")

    textbook = "textbooks/" + textbook + version + ".pdf"

    same, score = everything(textbook, text, page_number)
    print (same)
    print (score)
    return same

run(host="0.0.0.0", port=5000)
