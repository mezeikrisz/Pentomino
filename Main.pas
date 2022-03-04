unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids;

type
  TNegyzet = Array[1..5,1..5] of Char; //sorindex majd oszlopindex, tehát fordítva, mint pixelcímzésnél

  TTeglalap = Array[1..7,1..11] of Char; //sorindex majd oszlopindex

  TMozaikNevek = (Ures, Hosszu, Elbetu, Hazteto, Sonka, Kereszt, Puska, Lapat, Csunya, Tebetu, Lepcso, Ubetu, Esbetu);

  TMozaik = class(TObject)
  public //private //hogy rálásson a test, egyelõre public minden
    fNegyzet: TNegyzet;
    fMozaikTipus: TMozaikNevek;
    fValtozatIndex: Byte;
    fIttVoltUtoljaraI, fIttVoltUtoljaraJ: Byte;
    fOffsetJ: Byte;
    fKiVanRakva: Boolean;
    constructor Create(pMozaik: TMozaikNevek);
    procedure Forgat;      //fNegyzetet megforgatja clockwise [3,3]-as középponttal
    procedure Tukroz;      //fNegyzetet tükrözi függõleges tengelyre
    procedure Normalizal;  //fNegyzet 1-eseit a balfelsõ sarokba tolja
    function Hasonlit(pNegyzet: TNegyzet): Boolean;   //fNegyzetet másik TNegyzettel hasonlít
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    function Valtoztat: Boolean; //elõállítja a köv változatot fNegyzet-be, ha lehet még
  end;

  TJatekTer = class(TObject)
  public //private //hogy rálásson a test, egyelõre public minden
    fTeglalap: TTeglalap;
    fKirakottMennyiseg: Integer;
    fElsoUresI, fElsoUresJ: Byte;
    constructor Create;
    function KirakhatoIde(pMozaik: TMozaik; pI, pJ: Byte): Boolean;
    procedure Kirak(pMozaik: TMozaik; pI, pJ: Byte);
    function LyukLenneEgy: Boolean;
    function LyukLenneKetto: Boolean;
    function LyukLenneHarom: Boolean;
    function LyukLenneNegy: Boolean;
    procedure KeresElsoUres;
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    procedure Levesz(pMozaik: TMozaik; pI, pJ: Byte);
    function KeszVan: Boolean;
    procedure Leallit;
  end;

  TfrmMain = class(TForm)
    btnKeres: TButton;
    dwgdLenyeg: TDrawGrid;
    rgrpTempo: TRadioGroup;
    lblKirakottMennyiseg: TLabel;
    procedure btnKeresClick(Sender: TObject);
    procedure dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
  private
    i, j: Byte;
    fMozaikok: Array[Hosszu..Esbetu] of TMozaik;
    fJatekter: TJatekTer;
    fRekurzioSzintjei: Array[1..12] of TMozaikNevek;
    f: TextFile;
    fHanyadikMegoldas: Integer;
    fAktualisSzint: Byte;
    fToltottAktSzint: Byte;
  public
    procedure Rekurziv;
    procedure SetTempo;
    procedure Save;
    procedure Load;
  end;

var
  frmMain: TfrmMain;

  oMenteniKell, oToltveVolt: Boolean;

  oMozaikValtozatok: Array[Ures..Esbetu] of String =
  (
  'S',          //üres négyzetet nincs értelme forgatni/tükrözni
  'SF',         //a Hosszut egyszer lehet Forgatni, több változat nincs..
  'SFFFTFFF',   //az Elbetut körbe lehet Forgatni, akkor Tükrözni, majd megint Forgatni..
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

  oMozaikKarakterek: Array[Ures..Esbetu] of Char =
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

  oMozaikSzinek: Array[0..12] of TColor =    //ez most nem enummal címezve, mert a szélsõ feketéket is festeni akarom, és mert karakter kódokkal kéne címezni, hogy gyorsabb legyen
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
  clPurple,
  clBlack
  );

  oMozaikTomb: Array[Ures..Esbetu] of TNegyzet =
  (
  (('.','.','.','.','.'),  //Ures
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('A','A','A','A','A'),  //Hosszu
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('B','B','.','.','.'),  //Elbetu
   ('.','B','.','.','.'),
   ('.','B','.','.','.'),
   ('.','B','.','.','.'),
   ('.','.','.','.','.')),
  (('C','.','.','.','.'),  //Hazteto
   ('C','.','.','.','.'),
   ('C','C','C','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('D','D','D','.','.'),  //Sonka
   ('D','D','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('.','E','.','.','.'),  //Kereszt
   ('E','E','E','.','.'),
   ('.','E','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('F','.','.','.','.'),  //Puska
   ('F','.','.','.','.'),
   ('F','F','.','.','.'),
   ('F','.','.','.','.'),
   ('.','.','.','.','.')),
  (('G','.','.','.','.'),  //Lapat
   ('G','.','.','.','.'),
   ('G','G','.','.','.'),
   ('.','G','.','.','.'),
   ('.','.','.','.','.')),
  (('H','H','.','.','.'),  //Csunya
   ('.','H','H','.','.'),
   ('.','H','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('.','I','.','.','.'),  //Tebetu
   ('.','I','.','.','.'),
   ('I','I','I','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('.','.','J','.','.'),  //Lepcso
   ('.','J','J','.','.'),
   ('J','J','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('K','K','K','.','.'),  //Ubetu
   ('K','.','K','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.'),
   ('.','.','.','.','.')),
  (('L','L','.','.','.'),  //Esbetu
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

constructor TMozaik.Create(pMozaik: TMozaikNevek);
begin
  fNegyzet := oMozaikTomb[pMozaik];
  fMozaikTipus := pMozaik;
  fValtozatIndex := 0;
  fIttVoltUtoljaraI := 0;
  fIttVoltUtoljaraJ := 0;
  fKiVanRakva := false;
  Normalizal;
end;

procedure TMozaik.Forgat;
var i, j: Byte;
    lTempNegyzet: TNegyzet;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      lTempNegyzet[i,j] := fNegyzet[6-j,i];
    end;
  end;
  fNegyzet := lTempNegyzet;
end;

procedure TMozaik.Normalizal;
var i, j, i2, j2, i3, j3, lMinJ, lMinI: Byte;
    lTempNegyzet: TNegyzet;
begin
  if (fNegyzet[1,1] <> '.') then Exit; //mert nincs mit normalizálni

  //minimum keresés mindkét koordinátára, ahol ertek = 1
  lMinI := 5;
  for j := 1 to 5 do begin
    i := 0;
    repeat
      inc(i);
    until (fNegyzet[i,j] <> '.') or (i = 5);
    if i < lMinI then lMinI := i;
  end;
  lMinJ := 5;
  for i := 1 to 5 do begin
    j := 0;
    repeat
      inc(j);
    until (fNegyzet[i,j] <> '.') or (j = 5);
    if j < lMinJ then lMinJ := j;
  end;

  if (lMinI = 1) and (lMinJ = 1) then begin //mert nincs mit normalizálni
  end else begin
    lTempNegyzet := oMozaikTomb[Ures];

    //majd a két számmal jelölt pontig felmásolni mindent
    i2 := 1;
    for i := lMinI to 5 do begin
      j2 := 1;
      for j := lMinJ to 5 do begin
        lTempNegyzet[i2,j2] := fNegyzet[i,j];
        inc(j2);
      end;
      inc(i2);
    end;
    fNegyzet := lTempNegyzet;
  end;
  
  //a normalizált négyzet elsõ sorában megkeresni az elsõ értékes jegyet, ez legyen a J offset. Oszlopban elvileg nem kell vele törõdni.
  j3 := 0;
  repeat
    inc(j3);
  until (fNegyzet[1,j3] <> '.') or (j3 = 5);
  fOffsetJ := j3 - 1;             //offset 0-tól indul, ha a sarokban kezdõdik az értékes jegy
end;

function TMozaik.Serialize: String;
var s: String;
    i, j: Byte;
begin
  s := '';
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      s := s + fNegyzet[i,j];
    end;
    s := s + #13#10;
  end;
  Result := s;
end;

procedure TMozaik.DeSerialize(pSor: String);
var i, j, k: Byte;
begin
  k := 1;
  pSor := StringReplace(pSor, #13#10, '', [rfReplaceAll]);
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      fNegyzet[i,j] := pSor[k];
      inc(k);
    end;
  end;
end;

procedure TMozaik.Tukroz;
var i, j: Byte;
    lTempNegyzet: TNegyzet;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      lTempNegyzet[i,j] := fNegyzet[i,6-j];
    end;
  end;
  fNegyzet := lTempNegyzet;
end;

function TMozaik.Valtoztat: Boolean;
begin
  if (Length(oMozaikValtozatok[fMozaikTipus]) = fValtozatIndex) then begin
    Result := false;                                                       //false-szal száll ki, ha már nincs több változat
    Exit;
  end;
  inc(fValtozatIndex);
  case oMozaikValtozatok[fMozaikTipus][fValtozatIndex] of
    'S': ;
    'F': Forgat;
    'T': Tukroz;
  end;
  Normalizal;
  Result := true;                                                          //true-val, ha csinált valamit
end;

function TMozaik.Hasonlit(pNegyzet: TNegyzet): Boolean;
var i, j: Integer;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if pNegyzet[i, j] <> fNegyzet[i, j] then begin
        Result := false;
        Exit;
      end;
     end;
  end;
  Result := true;
end;

{-----------}
{ TJatekTer }
{-----------}

constructor TJatekTer.Create;
var i, j: Byte;
begin
  for i := 1 to 7 do begin
    for j := 1 to 11 do begin
      fTeglalap[i,j] := '.';
    end;
  end;
  for i := 1 to 7 do begin
    fTeglalap[i,11] := 'M';
  end;
  for j := 1 to 11 do begin
    fTeglalap[7,j] := 'M';
  end;
  fKirakottMennyiseg := 0;
end;

function TJatekTer.KirakhatoIde(pMozaik: TMozaik; pI, pJ: Byte): Boolean;
var i, j: Byte;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin                    
      if ((pMozaik.fNegyzet[i,j] <> '.') and (fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] <> '.')) //egybelógás lenne
         or
         ((pMozaik.fNegyzet[i,j] <> '.') and (fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] = 'M')) then begin //kilógás lenne
        Result := false;
        Exit;
      end;
    end;
  end;
  Result := true;
end;

procedure TJatekTer.Kirak(pMozaik: TMozaik; pI, pJ: Byte);
var i, j: Byte;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if pMozaik.fNegyzet[i,j] <> '.' then begin
        fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] := pMozaik.fNegyzet[i,j];
      end;
    end;
  end;
  pMozaik.fKiVanRakva := true;         //állapotjelzõ kell ez?
  inc(fKirakottMennyiseg);             //állapotjelzõ kell ez?

end;

procedure TJatekTer.Levesz(pMozaik: TMozaik; pI, pJ: Byte); //ez alapból pozíció nélküli fejléces volt, emiatt a ciklusai 6-ig/10-ig mentek, címzés is más volt
var i, j: Byte;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] = oMozaikKarakterek[pMozaik.fMozaikTipus] then begin
        fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] := '.';
      end;
    end;
  end;
  pMozaik.fKiVanRakva := false;        //állapotjelzõ kell ez?
  dec(fKirakottMennyiseg);             //állapotjelzõ kell ez?

end;

function TJatekTer.KeszVan: Boolean;
begin
  Result := (fKirakottMennyiseg = 12);
end;

function TJatekTer.Serialize: String; //TODO ez a Serialize azárt eléggé olyan, mint a Mozaiké... közös õstõl örökölni 1 parammal...
var s: String;
    i, j: Byte;
begin
  s := '';
  for i := 1 to 7 do begin
    for j := 1 to 11 do begin
      s := s + fTeglalap[i,j];
    end;
    s := s + #13#10;
  end;
  Result := s;
end;

procedure TJatekTer.DeSerialize(pSor: String); //TODO DeSerialize-t is kiemelni közös õsbe...
var i, j, k: Byte;
begin
  k := 1;
  pSor := StringReplace(pSor, #13#10, '' ,[rfReplaceAll]);
  for i := 1 to 7 do begin
    for j := 1 to 11 do begin
      fTeglalap[i,j] := pSor[k];
      inc(k);
    end;
  end;
end;

procedure TJatekTer.KeresElsoUres;
var i, j: Byte;
begin
  fElsoUresI := 7;                                       //ezen értékek jelzik, ha nincs már üres pozíció, azaz már teli van a játéktér
  fElsoUresJ := 11;
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if fTeglalap[i,j] = '.' then begin
        fElsoUresI := i;
        fElsoUresJ := j;
        Exit;
      end;
    end;
  end;
end;

procedure TJatekTer.Leallit;
var i, j: Byte;
begin
  for i := 1 to 11 do begin
    for j := 1 to 7 do begin
      fTeglalap[i,j] := 'M';
    end;
  end;
end;

function TJatekTer.LyukLenneEgy: Boolean;
var i, j: Byte;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.') then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

function TJatekTer.LyukLenneKetto: Boolean;
var i, j: Byte;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //kettes zárvány vízszintesen
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //kettes zárvány függõlegesen
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

//valszeg gond lesz a tömb túlcímzésekbõl a 3-4-es lyukvizsgálatoknál. valszeg bõvíteni kéne újabb sor M betûkkel minden irányba a táblát, különben a tábla szélén lyuktalálás helyett "out of bonds" lesz
//talán rövidzár kiértékeléssel el lehetne kerülni, illetve kivédeni
//mégjobb: ami 3-as vagy 4-es zárványnál tömb túlcímzést eredményezne, az elõbb akad fel a 2-es vagy az 1-es vizsgálatnál. Csak ügyesen kell õket egymás után drótozni élesben.
//sõt! teszt tesztje alapján mintha nem is akarna elszállni ebben... nem értem, h miért nem. rövidzárat teljesen felborítva, a túlcímzõs "and" részeket elõre rakva sem akar elszállni.
//google: default-ban van short circuit evaluation: https://stackoverflow.com/questions/15084323/delphi-and-evaluation-with-2-conditions
// {$BOOLEVAL ON} kapcsolóval a Main.pas és a MainTest.pas elejében sem száll el. Beszarok.

function TJatekTer.LyukLenneHarom: Boolean;
var i, j: Byte;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i,j+2] = '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i,j+3] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
       and
         (fTeglalap[i-1,j+2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //hármas zárvány vízszintesen (#1)
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+3,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //hármas zárvány függõlegesen  (#2)
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //#3
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j-1] = '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //#4
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
      then begin                                //#5
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
      then begin                                //#6
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

function TJatekTer.LyukLenneNegy: Boolean;
var i, j: Byte;
begin
  for i := 1 to 6 do begin
    for j := 1 to 10 do begin
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i,j+2] = '.')
       and
         (fTeglalap[i,j+3] = '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+1,j+3] <> '.')
       and
         (fTeglalap[i,j+4] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
       and
         (fTeglalap[i-1,j+2] <> '.')
       and
         (fTeglalap[i-1,j+3] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //négyes zárvány vízszintesen (#1)
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i+3,j] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+3,j+1] <> '.')
       and
         (fTeglalap[i+4,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+3,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //négyes zárvány függõlegesen  (#2)
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i+1,j+2] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+3] <> '.')
       and
         (fTeglalap[i+2,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#3
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j-1] = '.')
       and
         (fTeglalap[i+1,j-2] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+2,j-2] <> '.')
       and
         (fTeglalap[i+1,j-3] <> '.')
       and
         (fTeglalap[i,j-2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#4
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i,j+2] = '.')
       and
         (fTeglalap[i+1,j+2] = '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
       and
         (fTeglalap[i-1,j+2] <> '.')
       and
         (fTeglalap[i,j+3] <> '.')
       and
         (fTeglalap[i+1,j+3] <> '.')
       and
         (fTeglalap[i+2,j+2] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //#5
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i,j+2] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
       and
         (fTeglalap[i-1,j+2] <> '.')
       and
         (fTeglalap[i,j+3] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
      then begin                                //#6
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i+2,j+1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j+2] <> '.')
       and
         (fTeglalap[i+3,j+1] <> '.')
       and
         (fTeglalap[i+3,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#7
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i+2,j-1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+3,j] <> '.')
       and
         (fTeglalap[i+3,j-1] <> '.')
       and
         (fTeglalap[i+2,j-2] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#8
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i+2,j+1] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+2] <> '.')
       and
         (fTeglalap[i+3,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
      then begin                                //#9
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+3,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
      then begin                                //#10
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i+2,j+1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+2] <> '.')
       and
         (fTeglalap[i+3,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#11
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j-1] = '.')
       and
         (fTeglalap[i+2,j-1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+3,j-1] <> '.')
       and
         (fTeglalap[i+2,j-2] <> '.')
       and
         (fTeglalap[i+1,j-2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#12
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i+1,j+2] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+3] <> '.')
       and
         (fTeglalap[i+2,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
      then begin                                //#13
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j-1] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
      then begin                                //#14
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i,j+2] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i,j+3] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+1,j] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
       and
         (fTeglalap[i-1,j+2] <> '.')
      then begin                                //#15
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+1,j-1] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#16
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+3,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#17
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i+2,j] = '.')
       and
         (fTeglalap[i+1,j-1] = '.')
       and
         (fTeglalap[i,j+1] <> '.')
       and
         (fTeglalap[i+1,j+1] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+3,j] <> '.')
       and
         (fTeglalap[i+2,j-1] <> '.')
       and
         (fTeglalap[i+1,j-2] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
      then begin                                //#18
        Result := true;
        Exit;
      end;
      if (fTeglalap[i,j] = '.')
       and
         (fTeglalap[i+1,j] = '.')
       and
         (fTeglalap[i,j+1] = '.')
       and
         (fTeglalap[i+1,j+1] = '.')
       and
         (fTeglalap[i,j+2] <> '.')
       and
         (fTeglalap[i+1,j+2] <> '.')
       and
         (fTeglalap[i+2,j+1] <> '.')
       and
         (fTeglalap[i+2,j] <> '.')
       and
         (fTeglalap[i+1,j-1] <> '.')
       and
         (fTeglalap[i,j-1] <> '.')
       and
         (fTeglalap[i-1,j] <> '.')
       and
         (fTeglalap[i-1,j+1] <> '.')
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

procedure TfrmMain.FormCreate(Sender: TObject);
var lMentveVolt: Boolean;
    iTipus: TMozaikNevek;
    i: Byte;
begin
  oMenteniKell := false;
  oToltveVolt := false;

  fAktualisSzint := 0;
  for i := 1 to 12 do begin
    fRekurzioSzintjei[i] := Ures;
  end;

  fToltottAktSzint := 0;

  fJatekter := TJatekTer.Create;

  for iTipus := Hosszu to Esbetu do begin
    fMozaikok[iTipus] := TMozaik.Create(iTipus);
  end;

  lMentveVolt := FileExists('save.txt');

  btnKeres.Enabled := not lMentveVolt;
end;

procedure TfrmMain.btnKeresClick(Sender: TObject);
begin
  btnKeres.Enabled := false;

  AssignFile(f, 'results.txt');
  Rewrite(f);
  fHanyadikMegoldas := 0;

  //load-dal kezdõs esetben most nincs nyitva a results...
  //olyankor is nyitni, de esetleg a méretétõl függõen hozzáírásra/újraírásra
  //fHanyadikMegoldast file-ból tölteni, tehát elõtte el is menteni...

  Rekurziv;

  CloseFile(f);
  //save-nél results-ot is zárni!!
end;

procedure TfrmMain.dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Assigned(fJatekter) then begin
    if fJatekter.fTeglalap[ARow+1,ACol+1] <> '.' then begin
      dwgdLenyeg.Canvas.Brush.Color := oMozaikSzinek[Ord(fJatekter.fTeglalap[ARow+1,ACol+1]) - Ord('A')];
      //a cellában lévõ karakter ascii kódjából kivonjuk az A ascii kódját, ezzel az integerrel már címezhetõ a színes tömb
    end else begin
      dwgdLenyeg.Canvas.Brush.Color := clWhite;
      //az üres cellában . van, az távol van ascii kódilag a betûktõl, nem lehet könnyen címezhetõvé tenni a színes tömböt így
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
  lblKirakottMennyiseg.Caption := IntToStr(fJatekter.fKirakottMennyiseg);
  Application.ProcessMessages;
end;

procedure TfrmMain.Save;
var f: TextFile;
    iTipus: TMozaikNevek;
    i: Byte;
begin

  AssignFile(f, 'save.txt');
  Rewrite(f);

  for i := 1 to 12 do begin
    Writeln(f, IntToStr(ord(fRekurzioSzintjei[i])));
  end;

  for iTipus := Hosszu to Esbetu do begin
    Writeln(f, fMozaikok[iTipus].Serialize);
    //fMozaikTipust nem írom ki, mert redundáns infó némileg és nincs is ..ToStr-je :)
    Writeln(f, IntToStr(fMozaikok[iTipus].fValtozatIndex));
    Writeln(f, IntToStr(fMozaikok[iTipus].fIttVoltUtoljaraI));
    Writeln(f, IntToStr(fMozaikok[iTipus].fIttVoltUtoljaraJ));
    if fMozaikok[iTipus].fKiVanRakva then Writeln(f, 'true')
                                     else Writeln(f, 'false');
  end;

  Writeln(f,fJatekter.Serialize);
  Writeln(f,IntToStr(fJatekter.fKirakottMennyiseg));
  Writeln(f,IntToStr(fAktualisSzint));

  CloseFile(f);

end;

procedure TfrmMain.Load;
var f: TextFile;
    iTipus: TMozaikNevek;
    i, j: Byte;
    lSor, lSorMind: String;
begin
  AssignFile(f, 'save.txt');
  Reset(f);

  for i := 1 to 12 do begin
    Readln(f, j);
    fRekurzioSzintjei[i] := TMozaikNevek(j);
  end;

  for iTipus := Hosszu to Esbetu do begin
    lsorMind := '';
    for i := 1 to 6 do begin
      Readln(f, lSor);
      lSorMind := lSorMind + lSor;
    end;
    fMozaikok[iTipus].DeSerialize(lSorMind);
    fMozaikok[iTipus].fMozaikTipus := iTipus;   //visszafelé beírom a redundáns cuccba a ciklusváltozót, biztos ami biztos

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
 // fJatekter.DeSerialize(lSorMind);

  Readln(f, lSor);
  fJatekter.fKirakottMennyiseg := StrToInt(lSor);

  Readln(f, lSor);
  fToltottAktSzint := StrToInt(lSor);

  CloseFile(f);
end;

procedure TfrmMain.Rekurziv;
var jTipus: TMozaikNevek;
    lElsoUresI, lElsoUresJ: Byte;
begin
  //if fJatekter.fKirakottMennyiseg = 12 then ShowMessage('12');
  for jTipus := Hosszu to Esbetu do begin
    if (not fMozaikok[jTipus].fKiVanRakva) then begin   // ezt a változót írni kirak, leszed -ben! // további gond, h leszedés után ez így az épp leszedettet akarja majd visszarakni? -> a ciklus ezt kivédi, akkor az ott vált... de egy hívással kiljebb már igen
      fJatekter.KeresElsoUres;
      lElsoUresI := fJatekter.fElsoUresI;
      lElsoUresJ := fJatekter.fElsoUresJ;
      if fJatekter.KirakhatoIde(fMozaikok[jTipus], lElsoUresI, lElsoUresJ) then begin // gáz: ha kész a tábla, akkor ez (7, 11)-re visz, de végülis ebbe az ifbe akkor már nem is jön be
        SetTempo;
        fJatekter.Kirak(fMozaikok[jTipus], lElsoUresI, lElsoUresJ);
        SetTempo;
        if fJatekter.LyukLenneEgy or fJatekter.LyukLenneKetto or fJatekter.LyukLenneHarom or fJatekter.LyukLenneNegy then begin
          SetTempo;
          fJatekter.Levesz(fMozaikok[jTipus], lElsoUresI, lElsoUresJ);
          SetTempo;
        end else begin
          Rekurziv;
          SetTempo;
          fJatekter.Levesz(fMozaikok[jTipus], lElsoUresI, lElsoUresJ);
          SetTempo;
        end;

          {if fJatekter.KeszVan then begin
            inc(fHanyadikMegoldas);
            Writeln(f, IntToStr(fHanyadikMegoldas) + '. megoldás:');
            Writeln(f, fJatekter.Serialize + #13#10);
          end else begin
            Rekurziv;
          end;}


          {fMozaikok[jTipus].fValtozatIndex := 0;}

      end; // if
    end;
  end;
end;

end.
