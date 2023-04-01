unit ChakraSpeech;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetJsValue: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, Win32Speech;

  function ChakraGetVoices(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    aCriteria: WideString;
  begin
    CheckParams('getVoices', Args, ArgCount, [jsString], 1);
    aCriteria := JsStringAsString(Args^);

    Result := StringAsJsString(GetVoices(aCriteria));
  end;

  function ChakraSpeak(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    aMessage: WideString;
    aVoiceIndex: Integer;
  begin
    Result := Undefined;

    CheckParams('speak', Args, ArgCount, [jsString, jsNumber], 2);
    aMessage := JsStringAsString(Args^); Inc(Args);
    aVoiceIndex := JsNumberAsInt(Args^);

    Speak(aMessage, aVoiceIndex);
  end;

  function GetJsValue;
  begin

    Result := CreateObject;

    SetFunction(Result, 'getVoices', ChakraGetVoices);
    SetFunction(Result, 'speak', ChakraSpeak);

  end;

end.
