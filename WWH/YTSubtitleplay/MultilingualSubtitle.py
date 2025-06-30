# from youtube_transcript_api import YouTubeTranscriptApi
# srt = YouTubeTranscriptApi.get_transcript('Ok7Q2LGvQPI', languages=['ta'])
# print(srt)

## the above code will return error if a video id doesn't contain tamil subtitles
## so we need to handle the error
## hence we'll list down the possible transcript options

from youtube_transcript_api import YouTubeTranscriptApi
srt = YouTubeTranscriptApi.list_transcripts('ntCNcAT1zxk')

for transcript in srt:
    print(transcript.video_id) #prints the video id

    #to know if subtitle is manual or auto generated for the video, we use
    print(transcript.is_generated) #prints True if the subtitle is auto generated, else False

    #to know if subtitle is translatable 
    print(transcript.is_translatable) #prints True if the subtitle is translatable, else False


    #now let's see how to translate the subtitle to any other language
    #for this we use translate function

    print(transcript.translate('hi').fetch()) #translates the subtitle to tamil/hindi we put the lang code say hi for hindi






