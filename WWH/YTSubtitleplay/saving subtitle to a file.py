from youtube_transcript_api import YouTubeTranscriptApi

srt = YouTubeTranscriptApi.get_transcript('ntCNcAT1zxk')

# with open("face.txt",'w') as f:
#     for line in srt:
#         f.write(f"{line}\n")
#         f.write(f"{line['start']} --> {line['start'] + line['duration']}\n")
#         f.write(f"{line['text']}\n\n")

with open("face.srt",'w') as f:
    for line in srt:
        f.write(f"{line}\n")
        f.write(f"{line['start']} --> {line['start'] + line['duration']}\n")
        f.write(f"{line['text']}\n\n")