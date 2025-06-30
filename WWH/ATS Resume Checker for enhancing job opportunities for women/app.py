# # from dotenv import load_dotenv

# # load_dotenv()
# # import base64
# # import streamlit as st
# # import os
# # import io
# # from PIL import Image 
# # import pdf2image
# # import google.generativeai as genai

# # GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"

# # genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# # def get_gemini_response(input,pdf_cotent,prompt):
# #     model=genai.GenerativeModel('gemini-pro-vision')
# #     response=model.generate_content([input,pdf_content[0],prompt])
# #     return response.text

# # def input_pdf_setup(uploaded_file):
# #     if uploaded_file is not None:
# #         ## Convert the PDF to image
# #         images=pdf2image.convert_from_bytes(uploaded_file.read())

# #         first_page=images[0]

# #         # Convert to bytes
# #         img_byte_arr = io.BytesIO()
# #         first_page.save(img_byte_arr, format='JPEG')
# #         img_byte_arr = img_byte_arr.getvalue()

# #         pdf_parts = [
# #             {
# #                 "mime_type": "image/jpeg",
# #                 "data": base64.b64encode(img_byte_arr).decode()  # encode to base64
# #             }
# #         ]
# #         return pdf_parts
# #     else:
# #         raise FileNotFoundError("No file uploaded")

# # ## Streamlit App

# # st.set_page_config(page_title="ATS Resume EXpert")
# # st.header("ATS Tracking System")
# # input_text=st.text_area("Job Description: ",key="input")
# # uploaded_file=st.file_uploader("Upload your resume(PDF)...",type=["pdf"])


# # if uploaded_file is not None:
# #     st.write("PDF Uploaded Successfully")


# # submit1 = st.button("Tell Me About the Resume")

# # #submit2 = st.button("How Can I Improvise my Skills")

# # submit3 = st.button("Percentage match")

# # input_prompt1 = """
# #  You are an experienced Technical Human Resource Manager,your task is to review the provided resume against the job description. 
# #   Please share your professional evaluation on whether the candidate's profile aligns with the role. 
# #  Highlight the strengths and weaknesses of the applicant in relation to the specified job requirements.
# # """

# # input_prompt3 = """
# # You are an skilled ATS (Applicant Tracking System) scanner with a deep understanding of data science and ATS functionality, 
# # your task is to evaluate the resume against the provided job description. give me the percentage of match if the resume matches
# # the job description. First the output should come as percentage and then keywords missing and last final thoughts.
# # """

# # if submit1:
# #     if uploaded_file is not None:
# #         pdf_content=input_pdf_setup(uploaded_file)
# #         response=get_gemini_response(input_prompt1,pdf_content,input_text)
# #         st.subheader("The Repsonse is")
# #         st.write(response)
# #     else:
# #         st.write("Please uplaod the resume")

# # elif submit3:
# #     if uploaded_file is not None:
# #         pdf_content=input_pdf_setup(uploaded_file)
# #         response=get_gemini_response(input_prompt3,pdf_content,input_text)
# #         st.subheader("The Repsonse is")
# #         st.write(response)
# #     else:
# #         st.write("Please uplaod the resume")

# import streamlit as st
# import google.generativeai as genai
# import os
# import PyPDF2 as pdf
# from dotenv import load_dotenv
# import json

# GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"
# load_dotenv() ## load all our environment variables

# genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# # Gemini Pro Response
# def get_gemini_repsonse(input):
#     # Assigning the Model
#     model=genai.GenerativeModel('gemini-pro')
#     response=model.generate_content(input)
#     return response.text

# # Extract and concatenate text from all pages of the given PDF file
# def input_pdf_text(uploaded_file):
#     reader=pdf.PdfReader(uploaded_file)
#     text=""
#     # Iterate through all the pages
#     for page in range(len(reader.pages)):
#         page=reader.pages[page]
#         # Extracting the text
#         text+=str(page.extract_text())
#     return text

# #Prompt Template --> The Better the prompt better is the result
# input_prompt="""
# Hey Act Like a skilled or very experienced ATS(Application Tracking System) with a deep understanding of the tech field, software engineering, data science, data analysis and big data engineering. Your task is to evaluate the resume based on the given job description.
# You must consider the job market is very competitive and you should provide the best assistance for improving the resumes. Assign the percentage Matching based on the Job description and the missing keywords with high accuracy.  
# resume:{text}
# description:{jd}

# I want the response in one single string having the structure
# {{"JD Match":"%","MissingKeywords:[]","Profile Summary":""}}
# """

# ## Creating the Streamlit App
# st.title("Smart ATS")
# st.text("Improve Your Resume ATS")
# jd=st.text_area("Paste the Job Description")
# uploaded_file=st.file_uploader("Upload Your Resume",type="pdf",help="Please uplaod the pdf")

# submit = st.button("Submit")

# if submit:
#     if uploaded_file is not None:
#         text=input_pdf_text(uploaded_file)
#         response=get_gemini_repsonse(input_prompt)
#         st.subheader(response)

import streamlit as st
import google.generativeai as genai
import os
import PyPDF2 as pdf
from dotenv import load_dotenv
import json

# Load environment variables (if you have a .env file with your API key)
load_dotenv() 
GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"

# It's best practice to get the API key from environment variables
# For deployment, always use environment variables for security
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY") 

# If you are hardcoding it for testing, ensure it's correct and remove os.getenv() for this line:
# GOOGLE_API_KEY = "YOUR_ACTUAL_API_KEY_HERE" # Replace with your actual API key

if not GOOGLE_API_KEY:
    st.error("Google API Key not found. Please set it as an environment variable (e.g., in a .env file) or hardcode it in the script for testing purposes.")
    st.stop() # Stop the app if the API key is not found

genai.configure(api_key=GOOGLE_API_KEY)

# Gemini Model Configuration
# You can try 'gemini-pro', 'gemini-1.0-pro', 'gemini-1.5-flash', 'gemini-1.5-pro'
# It's crucial to use a model that supports 'generateContent' and is available in your region.
# To check available models, run the `list_available_models.py` script provided below.
GEMINI_MODEL_NAME = 'gemini-1.5-flash' # Changed model name here

# Gemini Pro Response
def get_gemini_repsonse(input_prompt_text):
    try:
        model = genai.GenerativeModel(GEMINI_MODEL_NAME)
        response = model.generate_content(input_prompt_text)
        return response.text
    except Exception as e:
        st.error(f"Error getting response from Gemini model '{GEMINI_MODEL_NAME}': {e}")
        st.info("This might be due to an incorrect API key, regional model unavailability, or unsupported method.")
        st.info("Please verify your API key and check the available models for your region using the `genai.list_models()` method (see comments in the code or the separate script).")
        return None

# Extract and concatenate text from all pages of the given PDF file
def input_pdf_text(uploaded_file):
    reader = pdf.PdfReader(uploaded_file)
    text = ""
    # Iterate through all the pages
    for page in range(len(reader.pages)):
        page = reader.pages[page]
        # Extracting the text
        text += str(page.extract_text())
    return text

# Prompt Template --> The Better the prompt better is the result
input_prompt = """
Hey Act Like a skilled or very experienced ATS(Application Tracking System) with a deep understanding of the tech field, software engineering, data science, data analysis and big data engineering. Your task is to evaluate the resume based on the given job description.
You must consider the job market is very competitive and you should provide the best assistance for improving the resumes. Assign the percentage Matching based on the Job description and the missing keywords with high accuracy.  
resume:{text}
description:{jd}

I want the response in one single string having the structure
{{"JD Match":"%","MissingKeywords:[]","Profile Summary":""}}
"""

## Creating the Streamlit App
st.title("Smart ATS")
st.text("Improve Your Resume ATS")
jd = st.text_area("Paste the Job Description")
uploaded_file = st.file_uploader("Upload Your Resume", type="pdf", help="Please upload the pdf")

submit = st.button("Submit")

if submit:
    if uploaded_file is not None and jd: # Ensure both file and JD are provided
        text = input_pdf_text(uploaded_file)
        
        # Format the input_prompt with the extracted text and job description
        formatted_input_prompt = input_prompt.format(text=text, jd=jd)
        
        response = get_gemini_repsonse(formatted_input_prompt)
        
        if response:
            try:
                # Assuming the response is a JSON string, parse and display it nicely
                response_dict = json.loads(response)
                st.subheader("ATS Evaluation Results:")
                st.write(f"**JD Match:** {response_dict.get('JD Match', 'N/A')}")
                st.write(f"**Missing Keywords:** {', '.join(response_dict.get('MissingKeywords', []))}")
                st.write(f"**Profile Summary:** {response_dict.get('Profile Summary', 'N/A')}")
            except json.JSONDecodeError:
                st.subheader("Raw AI Response (could not parse as JSON):")
                st.write(response)
                st.warning("The AI response was not in the expected JSON format. Please check the prompt or try again.")
            except Exception as e:
                st.error(f"An unexpected error occurred while processing the AI response: {e}")
        else:
            st.warning("Could not get a response from the AI model. Please check the error messages above.")
    elif not uploaded_file:
        st.warning("Please upload your resume PDF to proceed.")
    elif not jd:
        st.warning("Please paste the Job Description to proceed.")