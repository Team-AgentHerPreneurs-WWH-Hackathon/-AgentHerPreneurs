# import pysrt
# from translate import Translator

# def translate_text(text, to_lang, from_lang):
#     """
#     Translates a given text from one language to another using the 'translate' library.
#     Includes basic error handling for translation failures.
#     """
#     try:
#         translator = Translator(to_lang=to_lang, from_lang=from_lang)
#         translated_text = translator.translate(text)
#         return translated_text
#     except Exception as e:
#         # If translation fails, print an error and return the original text
#         # This prevents the script from crashing and allows partial translation
#         print(f"Error translating text: '{text}' - {e}")
#         return text


# # Open the subtitle file.
# # It's good practice to specify the encoding, especially for files that might contain
# # special characters or when expecting a specific format like UTF-8.
# # If 'face.txt' is not in UTF-8, you might need to change 'encoding' here.
# try:
#     subs = pysrt.open('face.srt', encoding='utf-8')
# except FileNotFoundError:
#     print("Error: 'face.srt' not found. Please ensure the subtitle file is in the same directory.")
#     exit()
# except Exception as e:
#     print(f"Error opening 'face.srt': {e}")
#     exit()

# # Iterate through each subtitle and translate its text
# for sub in subs:
#     sub.text = translate_text(sub.text, to_lang='hi', from_lang='en')


# # Save the translated subtitles to a new file.
# # Again, specify encoding to ensure proper saving of Hindi characters.
# try:
#     subs.save('translatedfile.srt', encoding='utf-8')
#     print("Translation complete! Translated subtitles saved to 'translatedfile.srt'")
# except Exception as e:
#     print(f"Error saving 'translatedfile.srt': {e}")

import pysrt
from translate import Translator

def translate_text(text, to_lang, from_lang):
    """
    Translates a given text from one language to another using the 'translate' library.
    Includes basic error handling for translation failures.
    """
    try:
        translator = Translator(to_lang=to_lang, from_lang=from_lang)
        translated_text = translator.translate(text)
        return translated_text
    except Exception as e:
        # If translation fails, print an error and return the original text
        # This prevents the script from crashing and allows partial translation
        print(f"Error translating text: '{text}' - {e}")
        return text


# Open the subtitle file.
# It's good practice to specify the encoding, especially for files that might contain
# special characters or when expecting a specific format like UTF-8.
# If 'face.srt' is not in UTF-8, you might need to change 'encoding' here.
try:
    subs = pysrt.open('face.srt', encoding='utf-8')
except FileNotFoundError:
    print("Error: 'face.srt' not found. Please ensure the subtitle file is in the same directory.")
    exit()
except Exception as e:
    print(f"Error opening 'face.srt': {e}")
    exit()

# Iterate through each subtitle and translate its text
for sub in subs:
    sub.text = translate_text(sub.text, to_lang='hi', from_lang='en')


# Save the translated subtitles to a new file.
# Again, specify encoding to ensure proper saving of Hindi characters.
try:
    subs.save('translatedfile.srt', encoding='utf-8') # Changed output to .srt as well
    print("Translation complete! Translated subtitles saved to 'translatedfile.srt'")
except Exception as e:
    print(f"Error saving 'translatedfile.srt': {e}")