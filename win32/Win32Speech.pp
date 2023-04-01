unit Win32Speech;

{$mode delphi}

interface

  function GetVoices(Criteria: WideString = ''): WideString;
  procedure Speak(Value: WideString; VoiceIndex: Integer = -1);

implementation

  uses
    ActiveX, ComObj;

  var

    Initialized: Boolean = false;
    SpVoice: Variant;

  const

    SVSFlagsAsync = 1;

  procedure Initialize;
  begin
    if not Initialized then begin
      CoInitializeEx(Nil, 0);
      SpVoice := CreateOleObject('SAPI.SpVoice');
    end;
  end;

  procedure Speak(Value: WideString; VoiceIndex: Integer = -1);
  var
    CW: Word;
    Voice: Variant;
  begin
    Initialize;
    CW := Get8087CW;
    try
      Set8087CW(CW or $4);
      if VoiceIndex <> -1 then begin
        Voice := SpVoice.GetVoices.Item(VoiceIndex);
        SpVoice.Voice := IDispatch(Voice);
      end;
      SpVoice.Speak(Value, SVSFlagsAsync);
    finally
      Set8087CW(CW);
    end;
  end;

  function GetVoices(Criteria: WideString = ''): WideString;
  var
    Voices: Variant;
    Voice: Variant;
    I: Integer;
  begin
    Result := '';

    Initialize;
    Voices := SpVoice.GetVoices(Criteria);
    for I := 0 to Voices.Count - 1 do begin

      if Result <> '' then begin
        Result := Result + '|';
      end;

      Voice := Voices.Item(I);
      Result := Result + Voice.GetDescription;
    end;
  end;

  procedure Finalize;
  begin
    if Initialized then begin
      CoUninitialize;
    end;
  end;

end.
