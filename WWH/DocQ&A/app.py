# from flask import Flask, request, jsonify, render_template_string
# from flask_cors import CORS
# from youtube_transcript_api import YouTubeTranscriptApi
# from youtube_transcript_api.formatters import TextFormatter
# import re
# import jwt
# import requests
# from urllib.parse import urlparse, parse_qs

# app = Flask(__name__)
# CORS(app)  # Enable CORS for all routes

# # Your proxy token
# PROXY_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6IjI0ZjEwMDIzMzNAZHMuc3R1ZHkuaWl0bS5hYy5pbiJ9.eawnQNAiOzfVMAqybYGuhmWKp4bY964C2N0mwWo6Lko"

# def extract_video_id(url):
#     """Extract video ID from various YouTube URL formats"""
#     patterns = [
#         r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/|youtube\.com\/v\/|m\.youtube\.com\/watch\?v=|youtube\.com\/shorts\/)([^#\&\?]*)',
#         r'youtube\.com\/.*[?&]v=([^&]+)',
#         r'youtu\.be\/([^?&]+)'
#     ]
    
#     for pattern in patterns:
#         match = re.search(pattern, url)
#         if match:
#             return match.group(1)
#     return None

# def validate_token(token):
#     """Validate the proxy token"""
#     try:
#         # Decode without verification for now (in production, you'd verify the signature)
#         decoded = jwt.decode(token, options={"verify_signature": False})
#         return True
#     except:
#         return False

# @app.route('/')
# def index():
#     """Serve the HTML interface"""
#     # Return a simple page that loads your HTML interface
#     return """
#     <!DOCTYPE html>
#     <html>
#     <head><title>YouTube Transcript API Backend</title></head>
#     <body>
#         <h1>YouTube Transcript API Backend is Running!</h1>
#         <p>This Flask backend is ready to serve transcript requests.</p>
#         <p>Make sure your HTML frontend is configured to connect to this backend.</p>
#         <p><strong>Available endpoints:</strong></p>
#         <ul>
#             <li>POST /api/transcript - Get video transcript</li>
#             <li>POST /api/video-info - Get video information</li>
#         </ul>
#     </body>
#     </html>
#     """

# @app.route('/api/transcript', methods=['POST'])
# def get_transcript():
#     """Get transcript for a YouTube video"""
#     try:
#         # Validate authorization
#         auth_header = request.headers.get('Authorization')
#         if not auth_header or not auth_header.startswith('Bearer '):
#             return jsonify({'error': 'Authorization header required'}), 401
        
#         token = auth_header.split(' ')[1]
#         if not validate_token(token):
#             return jsonify({'error': 'Invalid token'}), 401
        
#         # Get request data
#         data = request.get_json()
#         if not data:
#             return jsonify({'error': 'JSON data required'}), 400
        
#         video_url = data.get('video_url')
#         video_id = data.get('video_id')
        
#         if not video_id:
#             video_id = extract_video_id(video_url) if video_url else None
        
#         if not video_id:
#             return jsonify({'error': 'Valid YouTube video ID or URL required'}), 400
        
#         # Get language preference (default to English)
#         language = data.get('language', 'en')
        
#         # Fetch transcript
#         try:
#             # Try to get transcript in specified language first
#             transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
            
#             # Try to find the requested language or fall back to any available
#             try:
#                 transcript = transcript_list.find_transcript([language])
#             except:
#                 # If requested language not found, get the first available transcript
#                 transcript = transcript_list.find_generated_transcript(['en'])
            
#             # Get the actual transcript data
#             transcript_data = transcript.fetch()
            
#             # Format transcript with timestamps
#             formatted_transcript = []
#             for entry in transcript_data:
#                 formatted_transcript.append({
#                     'text': entry['text'],
#                     'start': entry['start'],
#                     'duration': entry['duration']
#                 })
            
#             # Also provide a simple text version
#             text_formatter = TextFormatter()
#             simple_text = text_formatter.format_transcript(transcript_data)
            
#             return jsonify({
#                 'success': True,
#                 'video_id': video_id,
#                 'language': transcript.language_code,
#                 'transcript': formatted_transcript,
#                 'simple_text': simple_text,
#                 'total_entries': len(formatted_transcript)
#             })
            
#         except Exception as e:
#             error_msg = str(e)
#             if 'TranscriptsDisabled' in error_msg:
#                 return jsonify({'error': 'Transcripts are disabled for this video'}), 400
#             elif 'NoTranscriptFound' in error_msg:
#                 return jsonify({'error': 'No transcript found for this video'}), 404
#             elif 'VideoUnavailable' in error_msg:
#                 return jsonify({'error': 'Video is unavailable or private'}), 404
#             else:
#                 return jsonify({'error': f'Failed to fetch transcript: {error_msg}'}), 500
                
#     except Exception as e:
#         return jsonify({'error': f'Server error: {str(e)}'}), 500

# @app.route('/api/video-info', methods=['POST'])
# def get_video_info():
#     """Get information about available transcripts for a video"""
#     try:
#         # Validate authorization
#         auth_header = request.headers.get('Authorization')
#         if not auth_header or not auth_header.startswith('Bearer '):
#             return jsonify({'error': 'Authorization header required'}), 401
        
#         token = auth_header.split(' ')[1]
#         if not validate_token(token):
#             return jsonify({'error': 'Invalid token'}), 401
        
#         # Get request data
#         data = request.get_json()
#         if not data:
#             return jsonify({'error': 'JSON data required'}), 400
        
#         video_url = data.get('video_url')
#         video_id = data.get('video_id')
        
#         if not video_id:
#             video_id = extract_video_id(video_url) if video_url else None
        
#         if not video_id:
#             return jsonify({'error': 'Valid YouTube video ID or URL required'}), 400
        
#         try:
#             # Get available transcripts
#             transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
            
#             available_languages = []
#             manually_created = []
#             auto_generated = []
            
#             for transcript in transcript_list:
#                 lang_info = {
#                     'language': transcript.language,
#                     'language_code': transcript.language_code
#                 }
#                 available_languages.append(transcript.language_code)
                
#                 if transcript.is_generated:
#                     auto_generated.append(lang_info)
#                 else:
#                     manually_created.append(lang_info)
            
#             return jsonify({
#                 'success': True,
#                 'video_id': video_id,
#                 'transcript_available': len(available_languages) > 0,
#                 'languages': available_languages,
#                 'manually_created': manually_created,
#                 'auto_generated': auto_generated,
#                 'title': f'Video {video_id}',  # You could fetch actual title using YouTube API
#                 'total_languages': len(available_languages)
#             })
            
#         except Exception as e:
#             error_msg = str(e)
#             if 'VideoUnavailable' in error_msg:
#                 return jsonify({
#                     'success': False,
#                     'video_id': video_id,
#                     'transcript_available': False,
#                     'error': 'Video is unavailable or private'
#                 }), 404
#             else:
#                 return jsonify({
#                     'success': False,
#                     'video_id': video_id,
#                     'transcript_available': False,
#                     'error': f'Failed to get video info: {error_msg}'
#                 }), 500
                
#     except Exception as e:
#         return jsonify({'error': f'Server error: {str(e)}'}), 500

# @app.route('/health', methods=['GET'])
# def health_check():
#     """Health check endpoint"""
#     return jsonify({
#         'status': 'healthy',
#         'service': 'YouTube Transcript API Backend',
#         'version': '1.0.0'
#     })

# if __name__ == '__main__':
#     print("Starting YouTube Transcript API Backend...")
#     print("Make sure you have installed the required packages:")
#     print("pip install flask flask-cors youtube-transcript-api PyJWT requests")
#     print("\nBackend will be available at: http://localhost:5000")
#     print("API endpoints:")
#     print("- POST /api/transcript")
#     print("- POST /api/video-info")
#     print("- GET /health")
    
#     app.run(debug=True, host='0.0.0.0', port=5000)


import streamlit as st
import os
from langchain_groq import ChatGroq
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import create_retrieval_chain
from langchain_community.vectorstores import FAISS
from langchain_community.document_loaders import PyPDFDirectoryLoader
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from dotenv import load_dotenv
import time

# Load environment variables from .env file
load_dotenv()

GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"
GROQ_API_KEY="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"

## Load the GROQ And Google API KEY from environment variables
groq_api_key = os.getenv('GROQ_API_KEY')
os.environ["GOOGLE_API_KEY"] = os.getenv("GOOGLE_API_KEY")

# Set up the Streamlit application title
st.title("Gemma Model Document Q&A")

# Initialize the ChatGroq model
llm = ChatGroq(groq_api_key=groq_api_key, model_name="Llama3-8b-8192")

# Define the chat prompt template for answering questions based on context
prompt = ChatPromptTemplate.from_template(
    """
Answer the questions based on the provided context only.
Please provide the most accurate response based on the question
<context>
{context}
</context>
Questions:{input}
"""
)

# Function to perform vector embedding of documents
def vector_embedding():
    # Only perform embedding if the vectors are not already in the session state
    if "vectors" not in st.session_state:
        st.session_state.embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
        st.session_state.loader = PyPDFDirectoryLoader("./us_census") # Initialize PDF loader for the specified directory

        try:
            st.session_state.docs = st.session_state.loader.load() # Load documents from the directory

            # Check if any documents were loaded
            if not st.session_state.docs:
                st.error("No documents found in the 'us_census' directory. Please ensure it exists and contains PDF files.")
                return # Exit the function if no documents are found

            # Initialize the text splitter for chunking documents
            st.session_state.text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)

            # Split the first 20 documents into smaller chunks
            # Adjust the slice if you want to process more or fewer documents
            st.session_state.final_documents = st.session_state.text_splitter.split_documents(st.session_state.docs[:20])

            # Check if document splitting resulted in any chunks
            if not st.session_state.final_documents:
                st.error("Document splitting resulted in no chunks. Please check the content of your PDFs or adjust chunking parameters.")
                return # Exit if no chunks are created

            # Create FAISS vector store from the document chunks and embeddings
            st.session_state.vectors = FAISS.from_documents(st.session_state.final_documents, st.session_state.embeddings)
            st.success("Vector Store DB Is Ready") # Indicate successful creation

        except Exception as e:
            # Catch any exceptions during document loading or embedding and display an error message
            st.error(f"An error occurred during document loading or embedding: {e}")
            st.info("Please ensure the 'us_census' directory exists and contains valid PDF files, and your GOOGLE_API_KEY is correct and has access to the embedding model.")

# Text input for the user's question
prompt1 = st.text_input("Enter Your Question From Documents")

# Button to trigger document embedding
if st.button("Documents Embedding"):
    vector_embedding()

# If a question is entered, proceed with retrieval and response generation
if prompt1:
    # Ensure the vector store has been initialized before attempting to use it
    if "vectors" in st.session_state and st.session_state.vectors is not None:
        # Create a document chain to combine documents with the LLM prompt
        document_chain = create_stuff_documents_chain(llm, prompt)
        # Create a retriever from the FAISS vector store
        retriever = st.session_state.vectors.as_retriever()
        # Create a retrieval chain combining the retriever and document chain
        retrieval_chain = create_retrieval_chain(retriever, document_chain)

        start = time.process_time() # Start timer for response time
        # Invoke the retrieval chain with the user's question
        response = retrieval_chain.invoke({'input': prompt1})
        print("Response time :", time.process_time()-start) # Print response time

        # Display the generated answer
        st.write(response['answer'])

        # Create an expander to show the source documents used for the answer
        with st.expander("Document Similarity Search"):
            # Iterate through the context documents and display their content
            for i, doc in enumerate(response["context"]):
                st.write(doc.page_content)
                st.write("--------------------------------")
    else:
        # Warn the user if the vector store is not yet initialized
        st.warning("Please click 'Documents Embedding' button first to initialize the vector store.")






