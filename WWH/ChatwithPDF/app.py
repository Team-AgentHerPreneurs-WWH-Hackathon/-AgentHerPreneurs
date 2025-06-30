# # import streamlit as st
# # from PyPDF2 import PdfReader
# # from langchain.text_splitter import RecursiveCharacterTextSplitter
# # import os
# # from langchain_google_genai import GoogleGenerativeAIEmbeddings
# # import google.generativeai as genai
# # from langchain.vectorstores import FAISS
# # from langchain_google_genai import ChatGoogleGenerativeAI
# # from langchain.chains.question_answering import load_qa_chain
# # from langchain.prompts import PromptTemplate
# # from dotenv import load_dotenv

# # GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"

# # load_dotenv()
# # os.getenv("GOOGLE_API_KEY")
# # genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))






# # def get_pdf_text(pdf_docs):
# #     text=""
# #     for pdf in pdf_docs:
# #         pdf_reader= PdfReader(pdf)
# #         for page in pdf_reader.pages:
# #             text+= page.extract_text()
# #     return  text



# # def get_text_chunks(text):
# #     text_splitter = RecursiveCharacterTextSplitter(chunk_size=10000, chunk_overlap=1000)
# #     chunks = text_splitter.split_text(text)
# #     return chunks


# # def get_vector_store(text_chunks):
# #     embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")
# #     vector_store = FAISS.from_texts(text_chunks, embedding=embeddings)
# #     vector_store.save_local("faiss_index")


# # def get_conversational_chain():

# #     prompt_template = """
# #     Answer the question as detailed as possible from the provided context, make sure to provide all the details, if the answer is not in
# #     provided context just say, "answer is not available in the context", don't provide the wrong answer\n\n
# #     Context:\n {context}?\n
# #     Question: \n{question}\n

# #     Answer:
# #     """

# #     model = ChatGoogleGenerativeAI(model="gemini-pro",
# #                              temperature=0.3)

# #     prompt = PromptTemplate(template = prompt_template, input_variables = ["context", "question"])
# #     chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)

# #     return chain



# # def user_input(user_question):
# #     embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")
    
# #     new_db = FAISS.load_local("faiss_index", embeddings)
# #     docs = new_db.similarity_search(user_question)

# #     chain = get_conversational_chain()

    
# #     response = chain(
# #         {"input_documents":docs, "question": user_question}
# #         , return_only_outputs=True)

# #     print(response)
# #     st.write("Reply: ", response["output_text"])




# # def main():
# #     st.set_page_config("Chat PDF")
# #     st.header("Chat with PDF using Gemini💁")

# #     user_question = st.text_input("Ask a Question from the PDF Files")

# #     if user_question:
# #         user_input(user_question)

# #     with st.sidebar:
# #         st.title("Menu:")
# #         pdf_docs = st.file_uploader("Upload your PDF Files and Click on the Submit & Process Button", accept_multiple_files=True)
# #         if st.button("Submit & Process"):
# #             with st.spinner("Processing..."):
# #                 raw_text = get_pdf_text(pdf_docs)
# #                 text_chunks = get_text_chunks(raw_text)
# #                 get_vector_store(text_chunks)
# #                 st.success("Done")



# # if __name__ == "__main__":
# #     main()

# import streamlit as st
# from PyPDF2 import PdfReader
# from langchain.text_splitter import RecursiveCharacterTextSplitter
# import os
# from langchain_google_genai import GoogleGenerativeAIEmbeddings
# import google.generativeai as genai
# from langchain.vectorstores import FAISS
# from langchain_google_genai import ChatGoogleGenerativeAI
# from langchain.chains.Youtubeing import load_qa_chain
# from langchain.prompts import PromptTemplate
# from dotenv import load_dotenv

# # Your Google API Key should ideally be loaded from an environment variable for security
# GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8" # It's better to keep this out of direct code

# load_dotenv()
# # Ensure your .env file has GOOGLE_API_KEY="YOUR_API_KEY"
# genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))


# def get_pdf_text(pdf_docs):
#     text = ""
#     for pdf in pdf_docs:
#         pdf_reader = PdfReader(pdf)
#         for page in pdf_reader.pages:
#             text += page.extract_text()
#     return text


# def get_text_chunks(text):
#     text_splitter = RecursiveCharacterTextSplitter(chunk_size=10000, chunk_overlap=1000)
#     chunks = text_splitter.split_text(text)
#     return chunks


# def get_vector_store(text_chunks):
#     embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
#     vector_store = FAISS.from_texts(text_chunks, embedding=embeddings)
#     vector_store.save_local("faiss_index")


# def get_conversational_chain():
#     prompt_template = """
#     Answer the question as detailed as possible from the provided context, make sure to provide all the details, if the answer is not in
#     provided context just say, "answer is not available in the context", don't provide the wrong answer\n\n
#     Context:\n {context}?\n
#     Question: \n{question}\n

#     Answer:
#     """

#     model = ChatGoogleGenerativeAI(model="gemini-pro", temperature=0.3)

#     prompt = PromptTemplate(template=prompt_template, input_variables=["context", "question"])
#     chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)

#     return chain


# def user_input(user_question):
#     embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")

#     # Corrected line to allow dangerous deserialization as discussed
#     new_db = FAISS.load_local("faiss_index", embeddings, allow_dangerous_deserialization=True)
#     docs = new_db.similarity_search(user_question)

#     chain = get_conversational_chain()

#     response = chain(
#         {"input_documents": docs, "question": user_question}, return_only_outputs=True
#     )

#     print(response)
#     st.write("Reply: ", response["output_text"])


# def main():
#     st.set_page_config("Chat PDF")
#     st.header("Chat with PDF using Gemini💁")

#     user_question = st.text_input("Ask a Question from the PDF Files")

#     if user_question:
#         user_input(user_question)

#     with st.sidebar:
#         st.title("Menu:")
#         pdf_docs = st.file_uploader("Upload your PDF Files and Click on the Submit & Process Button", accept_multiple_files=True)
#         if st.button("Submit & Process"):
#             with st.spinner("Processing..."):
#                 raw_text = get_pdf_text(pdf_docs)
#                 text_chunks = get_text_chunks(raw_text)
#                 get_vector_store(text_chunks)
#                 st.success("Done")


# if __name__ == "__main__":
#     main()

# import streamlit as st
# from PyPDF2 import PdfReader
# from langchain.text_splitter import RecursiveCharacterTextSplitter
# import os
# from langchain_google_genai import GoogleGenerativeAIEmbeddings
# import google.generativeai as genai
# from langchain.vectorstores import FAISS
# from langchain_google_genai import ChatGoogleGenerativeAI
# from langchain.chains.question_answering import load_qa_chain
# from langchain.prompts import PromptTemplate
# from dotenv import load_dotenv

# GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"
# # Load environment variables (e.g., GOOGLE_API_KEY)
# load_dotenv()

# # Configure Google Generative AI with the API key from environment variables
# # It's crucial to load this from an environment variable for security
# # Make sure your .env file in the same directory contains:
# # GOOGLE_API_KEY="YOUR_ACTUAL_GOOGLE_API_KEY_HERE"
# genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# # Function to extract text from a list of PDF documents
# def get_pdf_text(pdf_docs):
#     text = ""
#     for pdf in pdf_docs:
#         pdf_reader = PdfReader(pdf)
#         for page in pdf_reader.pages:
#             text += page.extract_text()
#     return text

# # Function to split the text into smaller chunks
# def get_text_chunks(text):
#     text_splitter = RecursiveCharacterTextSplitter(chunk_size=10000, chunk_overlap=1000)
#     chunks = text_splitter.split_text(text)
#     return chunks

# # Function to create and save a FAISS vector store from text chunks
# def get_vector_store(text_chunks):
#     embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
#     vector_store = FAISS.from_texts(text_chunks, embedding=embeddings)
#     vector_store.save_local("faiss_index") # Saves the vector store locally

# # Function to set up the conversational chain using Gemini Pro
# def get_conversational_chain():
#     prompt_template = """
#     Answer the question as detailed as possible from the provided context, make sure to provide all the details, if the answer is not in
#     provided context just say, "answer is not available in the context", don't provide the wrong answer\n\n
#     Context:\n {context}?\n
#     Question: \n{question}\n

#     Answer:
#     """
#     # Initialize the Generative AI model
#     model = ChatGoogleGenerativeAI(model="gemini-pro", temperature=0.3)

#     # Create a prompt template
#     prompt = PromptTemplate(template=prompt_template, input_variables=["context", "question"])
    
#     # Load the question-answering chain
#     chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)
#     return chain

# # Function to handle user input (question) and generate a response
# # def user_input(user_question):
# #     # Initialize embeddings model
# #     embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
    
# #     # Load the locally saved FAISS vector store
# #     # 'allow_dangerous_deserialization=True' is added here to permit loading of pickle files.
# #     # This is safe to do if you trust the source of the 'faiss_index' file (i.e., your own application).
# #     new_db = FAISS.load_local("faiss_index", embeddings, allow_dangerous_deserialization=True)
    
# #     # Perform similarity search to find relevant documents in the vector store
# #     docs = new_db.similarity_search(user_question)

# #     # Get the conversational chain
# #     chain = get_conversational_chain()

# #     # Get the response from the chain
# #     response = chain(
# #         {"input_documents": docs, "question": user_question},
# #         return_only_outputs=True
# #     )

# #     print(response)
# #     st.write("Reply: ", response["output_text"])

# # Function to handle user input (question) and generate a response
# def user_input(user_question):
#     # Initialize embeddings model
#     embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")

#     # Define the path to the faiss index directory
#     faiss_index_path = "faiss_index"

#     # Check if the faiss index directory exists
#     if not os.path.exists(faiss_index_path) or not os.path.exists(os.path.join(faiss_index_path, "index.faiss")):
#         st.warning("FAISS index not found. Please upload PDF files and click 'Submit & Process' first.")
#         return # Stop execution if the index isn't available

#     # Load the locally saved FAISS vector store
#     try:
#         new_db = FAISS.load_local(faiss_index_path, embeddings, allow_dangerous_deserialization=True)
#     except Exception as e:
#         st.error(f"Error loading FAISS index: {e}. Please try re-processing your PDFs.")
#         return

#     # Perform similarity search to find relevant documents in the vector store
#     docs = new_db.similarity_search(user_question)

#     # Get the conversational chain
#     chain = get_conversational_chain()

#     # Get the response from the chain
#     response = chain(
#         {"input_documents": docs, "question": user_question},
#         return_only_outputs=True
#     )

#     print(response)
#     st.write("Reply: ", response["output_text"])

# # Main function to run the Streamlit application
# def main():
#     st.set_page_config("Chat PDF")
#     st.header("Chat with PDF using Gemini💁")

#     user_question = st.text_input("Ask a Question from the PDF Files")

#     if user_question:
#         user_input(user_question)

#     with st.sidebar:
#         st.title("Menu:")
#         pdf_docs = st.file_uploader(
#             "Upload your PDF Files and Click on the Submit & Process Button",
#             accept_multiple_files=True
#         )
#         if st.button("Submit & Process"):
#             if pdf_docs:
#                 with st.spinner("Processing..."):
#                     raw_text = get_pdf_text(pdf_docs)
#                     text_chunks = get_text_chunks(raw_text)
#                     get_vector_store(text_chunks)
#                     st.success("Done")
#             else:
#                 st.warning("Please upload PDF files first!")


# if __name__ == "__main__":
#     main()

import streamlit as st
from PyPDF2 import PdfReader
from langchain.text_splitter import RecursiveCharacterTextSplitter
import os
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import google.generativeai as genai
from langchain.vectorstores import FAISS
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.chains.question_answering import load_qa_chain # This is the correct import
from langchain.prompts import PromptTemplate
from dotenv import load_dotenv


GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"
# Load environment variables (e.g., GOOGLE_API_KEY)
load_dotenv()

# Configure Google Generative AI with the API key from environment variables
# It's crucial to load this from an environment variable for security
# Make sure your .env file in the same directory contains:
# GOOGLE_API_KEY="YOUR_ACTUAL_GOOGLE_API_KEY_HERE"
# For demonstration, I'm using the hardcoded key you provided,
# but it's HIGHLY recommended to use os.getenv("GOOGLE_API_KEY") in production.
# Replace with your actual key or ensure it's in your .env file.
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY") 
if GOOGLE_API_KEY:
    genai.configure(api_key=GOOGLE_API_KEY)
else:
    st.error("Google API Key not found. Please set the GOOGLE_API_KEY environment variable.")
    st.stop() # Stop the app if API key is missing


# Function to extract text from a list of PDF documents
def get_pdf_text(pdf_docs):
    text = ""
    for pdf in pdf_docs:
        pdf_reader = PdfReader(pdf)
        for page in pdf_reader.pages:
            text += page.extract_text()
    return text

# Function to split the text into smaller chunks
def get_text_chunks(text):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=10000, chunk_overlap=1000)
    chunks = text_splitter.split_text(text)
    return chunks

# Function to create and save a FAISS vector store from text chunks
def get_vector_store(text_chunks):
    embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
    vector_store = FAISS.from_texts(text_chunks, embedding=embeddings)
    vector_store.save_local("faiss_index") # Saves the vector store locally

# Function to set up the conversational chain using a suitable Gemini model
def get_conversational_chain():
    prompt_template = """
    Answer the question as detailed as possible from the provided context, make sure to provide all the details, if the answer is not in
    provided context just say, "answer is not available in the context", don't provide the wrong answer\n\n
    Context:\n {context}?\n
    Question: \n{question}\n

    Answer:
    """
    # Initialize the Generative AI model.
    # Using 'gemini-1.5-flash' as it's a good balance of speed and capability,
    # and widely supported for 'generateContent'.
    # You can experiment with 'gemini-1.5-pro' for more complex reasoning
    # if you have access and higher token limits.
    model = ChatGoogleGenerativeAI(model="gemini-1.5-flash", temperature=0.3) 

    # Create a prompt template
    prompt = PromptTemplate(template=prompt_template, input_variables=["context", "question"])
    
    # Load the question-answering chain
    chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)
    return chain

# Function to handle user input (question) and generate a response
def user_input(user_question):
    # Initialize embeddings model
    embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")

    # Define the path to the faiss index directory
    faiss_index_path = "faiss_index"

    # Check if the faiss index directory exists
    if not os.path.exists(faiss_index_path) or not os.path.exists(os.path.join(faiss_index_path, "index.faiss")):
        st.warning("FAISS index not found. Please upload PDF files and click 'Submit & Process' first.")
        return # Stop execution if the index isn't available

    # Load the locally saved FAISS vector store
    try:
        new_db = FAISS.load_local(faiss_index_path, embeddings, allow_dangerous_deserialization=True)
    except Exception as e:
        st.error(f"Error loading FAISS index: {e}. Please try re-processing your PDFs.")
        return

    # Perform similarity search to find relevant documents in the vector store
    docs = new_db.similarity_search(user_question)

    # Get the conversational chain
    chain = get_conversational_chain()

    # Get the response from the chain
    response = chain(
        {"input_documents": docs, "question": user_question},
        return_only_outputs=True
    )

    print(response)
    st.write("Reply: ", response["output_text"])

# Main function to run the Streamlit application
def main():
    st.set_page_config("Chat PDF")
    st.header("Chat with PDF using Gemini💁")

    user_question = st.text_input("Ask a Question from the PDF Files")

    if user_question:
        user_input(user_question)

    with st.sidebar:
        st.title("Menu:")
        pdf_docs = st.file_uploader(
            "Upload your PDF Files and Click on the Submit & Process Button",
            accept_multiple_files=True
        )
        if st.button("Submit & Process"):
            if pdf_docs:
                with st.spinner("Processing..."):
                    raw_text = get_pdf_text(pdf_docs)
                    text_chunks = get_text_chunks(raw_text)
                    get_vector_store(text_chunks)
                    st.success("Done")
            else:
                st.warning("Please upload PDF files first!")


if __name__ == "__main__":
    main()