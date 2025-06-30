import pysrt
from translate import Translator

def translate_text(text, to_lang, from_lang):

    translate= Translator(to_lang=to_lang, from_lang=from_lang)
    text = translate.translate(text)
    return text


subs = pysrt.open('face.srt')

for sub in subs:
    sub.text = translate_text(sub.text, to_lang='hi', from_lang='en')


#we'll save the translated subtitles to a new file
subs.save('translatedfile.srt')