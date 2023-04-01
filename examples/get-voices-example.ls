
  { get-voices } = winjs.load-library 'WinjsSpeech.dll'

  for voice in get-voices '' .split '|' 
    process.io.stdout "\n#voice"
