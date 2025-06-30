import streamlit as st
from dotenv import load_dotenv
import re # Import the regular expression module

load_dotenv() ##load all the environment variables
import os
import google.generativeai as genai

from youtube_transcript_api import YouTubeTranscriptApi

GOOGLE_API_KEY="AIzaSyA7fQKCBtHPQUHGX1nZXDOWiJMlO31-uk8"

# Ensure your GOOGLE_API_KEY is set as an environment variable.
# For example, in your .env file: GOOGLE_API_KEY="YOUR_ACTUAL_API_KEY"
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

prompt="""You are Youtube video summarizer. You will be taking the transcript text
and summarizing the entire video and providing the important summary in points
within 250 words. Please provide the summary of the text given here:  """

## getting the transcript data from yt videos
def extract_transcript_details(youtube_video_url):
    try:
        # Robust video ID extraction using regex for various YouTube URL formats
        video_id_match = re.search(r'(?:v=|youtu\.be\/|embed\/|watch\?v=|\/v\/|\/e\/|http(?:s)?:\/\/(?:www\.)?youtube\.com\/user\/[^\/]+\/|http(?:s)?:\/\/(?:www\.)?youtube\.com\/|http(?:s)?:\/\/(?:www\.)?youtube\.com\/playlist\?list=|http(?:s)?:\/\/(?:www\.)?youtube\.com\/c\/[^\/]+\/videos\?|http(?:s)?:\/\/(?:www\.)?youtube\.com\/channel\/[^\/]+\/videos\?)([a-zA-Z0-9_-]{11})', youtube_video_url)
        
        if video_id_match:
            video_id = video_id_match.group(1)
        else:
            raise ValueError("Could not extract a valid YouTube video ID from the provided URL.")

        transcript_text = YouTubeTranscriptApi.get_transcript(video_id)

        transcript = ""
        for i in transcript_text:
            transcript += " " + i["text"]

        return transcript

    except Exception as e:
        st.error(f"Error extracting transcript: {e}")
        st.error("Please ensure:")
        st.error("- The YouTube video link is correct and the video is publicly available.")
        st.error("- The video has captions/transcripts available (either auto-generated or uploaded).")
        st.error("- You are not trying to access a private or region-restricted video.")
        return None
    
## getting the summary based on Prompt from Google Gemini Pro
def generate_gemini_content(transcript_text, prompt):
    try:
        # You can change "gemini-pro" to other models like "gemini-1.5-flash" or "gemini-1.5-pro"
        # based on availability and your needs.
        model = genai.GenerativeModel("gemini-1.5-flash") 
        response = model.generate_content(prompt + transcript_text)
        return response.text
    except Exception as e:
        st.error(f"Error generating content with Gemini Pro: {e}")
        st.error("Common causes for '404 models/gemini-pro is not found' or other API errors:")
        st.error("1. **Invalid or Expired API Key:** Double-check your GOOGLE_API_KEY.")
        st.error("2. **Incorrect Project Setup:** Ensure your API key is associated with a project where the Generative Language API is enabled.")
        st.error("3. **Region Restrictions:** The Gemini Pro model might not be available in all regions yet. Check the official documentation for availability.")
        st.error("4. **Quota Limits:** Although less likely for a 404, ensure you haven't exceeded any free tier or paid quota limits.")
        st.error("5. **Model Name:** Ensure the model name ('gemini-pro' or 'gemini-1.5-flash', etc.) is correct and supported for your API key and region.")
        return None

st.title("YouTube Transcript to Detailed Notes Converter")
youtube_link = st.text_input("Enter YouTube Video Link:")

if youtube_link:
    # Attempt to display thumbnail if link is valid
    try:
        # Use the same robust regex for thumbnail extraction
        video_id_match = re.search(r'(?:v=|youtu\.be\/|embed\/|watch\?v=|\/v\/|\/e\/|http(?:s)?:\/\/(?:www\.)?youtube\.com\/user\/[^\/]+\/|http(?:s)?:\/\/(?:www\.)?youtube\.com\/|http(?:s)?:\/\/(?:www\.)?youtube\.com\/playlist\?list=|http(?:s)?:\/\/(?:www\.)?youtube\.com\/c\/[^\/]+\/videos\?|http(?:s)?:\/\/(?:www\.)?youtube\.com\/channel\/[^\/]+\/videos\?)([a-zA-Z0-9_-]{11})', youtube_link)
        
        if video_id_match:
            video_id = video_id_match.group(1)
            st.image(f"http://img.youtube.com/vi/{video_id}/0.jpg", use_column_width=True)
        else:
            st.warning("Please enter a valid YouTube video URL to display the thumbnail.")
    except Exception as e:
        st.warning(f"Could not display video thumbnail. Error: {e}")


if st.button("Get Detailed Notes"):
    if youtube_link:
        transcript_text = extract_transcript_details(youtube_link)

        if transcript_text:
            summary = generate_gemini_content(transcript_text, prompt)
            if summary:
                st.markdown("## Detailed Notes:")
                st.write(summary)
    else:
        st.warning("Please enter a YouTube video link to get detailed notes.")