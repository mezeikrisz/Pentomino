unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids;

type
  TSquare = Array[1..5,1..5] of Char; //sorindex majd oszlopindex, teh�t ford�tva, mint pixelc�mz�sn�l

  TRectangle = Array[-4..11,-4..15] of Char; //sorindex majd oszlopindex

  TTileNames = (Empty, LetterI, LetterL, LetterV, LetterP, LetterX, LetterY, LetterN, LetterF, LetterT, LetterW, LetterU, LetterZ);

  TTile = class(TObject)
  public //private //hogy r�l�sson a test, egyel�re public minden
    fSquare: TSquare;
    fTileType: TTileNames;
    fVariantIndex: Shortint;
    fOffsetJ: Shortint;
    fIsOnPlayGround: Boolean;
    constructor Create(pTile: TTileNames);
    procedure Rotate;      //fNegyzetet megforgatja clockwise [3,3]-as k�z�pponttal
    procedure Flip;      //fNegyzetet t�kr�zi f�gg�leges tengelyre
    procedure Normalize;  //fNegyzet 1-eseit a balfels� sarokba tolja
    function Compare(pSquare: TSquare): Boolean;   //fNegyzetet m�sik TNegyzettel hasonl�t
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    function Vary: Boolean; //el��ll�tja a k�v v�ltozatot fNegyzet-be, ha lehet m�g
  end;

  TPlayGround = class(TObject)
  public //private //hogy r�l�sson a test, egyel�re public minden
    fRectangle: TRectangle;
    fNumberOfTilesOnPlayGround: Shortint;
    fFirstEmptyI, fFirstEmptyJ: Shortint;
    constructor Create;
    function IsPuttableHere(pTile: TTile; pI, pJ: Shortint): Boolean;
    procedure Put(pTile: TTile; pI, pJ: Shortint);
    function IsThereSingleHole: Boolean;
    function IsThereDoubleHole: Boolean;
    function IsThereTripleHole: Boolean;
    function IsThereQuadrupleHole: Boolean;
    procedure FindFirstEmpty;
    function Compare(pRectangle: TRectangle): Boolean;
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    procedure TakeOff(pTile: TTile; pI, pJ: Shortint);
    function IsReady: Boolean;
    procedure Stop;
  end;

  TfrmMain = class(TForm)
    btnKeres: TButton;
    dwgdLenyeg: TDrawGrid;
    rgrpTempo: TRadioGroup;
    lblTalalatokSzama: TLabel;
    edtTalalatokSzama: TEdit;
    lblSebesseg: TLabel;
    edtSebesseg: TEdit;
    lblElkeszult: TLabel;
    edtElkeszult: TEdit;
    tmrTimer: TTimer;
    procedure btnKeresClick(Sender: TObject);
    procedure dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure tmrTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fTiles: Array[LetterI..LetterZ] of TTile;
    fPlayGround: TPlayGround;
    fResults: TextFile;
    fSolutionIndex: Integer;
    fNumberOfPuts: Integer;
  public
    procedure Recursive;
    procedure SetTempo;
    procedure Save;
    procedure Load;
  end;

var
  frmMain: TfrmMain;

  oMozaikValtozatok: Array[Empty..LetterZ] of String =
  (
  'S',          //�res n�gyzetet nincs �rtelme forgatni/t�kr�zni
  'SF',         //a Hosszut egyszer lehet Forgatni, t�bb v�ltozat nincs..
  'SFFFTFFF',   //az Elbetut k�rbe lehet Forgatni, akkor T�kr�zni, majd megint Forgatni..
  'SFFF',       //stb
  'SFFFTFFF',
  'S',
  'SFFFTFFF',
  'SFFFTFFF',
  'SFFFTFFF',
  'SFFF',
  'SFFF',
  'SFFF',
  'SFTF'
  );

  oMozaikKarakterek: Array[Empty..LetterZ] of Char =
  (
  '.',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L'
  );

  oMozaikSzinek: Array[1..12] of TColor =    //ez most nem enummal c�mezve, mert a sz�ls� feket�ket is festeni akarom, �s mert karakter k�dokkal k�ne c�mezni, hogy gyorsabb legyen
  (
  clRed,
  clGreen,
  clBlue,
  clYellow,
  clLime,
  clFuchsia,
  clTeal,
  clMaroon,
  clOlive,
  clAqua,
  clGray,
  clPurple
  );

  oMozaikTomb: Array[Empty..LetterZ] of TSquare =
  (
  (('.','.','.','.','.'),  //Ures     //Empty
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('A','A','A','A','A'),  //Hosszu   //LetterI
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('B','B','.','.','.'),  //Elbetu   //LetterL
   ('.','B','.','.','.'),
   ('.','B','.','.','.'),
   ('.','B','.','.','.'),
   ('.','.','.','.','.')),
  (('C','.','.','.','.'),  //Hazteto  //LetterV
   ('C','.','.','.','.'),
   ('C','C','C','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('D','D','D','.','.'),  //Sonka    //LetterP
   ('D','D','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('.','E','.','.','.'),  //Kereszt  //LetterX
   ('E','E','E','.','.'),
   ('.','E','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('F','.','.','.','.'),  //Puska    //LetterY
   ('F','.','.','.','.'),
   ('F','F','.','.','.'),
   ('F','.','.','.','.'),
   ('.','.','.','.','.')),
  (('G','.','.','.','.'),  //Lapat    //LetterN
   ('G','.','.','.','.'),
   ('G','G','.','.','.'),
   ('.','G','.','.','.'),
   ('.','.','.','.','.')),
  (('H','H','.','.','.'),  //Csunya   //LetterF
   ('.','H','H','.','.'),
   ('.','H','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('.','I','.','.','.'),  //Tebetu   //LetterT
   ('.','I','.','.','.'),
   ('I','I','I','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('.','.','J','.','.'),  //Lepcso   //LetterW
   ('.','J','J','.','.'),
   ('J','J','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('K','K','K','.','.'),  //Ubetu    //LetterU
   ('K','.','K','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('L','L','.','.','.'),  //Esbetu   //LetterZ
   ('.','L','.','.','.'),
   ('.','L','L','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'))
  );

implementation

{$R *.dfm}

{---------}
{ TMozaik }
{---------}

constructor TTile.Create(pTile: TTileNames);
begin
  fSquare := oMozaikTomb[pTile];
  fTileType := pTile;
  fVariantIndex := 0;
  fIsOnPlayGround := false;
  Normalize;
end;

function TTile.Compare(pSquare: TSquare): Boolean;
var i, j: Shortint;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if pSquare[i, j] <> fSquare[i, j] then begin
        Result := false;
        Exit;
      end;
     end;
  end;
  Result := true;
end;

procedure TTile.Rotate;
var i, j: Shortint;
    lTempSquare: TSquare;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      lTempSquare[i,j] := fSquare[6-j,i];
    end;
  end;
  fSquare := lTempSquare;
end;

procedure TTile.Normalize;
var i, j, i2, j2, i3, j3, lMinJ, lMinI: Shortint;
    lTempSquare: TSquare;
begin
  if (fSquare[1,1] <> '.') then Exit; //mert nincs mit normaliz�lni

  //minimum keres�s mindk�t koordin�t�ra, ahol ertek = 1
  lMinI := 5;
  for j := 1 to 5 do begin
    i := 0;
    repeat
      inc(i);
    until (fSquare[i,j] <> '.') or (i = 5);
    if i < lMinI then lMinI := i;
  end;
  lMinJ := 5;
  for i := 1 to 5 do begin
    j := 0;
    repeat
      inc(j);
    until (fSquare[i,j] <> '.') or (j = 5);
    if j < lMinJ then lMinJ := j;
  end;

  if (lMinI = 1) and (lMinJ = 1) then begin //mert nincs mit normaliz�lni
  end else begin
    lTempSquare := oMozaikTomb[Empty];

    //majd a k�t sz�mmal jel�lt pontig felm�solni mindent
    i2 := 1;
    for i := lMinI to 5 do begin
      j2 := 1;
      for j := lMinJ to 5 do begin
        lTempSquare[i2,j2] := fSquare[i,j];
        inc(j2);
      end;
      inc(i2);
    end;
    fSquare := lTempSquare;
  end;
  
  //a normaliz�lt n�gyzet els� sor�ban megkeresni az els� �rt�kes jegyet, ez legyen a J offset. Oszlopban elvileg nem kell vele t�r�dni.
  j3 := 0;
  repeat
    inc(j3);
  until (fSquare[1,j3] <> '.') or (j3 = 5);
  fOffsetJ := j3 - 1;             //offset 0-t�l indul, ha a sarokban kezd�dik az �rt�kes jegy
end;

function TTile.Serialize: String;
var s: String;
    i, j: Shortint;
begin
  s := '';
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      s := s + fSquare[i,j];
    end;
    s := s + #13#10;
  end;
  Result := s;
end;

procedure TTile.DeSerialize(pSor: String);
var i, j, k: Shortint;
begin
  k := 1;
  pSor := StringReplace(pSor, #13#10, '', [rfReplaceAll]);
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      fSquare[i,j] := pSor[k];
      inc(k);
    end;
  end;
end;

procedure TTile.Flip;
var i, j: Shortint;
    lTempSquare: TSquare;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      lTempSquare[i,j] := fSquare[i,6-j];
    end;
  end;
  fSquare := lTempSquare;
end;

function TTile.Vary: Boolean;
begin
  if (Length(oMozaikValtozatok[fTileType]) = fVariantIndex) then begin
    Result := false;                                                       //false-szal sz�ll ki, ha m�r nincs t�bb v�ltozat
    Exit;
  end;
  inc(fVariantIndex);
  case oMozaikValtozatok[fTileType][fVariantIndex] of
    'S': ;
    'F': Rotate;
    'T': Flip;
  end;
  Normalize;
  Result := true;                                                          //true-val, ha csin�lt valamit
end;

{-----------}
{ TJatekTer }
{-----------}

constructor TPlayGround.Create;
var i, j: Shortint;
begin
  for i := 1 to 6 do begin      //l�nyeg
    for j := 1 to 10 do begin
      fRectangle[i,j] := '.';
    end;
  end;

  for i := -4 to 0 do begin     //teteje
    for j := -4 to 15 do begin
      fRectangle[i,j] := 'M';
    end;
  end;
  for i := 7 to 11 do begin     //alja
    for j := -4 to 15 do begin
      fRectangle[i,j] := 'M';
    end;
  end;
  for i := 1 to 6 do begin     //bal oldala
    for j := -4 to 0 do begin
      fRectangle[i,j] := 'M';
    end;
  end;
  for i := 1 to 6 do begin     //jobb oldala
    for j := 11 to 15 do begin
      fRectangle[i,j] := 'M';
    end;
  end;

  fNumberOfTilesOnPlayGround := 0;
end;

function TPlayGround.Compare(pRectangle: TRectangle): Boolean;
var i, j: Shortint;
begin
  for i := -4 to 11 do begin
    for j := -4 to 15 do begin
      if pRectangle[i, j] <> fRectangle[i, j] then begin
        Result := false;
        Exit;
      end;
     end;
  end;
  Result := true;
end;

function TPlayGround.IsPuttableHere(pTile: TTile; pI, pJ: Shortint): Boolean;
var i, j: Shortint;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if ((pTile.fSquare[i,j] <> '.') and (fRectangle[pI+i-1,pJ-pTile.fOffsetJ+j-1] <> '.')) //egybel�g�s lenne
         or
         ((pTile.fSquare[i,j] <> '.') and (fRectangle[pI+i-1,pJ-pTile.fOffsetJ+j-1] = 'M')) then begin //kil�g�s lenne
        Result := false;
        Exit;
      end;
    end;
  end;
  Result := true;
end;

procedure TPlayGround.Put(pTile: TTile; pI, pJ: Shortint);
var i, j: Shortint;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if pTile.fSquare[i,j] <> '.' then begin
        fRectangle[pI+i-1,pJ-pTile.fOffsetJ+j-1] := pTile.fSquare[i,j];
      end;
    end;
  end;
  pTile.fIsOnPlayGround := true;
  inc(fNumberOfTilesOnPlayGround);
end;

procedure TPlayGround.TakeOff(pTile: TTile; pI, pJ: Shortint); //ez alapb�l poz�ci� n�lk�li fejl�ces volt, emiatt a ciklusai 6-ig/10-ig mentek, c�mz�s is m�s volt
var i, j: Shortint;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if fRectangle[pI+i-1,pJ-pTile.fOffsetJ+j-1] = oMozaikKarakterek[pTile.fTileType] then begin
        fRectangle[pI+i-1,pJ-pTile.fOffsetJ+j-1] := '.';
      end;
    end;
  end;
  pTile.fIsOnPlayGround := false;
  dec(fNumberOfTilesOnPlayGround);
end;

function TPlayGround.IsReady: Boolean;
begin
  Result := (fNumberOfTilesOnPlayGround = 12);
end;

function TPlayGround.Serialize: String; //TODO ez a Serialize az�rt el�gg� olyan, mint a Mozaik�... k�z�s �st�l �r�k�ltetni pl...
var s: String;
    i, j: Shortint;
begin
  s := '';
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      s := s + fRectangle[i,j];
    end;
    s := s + #13#10;
  end;
  Result := s;
end;

procedure TPlayGround.DeSerialize(pSor: String); //TODO DeSerialize-t is kiemelni k�z�s �sbe...
var i, j, k: Shortint;
begin
  k := 1;
  pSor := StringReplace(pSor, #13#10, '' ,[rfReplaceAll]);
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      fRectangle[i,j] := pSor[k];
      inc(k);
    end;
  end;
end;

procedure TPlayGround.FindFirstEmpty;
var i, j: Shortint;
begin
  fFirstEmptyI := 7;                                       //ezen �rt�kek jelzik, ha nincs m�r �res poz�ci�, azaz m�r teli van a j�t�kt�r
  fFirstEmptyJ := 11;
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if fRectangle[i,j] = '.' then begin
        fFirstEmptyI := i;
        fFirstEmptyJ := j;
        Exit;
      end;
    end;
  end;
end;

procedure TPlayGround.Stop;
var i, j: Shortint;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      fRectangle[i,j] := 'M';
    end;
  end;
end;

function TPlayGround.IsThereSingleHole: Boolean;
var i, j: Shortint;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i,j-1] <> '.') then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

function TPlayGround.IsThereDoubleHole: Boolean;
var i, j: Shortint;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //kettes z�rv�ny v�zszintesen
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //kettes z�rv�ny f�gg�legesen
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

//valszeg gond lesz a t�mb t�lc�mz�sekb�l a 3-4-es lyukvizsg�latokn�l. valszeg b�v�teni k�ne �jabb sor M bet�kkel minden ir�nyba a t�bl�t, k�l�nben a t�bla sz�l�n lyuktal�l�s helyett "out of bonds" lesz
//tal�n r�vidz�r ki�rt�kel�ssel el lehetne ker�lni, illetve kiv�deni
//m�gjobb: ami 3-as vagy 4-es z�rv�nyn�l t�mb t�lc�mz�st eredm�nyezne, az el�bb akad fel a 2-es vagy az 1-es vizsg�latn�l. Csak �gyesen kell �ket egym�s ut�n dr�tozni �lesben.
//s�t! teszt tesztje alapj�n mintha nem is akarna elsz�llni ebben... nem �rtem, h mi�rt nem. r�vidz�rat teljesen felbor�tva, a t�lc�mz�s "and" r�szeket el�re rakva sem akar elsz�llni.
//google: default-ban van short circuit evaluation: https://stackoverflow.com/questions/15084323/delphi-and-evaluation-with-2-conditions
// {$BOOLEVAL ON} kapcsol�val a Main.pas �s a MainTest.pas elej�ben sem sz�ll el. Beszarok.

function TPlayGround.IsThereTripleHole: Boolean;
var i, j: Shortint;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i,j+2] = '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i,j+3] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
       and
         (fRectangle[i-1,j+2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //h�rmas z�rv�ny v�zszintesen (#1)
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+3,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //h�rmas z�rv�ny f�gg�legesen  (#2)
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //#3
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j-1] = '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //#4
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#5
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#6
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

function TPlayGround.IsThereQuadrupleHole: Boolean;
var i, j: Shortint;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i,j+2] = '.')
       and
         (fRectangle[i,j+3] = '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+1,j+3] <> '.')
       and
         (fRectangle[i,j+4] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
       and
         (fRectangle[i-1,j+2] <> '.')
       and
         (fRectangle[i-1,j+3] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //n�gyes z�rv�ny v�zszintesen (#1)
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i+3,j] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+3,j+1] <> '.')
       and
         (fRectangle[i+4,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+3,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //n�gyes z�rv�ny f�gg�legesen  (#2)
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i+1,j+2] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+3] <> '.')
       and
         (fRectangle[i+2,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#3
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j-1] = '.')
       and
         (fRectangle[i+1,j-2] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+2,j-2] <> '.')
       and
         (fRectangle[i+1,j-3] <> '.')
       and
         (fRectangle[i,j-2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#4
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i,j+2] = '.')
       and
         (fRectangle[i+1,j+2] = '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
       and
         (fRectangle[i-1,j+2] <> '.')
       and
         (fRectangle[i,j+3] <> '.')
       and
         (fRectangle[i+1,j+3] <> '.')
       and
         (fRectangle[i+2,j+2] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //#5
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i,j+2] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
       and
         (fRectangle[i-1,j+2] <> '.')
       and
         (fRectangle[i,j+3] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
      then begin                                //#6
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i+2,j+1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j+2] <> '.')
       and
         (fRectangle[i+3,j+1] <> '.')
       and
         (fRectangle[i+3,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#7
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i+2,j-1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+3,j] <> '.')
       and
         (fRectangle[i+3,j-1] <> '.')
       and
         (fRectangle[i+2,j-2] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#8
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i+2,j+1] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+2] <> '.')
       and
         (fRectangle[i+3,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#9
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+3,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#10
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i+2,j+1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+2] <> '.')
       and
         (fRectangle[i+3,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#11
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j-1] = '.')
       and
         (fRectangle[i+2,j-1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+3,j-1] <> '.')
       and
         (fRectangle[i+2,j-2] <> '.')
       and
         (fRectangle[i+1,j-2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#12
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i+1,j+2] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+3] <> '.')
       and
         (fRectangle[i+2,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#13
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j-1] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#14
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i,j+2] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i,j+3] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+1,j] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
       and
         (fRectangle[i-1,j+2] <> '.')
      then begin                                //#15
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+1,j-1] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#16
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+3,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#17
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i+2,j] = '.')
       and
         (fRectangle[i+1,j-1] = '.')
       and
         (fRectangle[i,j+1] <> '.')
       and
         (fRectangle[i+1,j+1] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+3,j] <> '.')
       and
         (fRectangle[i+2,j-1] <> '.')
       and
         (fRectangle[i+1,j-2] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
      then begin                                //#18
        Result := true;
        Exit;
      end;
      if (fRectangle[i,j] = '.')
       and
         (fRectangle[i+1,j] = '.')
       and
         (fRectangle[i,j+1] = '.')
       and
         (fRectangle[i+1,j+1] = '.')
       and
         (fRectangle[i,j+2] <> '.')
       and
         (fRectangle[i+1,j+2] <> '.')
       and
         (fRectangle[i+2,j+1] <> '.')
       and
         (fRectangle[i+2,j] <> '.')
       and
         (fRectangle[i+1,j-1] <> '.')
       and
         (fRectangle[i,j-1] <> '.')
       and
         (fRectangle[i-1,j] <> '.')
       and
         (fRectangle[i-1,j+1] <> '.')
      then begin                                //#19
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

{----------}
{ TfrmMain }
{----------}

procedure TfrmMain.btnKeresClick(Sender: TObject);
var iTipus: TTileNames;
    i: Shortint;
begin
  btnKeres.Enabled := false;
  fSolutionIndex := 0;
  fNumberOfPuts := 0;

  fPlayGround := TPlayGround.Create;
  for iTipus := LetterI to LetterZ do begin
    fTiles[iTipus] := TTile.Create(iTipus);
  end;

  AssignFile(fResults, 'results.txt');
  Rewrite(fResults);
  CloseFile(fResults);

  Recursive;

end;

procedure TfrmMain.dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Assigned(fPlayGround) then begin
    if fPlayGround.fRectangle[ARow+1,ACol+1] <> '.' then begin
      dwgdLenyeg.Canvas.Brush.Color := oMozaikSzinek[Ord(fPlayGround.fRectangle[ARow+1,ACol+1]) - Ord('@')];
      //a cell�ban l�v� karakter ascii k�dj�b�l kivonjuk az A-1 ascii k�dj�t, ezzel az integerrel m�r c�mezhet� a sz�nes t�mb
    end else begin
      dwgdLenyeg.Canvas.Brush.Color := clWhite;
      //az �res cell�ban . van, az t�vol van ascii k�dilag a bet�kt�l, nem lehet k�nnyen c�mezhet�v� tenni a sz�nes t�mb�t �gy
    end;

    dwgdLenyeg.Canvas.FillRect(Rect);
  end;
end;

procedure TfrmMain.SetTempo;
begin
  case rgrpTempo.ItemIndex of
    0:begin
      end;
    1:begin
        dwgdLenyeg.Repaint;
      end;
    2:begin
        dwgdLenyeg.Repaint;
        Sleep(500);
      end;
  end;
  Application.ProcessMessages;
end;

procedure TfrmMain.Save;
var f: TextFile;
    iTipus: TTileNames;
    i: Shortint;
begin
  {AssignFile(f, 'save.txt');
  Rewrite(f);

  for i := 1 to 12 do begin
    Writeln(f, IntToStr(ord(fRekurzioSzintjei[i])));
  end;

  for iTipus := Hosszu to Esbetu do begin
    Writeln(f, fMozaikok[iTipus].Serialize);
    fMozaikTipust nem �rom ki, mert redund�ns inf� n�mileg �s nincs is ..ToStr-je :)
    Writeln(f, IntToStr(fMozaikok[iTipus].fValtozatIndex));
    Writeln(f, IntToStr(fMozaikok[iTipus].fIttVoltUtoljaraI));
    Writeln(f, IntToStr(fMozaikok[iTipus].fIttVoltUtoljaraJ));
    if fMozaikok[iTipus].fKiVanRakva then Writeln(f, 'true')
                                     else Writeln(f, 'false');
  end;

  Writeln(f,fJatekter.Serialize);
  Writeln(f,IntToStr(fJatekter.fKirakottMennyiseg));

  CloseFile(f);
  }
end;

procedure TfrmMain.Load;
var f: TextFile;
    iTipus: TTileNames;
    i, j: Shortint;
    lSor, lSorMind: String;
begin
  {AssignFile(f, 'save.txt');
  Reset(f);

  for i := 1 to 12 do begin
    Readln(f, j);
    //fRekurzioSzintjei[i] := TTileNames(j);
  end;

  for iTipus := Hosszu to Esbetu do begin
    lsorMind := '';
    for i := 1 to 6 do begin
      Readln(f, lSor);
      lSorMind := lSorMind + lSor;
    end;
    fMozaikok[iTipus].DeSerialize(lSorMind);
    fMozaikok[iTipus].fMozaikTipus := iTipus;   //visszafel� be�rom a redund�ns cuccba a ciklusv�ltoz�t, biztos ami biztos

    Readln(f, lSor);
    fMozaikok[iTipus].fValtozatIndex := StrToInt(lSor);

    Readln(f, lSor);
    fMozaikok[iTipus].fIttVoltUtoljaraI := StrToInt(lSor);

    Readln(f, lSor);
    fMozaikok[iTipus].fIttVoltUtoljaraJ := StrToInt(lSor);

    Readln(f, lSor);
    if lSor = 'true' then fMozaikok[iTipus].fKiVanRakva := true
                     else fMozaikok[iTipus].fKiVanRakva := false;
    fMozaikok[iTipus].fKiVanRakva := false;

  end;

  lsorMind := '';
  for i := 1 to 8 do begin
    Readln(f, lSor);
    lSorMind := lSorMind + lSor;
  end;
  fJatekter.DeSerialize(lSorMind);

  Readln(f, lSor);
  fJatekter.fKirakottMennyiseg := StrToInt(lSor);

  Readln(f, lSor);

  CloseFile(f);
  }
end;

procedure TfrmMain.Recursive;
var jTipus: TTileNames;
    lElsoUresI, lElsoUresJ: Shortint;
begin
  if fPlayGround.IsReady then begin
    //ShowMessage('12');              //TODO itt elk�lne n�mi alprogramos�t�s
    inc(fSolutionIndex);
    edtTalalatokSzama.Text := IntToStr(fSolutionIndex);
    Append(fResults);
    Writeln(fResults, '#' + IntToStr(fSolutionIndex));
    Writeln(fResults, fPlayGround.Serialize + #13#10);
    CloseFile(fResults);
  end;
  for jTipus := LetterI to LetterZ do begin
    if (not fTiles[jTipus].fIsOnPlayGround) then begin   // tal�n gond, h leszed�s ut�n ez �gy az �pp leszedettet akarja majd visszarakni? -> a ciklus ezt kiv�di, akkor az ott v�lt... de egy h�v�ssal kiljebb m�r igen
      fPlayGround.FindFirstEmpty;
      lElsoUresI := fPlayGround.fFirstEmptyI;
      lElsoUresJ := fPlayGround.fFirstEmptyJ;
      while fTiles[jTipus].Vary do begin
        if fPlayGround.IsPuttableHere(fTiles[jTipus], lElsoUresI, lElsoUresJ) then begin // g�z: ha k�sz a t�bla, akkor ez (7, 11)-re visz, de v�g�lis ebbe az ifbe akkor m�r nem is j�n be
          SetTempo;
          fPlayGround.Put(fTiles[jTipus], lElsoUresI, lElsoUresJ);
          inc(fNumberOfPuts);
          SetTempo;
          if fPlayGround.IsThereSingleHole or fPlayGround.IsThereDoubleHole or fPlayGround.IsThereTripleHole or fPlayGround.IsThereQuadrupleHole then begin
            SetTempo;
            fPlayGround.TakeOff(fTiles[jTipus], lElsoUresI, lElsoUresJ);
            SetTempo;
          end else begin
            Recursive;
            SetTempo;
            fPlayGround.TakeOff(fTiles[jTipus], lElsoUresI, lElsoUresJ);
            SetTempo;
          end;
        end; // if
      end; // while
      fTiles[jTipus].fVariantIndex := 0;  //TODO itt elk�lne n�mi alprogramos�t�s
    end; // if
  end; // for
end;

procedure TfrmMain.tmrTimerTimer(Sender: TObject);
begin
  edtSebesseg.Text := IntToStr(fNumberOfPuts);
  fNumberOfPuts := 0;

  edtElkeszult.Text := IntToStr(Round(fSolutionIndex*100/9356));
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var iTipus: TTileNames;
    i: Shortint;
begin
  for iTipus := LetterI to LetterZ do begin
    fTiles[iTipus].Free;
  end;
  fPlayGround.Free;
end;

end.
