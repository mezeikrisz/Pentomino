unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids;

type
  TNegyzet = Array[1..5,1..5] of Char; //sorindex majd oszlopindex, teh�t ford�tva, mint pixelc�mz�sn�l

  TTeglalap = Array[1..7,1..11] of Char; //sorindex majd oszlopindex

  TMozaikNevek = (Ures, Hosszu, Elbetu, Hazteto, Sonka, Kereszt, Puska, Lapat, Csunya, Tebetu, Lepcso, Ubetu, Esbetu);

  TMozaik = class(TObject)
  public //private //hogy r�l�sson a test, egyel�re public minden
    fNegyzet: TNegyzet;
    fMozaikTipus: TMozaikNevek;
    fValtozatIndex: Byte;
    fIttVoltUtoljaraI, fIttVoltUtoljaraJ: Byte;
    fOffsetJ: Byte;
    fKiVanRakva: Boolean;
    constructor Create(pMozaik: TMozaikNevek);
    procedure Forgat;      //fNegyzetet megforgatja clockwise [3,3]-as k�z�pponttal
    procedure Tukroz;      //fNegyzetet t�kr�zi f�gg�leges tengelyre
    procedure Normalizal;  //fNegyzet 1-eseit a balfels� sarokba tolja
    function Hasonlit(pNegyzet: TNegyzet): Boolean;   //fNegyzetet m�sik TNegyzettel hasonl�t
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    function Valtoztat: Boolean; //el��ll�tja a k�v v�ltozatot fNegyzet-be, ha lehet m�g
  end;

  TJatekTer = class(TObject)
  public //private //hogy r�l�sson a test, egyel�re public minden
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

  oMozaikSzinek: Array[0..12] of TColor =    //ez most nem enummal c�mezve, mert a sz�ls� feket�ket is festeni akarom, �s mert karakter k�dokkal k�ne c�mezni, hogy gyorsabb legyen
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
  if (fNegyzet[1,1] <> '.') then Exit; //mert nincs mit normaliz�lni

  //minimum keres�s mindk�t koordin�t�ra, ahol ertek = 1
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

  if (lMinI = 1) and (lMinJ = 1) then begin //mert nincs mit normaliz�lni
  end else begin
    lTempNegyzet := oMozaikTomb[Ures];

    //majd a k�t sz�mmal jel�lt pontig felm�solni mindent
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
  
  //a normaliz�lt n�gyzet els� sor�ban megkeresni az els� �rt�kes jegyet, ez legyen a J offset. Oszlopban elvileg nem kell vele t�r�dni.
  j3 := 0;
  repeat
    inc(j3);
  until (fNegyzet[1,j3] <> '.') or (j3 = 5);
  fOffsetJ := j3 - 1;             //offset 0-t�l indul, ha a sarokban kezd�dik az �rt�kes jegy
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
    Result := false;                                                       //false-szal sz�ll ki, ha m�r nincs t�bb v�ltozat
    Exit;
  end;
  inc(fValtozatIndex);
  case oMozaikValtozatok[fMozaikTipus][fValtozatIndex] of
    'S': ;
    'F': Forgat;
    'T': Tukroz;
  end;
  Normalizal;
  Result := true;                                                          //true-val, ha csin�lt valamit
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
      if ((pMozaik.fNegyzet[i,j] <> '.') and (fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] <> '.')) //egybel�g�s lenne
         or
         ((pMozaik.fNegyzet[i,j] <> '.') and (fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] = 'M')) then begin //kil�g�s lenne
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
  pMozaik.fKiVanRakva := true;         //�llapotjelz� kell ez?
  inc(fKirakottMennyiseg);             //�llapotjelz� kell ez?

end;

procedure TJatekTer.Levesz(pMozaik: TMozaik; pI, pJ: Byte); //ez alapb�l poz�ci� n�lk�li fejl�ces volt, emiatt a ciklusai 6-ig/10-ig mentek, c�mz�s is m�s volt
var i, j: Byte;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] = oMozaikKarakterek[pMozaik.fMozaikTipus] then begin
        fTeglalap[pI+i-1,pJ-pMozaik.fOffsetJ+j-1] := '.';
      end;
    end;
  end;
  pMozaik.fKiVanRakva := false;        //�llapotjelz� kell ez?
  dec(fKirakottMennyiseg);             //�llapotjelz� kell ez?

end;

function TJatekTer.KeszVan: Boolean;
begin
  Result := (fKirakottMennyiseg = 12);
end;

function TJatekTer.Serialize: String; //TODO ez a Serialize az�rt el�gg� olyan, mint a Mozaik�... k�z�s �st�l �r�k�lni 1 parammal...
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

procedure TJatekTer.DeSerialize(pSor: String); //TODO DeSerialize-t is kiemelni k�z�s �sbe...
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
  fElsoUresI := 7;                                       //ezen �rt�kek jelzik, ha nincs m�r �res poz�ci�, azaz m�r teli van a j�t�kt�r
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
      then begin                                //kettes z�rv�ny v�zszintesen
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
      then begin                                //h�rmas z�rv�ny v�zszintesen (#1)
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
      then begin                                //h�rmas z�rv�ny f�gg�legesen  (#2)
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
      then begin                                //n�gyes z�rv�ny v�zszintesen (#1)
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
      then begin                                //n�gyes z�rv�ny f�gg�legesen  (#2)
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

  //load-dal kezd�s esetben most nincs nyitva a results...
  //olyankor is nyitni, de esetleg a m�ret�t�l f�gg�en hozz��r�sra/�jra�r�sra
  //fHanyadikMegoldast file-b�l t�lteni, teh�t el�tte el is menteni...

  Rekurziv;

  CloseFile(f);
  //save-n�l results-ot is z�rni!!
end;

procedure TfrmMain.dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Assigned(fJatekter) then begin
    if fJatekter.fTeglalap[ARow+1,ACol+1] <> '.' then begin
      dwgdLenyeg.Canvas.Brush.Color := oMozaikSzinek[Ord(fJatekter.fTeglalap[ARow+1,ACol+1]) - Ord('A')];
      //a cell�ban l�v� karakter ascii k�dj�b�l kivonjuk az A ascii k�dj�t, ezzel az integerrel m�r c�mezhet� a sz�nes t�mb
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
    //fMozaikTipust nem �rom ki, mert redund�ns inf� n�mileg �s nincs is ..ToStr-je :)
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
    if (not fMozaikok[jTipus].fKiVanRakva) then begin   // ezt a v�ltoz�t �rni kirak, leszed -ben! // tov�bbi gond, h leszed�s ut�n ez �gy az �pp leszedettet akarja majd visszarakni? -> a ciklus ezt kiv�di, akkor az ott v�lt... de egy h�v�ssal kiljebb m�r igen
      fJatekter.KeresElsoUres;
      lElsoUresI := fJatekter.fElsoUresI;
      lElsoUresJ := fJatekter.fElsoUresJ;
      if fJatekter.KirakhatoIde(fMozaikok[jTipus], lElsoUresI, lElsoUresJ) then begin // g�z: ha k�sz a t�bla, akkor ez (7, 11)-re visz, de v�g�lis ebbe az ifbe akkor m�r nem is j�n be
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
            Writeln(f, IntToStr(fHanyadikMegoldas) + '. megold�s:');
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
