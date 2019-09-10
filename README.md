# YouTube Filter

### Download and Categorize Subtitles

The primary purpose of this app is to download Youtube subtitles and categorize
each individual word into word classifications. 


### Youtube-dl

To download the subtitles youtube-dl is needed, to install it right away for 
all UNIX users (Linux, OS X, etc.), type:

`sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl`

`sudo chmod a+rx /usr/local/bin/youtube-dl`

If you do not have curl, you can alternatively use a recent wget:

`sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl`

`sudo chmod a+rx /usr/local/bin/youtube-dl`

It is best to have a template for youtube-dl so the downloads are formated
correctly the youtube-filter expects a named Dir based on the title. 

`~/.config/youtube-dl/config`

Create a config file if you have not already got one and add these lines, this 
is to format the playlist, the single video download has a default already set 
which is fine for this purpose.


    # Format
    -f mp4

    # Save all videos under Movies directory in your home directory
    -o ~/Downloads/Youtube/%(uploader)s/%(title)s/%(title)s.%(ext)s



### Youtube Filter
![front end](https://github.com/shadow-chasing/filter/blob/master/scripts/screen-shots/Screenshot%202019-09-10%20at%2016.19.55.png)

### Subtitles

Subtitle category is the whole collection of subtitle words. The subtitle word is processed and give a: 

1. count (how many occurrences per video)
2. syllable count (per word)
3. length of word
4. frequency (how often the word is used over the course of the video)
5. and a word rank (a score based on length, syllable length and count.)


The primary groups are:

1. modality
2. predicate group
3. word group
4. filter

![theme](https://github.com/shadow-chasing/filter/blob/master/scripts/screen-shots/Screenshot%202019-09-10%20at%2016.38.39.png)

###  Themes 

Themes are easly created and added, filter on movies, songs anything you want. They come initialy with political, profanity, religion and spirituality. 
