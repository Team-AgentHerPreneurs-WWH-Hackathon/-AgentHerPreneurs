#setting up the environment
#pip install youtube_transcript_api

from youtube_transcript_api import YouTubeTranscriptApi
# srt = YouTubeTranscriptApi.get_transcript('9bZkp7q19f0', languages=['en'])
srt = YouTubeTranscriptApi.get_transcript('Ok7Q2LGvQPI')
print(srt)