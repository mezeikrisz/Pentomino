unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids;

type
  TNegyzet = Array[1..5,1..5] of Char;

  TTeglalap = Array[1..11,1..7] of Char;

  TMozaikNevek = (Ures, Hosszu, Elbetu, Hazteto, Sonka, Kereszt, Puska, Lapat, Csunya, Tebetu, Lepcso, Ubetu, Esbetu);

  TMozaik = class(TObject)
  private
    fNegyzet: TNegyzet;
    fMozaikTipus: TMozaikNevek;
    fValtozatIndex: Byte;
    fIttVoltUtoljaraX, fIttVoltUtoljaraY: Byte;
    fKiVanRakva: Boolean;
    constructor Create(pMozaik: TMozaikNevek);
    procedure Forgat;    //fNegyzetet megforgatja clockwise
    procedure Tukroz;    //fNegyzetet t�kr�zi f�gg�leges tengelyre
    procedure Normalizal;  //fNegyzet 1-eseit a balfels� sarokba tolja
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    function Valtoztat: Boolean; //el��ll�tja a k�v v�ltozatot fNegyzet-be, ha lehet m�g
  end;

  TJatekTer = class(TObject)
  private
    fTeglalap: TTeglalap;
    fKirakottMennyiseg: Byte;
    constructor Create;
    function KirakhatoIde(pMozaik: TMozaik; pX, pY: Byte): Boolean;
    procedure Kirak(pMozaik: TMozaik; pX, pY: Byte);
    function LyukLenne: Boolean;
  public
    function Serialize: String;
    procedure DeSerialize(pSor: String);
    function KirakKovetkezoHelyre(pMozaik: TMozaik): Boolean;
    procedure KovetkezoHely(var pX, pY: Byte);
    procedure Levesz(pMozaik: TMozaik);
    function KeszVan: Boolean;
    procedure Leallit;
  end;

  TfrmMain = class(TForm)
    btnKeres: TButton;
    dwgdLenyeg: TDrawGrid;
    btnLoad: TButton;
    btnSave: TButton;
    rgrpTempo: TRadioGroup;
    procedure btnKeresClick(Sender: TObject);
    procedure dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
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
  '',          //�res n�gyzetet nincs �rtelme forgatni/t�kr�zni
  'F',         //a Hosszut egyszer lehet Forgatni, t�bb v�ltozat nincs..
  'FFFTFFF',   //az Elbetut k�rbe lehet Forgatni, akkor T�kr�zni, majd megint Forgatni..
  'FFF',       //stb
  'FFFTFFF',
  '',
  'FFFTFFF',
  'FFFTFFF',
  'FFFTFFF',
  'FFF',
  'FFF',
  'FFF',
  'FTF'
  );

  oMozaikKarakterek: Array[Ures..Esbetu] of Char =
  (
  '@',
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

  oMozaikSzinek: Array[0..13] of TColor =    //ez most nem enummal c�mezve, mert a sz�ls� feket�ket is festeni akarom..
  (
  clWhite,
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
  (('@','@','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('A','@','@','@','@'),
   ('A','@','@','@','@'),
   ('A','@','@','@','@'),
   ('A','@','@','@','@'),
   ('A','@','@','@','@')),
  (('B','@','@','@','@'),
   ('B','@','@','@','@'),
   ('B','@','@','@','@'),
   ('B','B','@','@','@'),
   ('@','@','@','@','@')),
  (('C','@','@','@','@'),
   ('C','@','@','@','@'),
   ('C','C','C','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('D','@','@','@','@'),
   ('D','D','@','@','@'),
   ('D','D','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('@','E','@','@','@'),
   ('E','E','E','@','@'),
   ('@','E','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('F','F','F','F','@'),
   ('@','F','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('G','G','G','@','@'),
   ('@','@','G','G','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('H','H','@','@','@'),
   ('@','H','H','@','@'),
   ('@','H','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('I','I','I','@','@'),
   ('@','I','@','@','@'),
   ('@','I','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('J','J','@','@','@'),
   ('@','J','J','@','@'),
   ('@','@','J','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('K','K','K','@','@'),
   ('K','@','K','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@')),
  (('L','L','@','@','@'),
   ('@','L','@','@','@'),
   ('@','L','L','@','@'),
   ('@','@','@','@','@'),
   ('@','@','@','@','@'))
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
  fIttVoltUtoljaraX := 0;
  fIttVoltUtoljaraY := 0;
  fKiVanRakva := false;
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
var i, j, i2, j2, lMinX, lMinY: Byte;
    lTempNegyzet: TNegyzet;
begin
  if (fNegyzet[1,1] <> '@') then Exit; //mert nincs mit normaliz�lni

  //minimum keres�s mindk�t koordin�t�ra, ahol ertek = 1
  lMinX := 5;
  for i := 1 to 5 do begin
    j := 0;
    repeat
      inc(j);
    until (fNegyzet[i,j] <> '@') or (j = 5);
    if j < lMinX then lMinX := j;
  end;
  lMinY := 5;
  for j := 1 to 5 do begin
    i := 0;
    repeat
      inc(i);
    until (fNegyzet[i,j] <> '@') or (i = 5);
    if i < lMinY then lMinY := i;
  end;

  if (lMinX = 1) and (lMinY = 1) then Exit; //mert nincs mit normaliz�lni

  lTempNegyzet := oMozaikTomb[Ures];

  //majd a k�t sz�mmal jel�lt pontig felm�solni mindent
  i2 := 1;
  for i := lMinY to 5 do begin
    j2 := 1;
    for j := lMinX to 5 do begin
      lTempNegyzet[i2,j2] := fNegyzet[i,j];
      inc(j2);
    end;
    inc(i2);
  end;

  fNegyzet := lTempNegyzet;
end;

function TMozaik.Serialize: String;
var lKirakni: String;
    i, j: Byte;
begin
  lKirakni := '';
  for j := 1 to 5 do begin
    for i := 1 to 5 do begin
      lKirakni := lKirakni + fNegyzet[i,j];
    end;
    lKirakni := lKirakni + #13#10;
  end;
  Result := lKirakni;
end;

procedure TMozaik.DeSerialize(pSor: String);
var i, j, k: Byte;
begin
  k := 1;
  StringReplace(pSor, #13#10, '', [rfReplaceAll]);
  for j := 1 to 5 do begin
    for i := 1 to 5 do begin
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
  if (Length(oMozaikValtozatok[fMozaikTipus]) = 0) or (Length(oMozaikValtozatok[fMozaikTipus]) = fValtozatIndex) then begin
    Result := false;
    Exit;
  end;
  inc(fValtozatIndex);
  case oMozaikValtozatok[fMozaikTipus][fValtozatIndex] of
    'F': Forgat;
    'T': Tukroz;
  end;
  Normalizal;
  Result := true;
end;

{-----------}
{ TJatekTer }
{-----------}

constructor TJatekTer.Create;
var i, j: Byte;
begin
  for i := 1 to 11 do begin
    for j := 1 to 7 do begin
      fTeglalap[i,j] := '@';
    end;
  end;
  for i := 1 to 11 do begin
    fTeglalap[i,7] := 'M';
  end;
  for j := 1 to 7 do begin
    fTeglalap[11,j] := 'M';
  end;
  fKirakottMennyiseg := 0;
end;

function TJatekTer.KirakKovetkezoHelyre(pMozaik: TMozaik): Boolean;
var i, j, lCsusztat: Byte;
begin
  //v�gigtolni a mozaikot az �sszes lehets�ges helyen, �rz�kelni a v�g�t
  for i := pMozaik.fIttVoltUtoljaraX to 10 do begin
    for j := pMozaik.fIttVoltUtoljaraY + 1 to 6 do begin //EBBEN A PLUSZ EGYBEN (+1) NEM VAGYOK BIZTOS... DE VALAHOGY ARR�BB K�NE M�SZATNI. MOST �GY CSIN�LOM.
      if KirakhatoIde(pMozaik,i,j) then begin
        Kirak(pMozaik,i,j);
        if LyukLenne then begin                //extra gyors�t�s: egyes z�rv�nyokn�l nem ink�bb leszedi a most felrakottat
          Levesz(pMozaik);
        end else begin
          pMozaik.fIttVoltUtoljaraX := i;
          pMozaik.fIttVoltUtoljaraY := j;
          Result := true;
          Exit;
        end;
      end;
    end;
  end;
  pMozaik.fIttVoltUtoljaraX := 0;
  pMozaik.fIttVoltUtoljaraY := 0;
  Result := false; //ha id�ig eljutott, akkor nem siker�lt kirakni
end;

procedure TJatekTer.KovetkezoHely(var pX, pY: Byte);
var i, j: Byte;
begin
  pX := 0;
  pY := 0;
  for j := 1 to 6 do begin
    for i := 1 to 10 do begin
      if fTeglalap[i,j] = '@' then begin
        pX := i;
        pY := j;
        Exit;
      end;
    end;
  end;
end;

function TJatekTer.KirakhatoIde(pMozaik: TMozaik; pX, pY: Byte): Boolean;
var i, j: Byte;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if ((pMozaik.fNegyzet[i,j] <> '@') and (fTeglalap[pX+i-1,pY+j-1] <> '@')) //egybel�g�s lenne
         or
         ((pMozaik.fNegyzet[i,j] <> '@') and (fTeglalap[pX+i-1,pY+j-1] = 'M')) then begin //kil�g�s lenne
        Result := false;
        Exit;
      end;
    end;
  end;
  Result := true;
end;

procedure TJatekTer.Kirak(pMozaik: TMozaik; pX, pY: Byte);
var i, j: Byte;
begin
  for i := 1 to 5 do begin
    for j := 1 to 5 do begin
      if pMozaik.fNegyzet[i,j] <> '@' then begin
        fTeglalap[pX+i-1,pY+j-1] := pMozaik.fNegyzet[i,j];
      end;
    end;
  end;
  pMozaik.fKiVanRakva := true;
  inc(fKirakottMennyiseg);
end;

procedure TJatekTer.Levesz(pMozaik: TMozaik);
var i, j: Byte;
begin
  for i := 1 to 10 do begin
    for j := 1 to 6 do begin
      if (fTeglalap[i,j] =  oMozaikKarakterek[pMozaik.fMozaikTipus]) then fTeglalap[i,j] := '@';
    end;
  end;
  pMozaik.fKiVanRakva := false;
  dec(fKirakottMennyiseg);
end;

function TJatekTer.KeszVan: Boolean;
begin
  Result := (fKirakottMennyiseg = 12);
end;

function TJatekTer.Serialize: String;
var lKirakni: String;
    i, j: Byte;
begin
  lKirakni := '';
  for j := 1 to 7 do begin   //a ki�rat�s soronk�nt kell t�rt�njen, ez�rt vannak ford�tott sorrendben a ciklusok
    for i := 1 to 11 do begin
      lKirakni := lKirakni + fTeglalap[i,j];
    end;
    lKirakni := lKirakni + #13#10;
  end;
  Result := lKirakni;
end;

procedure TJatekTer.DeSerialize(pSor: String);
var i, j, k: Byte;
begin
  k := 1;
  StringReplace(pSor, #13#10, '' ,[rfReplaceAll]);
  for j := 1 to 7 do begin
    for i := 1 to 11 do begin
      fTeglalap[i,j] := pSor[k];
      inc(k);
    end;
  end;
end;

function TJatekTer.LyukLenne: Boolean; 
var i, j: Byte;
begin
  for i := 1 to 10 do begin
    for j := 1 to 6 do begin
      if (fTeglalap[i,j] = '@')
       and
         (fTeglalap[i+1,j] <> '@')
       and
         (fTeglalap[i-1,j] <> '@')
       and
         (fTeglalap[i,j+1] <> '@')
       and
         (fTeglalap[i,j-1] <> '@') then begin //egyes z�rv�ny
        Result := true;
        Exit;
      end else if (fTeglalap[i,j] = '@')
                and
                  (fTeglalap[i,j+1] = '@')
                and
                  (fTeglalap[i+1,j] <> '@')
                and
                  (fTeglalap[i+1,j+1] <> '@')
                and
                  (fTeglalap[i,j+2] <> '@')
                and
                  (fTeglalap[i-1,j+1] <> '@')
                and
                  (fTeglalap[i-1,j] <> '@')
                and
                  (fTeglalap[i,j-1] <> '@')
                                          then begin //kettes z�rv�ny f�gg�legesen
        Result := true;
        Exit;
      end else if (fTeglalap[i,j] = '@')
                and
                  (fTeglalap[i+1,j] = '@')
                and
                  (fTeglalap[i,j-1] <> '@')
                and
                  (fTeglalap[i+1,j-1] <> '@')
                and
                  (fTeglalap[i+2,j] <> '@')
                and
                  (fTeglalap[i+1,j+1] <> '@')
                and
                  (fTeglalap[i,j+1] <> '@')
                and
                  (fTeglalap[i-1,j] <> '@')
                                          then begin //kettes z�rv�ny v�zszintesen
        Result := true;
        Exit;
      end else begin

        Result := false;
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

{----------}
{ TfrmMain }
{----------}

procedure TfrmMain.btnKeresClick(Sender: TObject);
begin
  btnKeres.Enabled := false;
  btnLoad.Enabled := false;
  btnSave.Enabled := true;

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

procedure TfrmMain.Rekurziv;
var jTipus, lKezdoMozaik: TMozaikNevek;
begin
  // kirakni legels�nek els� verzi�j�t 1,1-re
  // megkeresni a k�v helyet fels� sorban, pl ez a 6,1
  // pr�b�lni fedni a 6,1-et a k�v idommal
  // ha nem megy forgatni azt
  // ha nem megy, k�vetkez� idom
  // .. forgatni
  // ....
  //ha semelyik nem megy, visszal�pni �s leszedni az el�z�t

  for jTipus := Hosszu to Esbetu do begin
    if (not fMozaikok[jTipus].fKiVanRakva) then begin
      repeat

        KovetkezoHely

        while (fJatekter.KirakKovetkezoHelyre(fMozaikok[jTipus])) do begin
          inc(fAktualisSzint);

          fRekurzioSzintjei[fAktualisSzint] := fMozaikok[jTipus].fMozaikTipus;

          if oToltveVolt and (fAktualisSzint = fToltottAktSzint) then oToltveVolt := false;

          if oMenteniKell then begin
            Save;
            fJatekter.Leallit;
          end;

          SetTempo;

          if fJatekter.KeszVan then begin
            inc(fHanyadikMegoldas);
            Writeln(f, IntToStr(fHanyadikMegoldas) + '. megold�s:');
            Writeln(f, fJatekter.Serialize + #13#10);
          end else begin
            Rekurziv;
          end;

          fJatekter.Levesz(fMozaikok[jTipus]);

          dec(fAktualisSzint);

          SetTempo;
        end;
      until not (fMozaikok[jTipus].Valtoztat);
      fMozaikok[jTipus].fValtozatIndex := 0;
    end;
  end;
end;

procedure TfrmMain.dwgdLenyegDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Assigned(fJatekter) then begin
    dwgdLenyeg.Canvas.Brush.Color := oMozaikSzinek[Ord(fJatekter.fTeglalap[ACol+1,ARow+1]) - Ord('@')];
    //a cell�ban l�v� karakter �rt�k�b�l kivonjuk az @ ascii k�dj�t, ezzel az integerrel m�r c�mezhet� a Szinek t�mb
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

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  oMenteniKell := true;

  btnKeres.Enabled := false;
  btnLoad.Enabled := true;
  btnSave.Enabled := false;
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
  oToltveVolt := true;

  Load;
  dwgdLenyeg.Repaint;
  btnKeres.Enabled := false;
  btnLoad.Enabled := false;
  btnSave.Enabled := true;
  Rekurziv;
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
    Writeln(f, IntToStr(fMozaikok[iTipus].fIttVoltUtoljaraX));
    Writeln(f, IntToStr(fMozaikok[iTipus].fIttVoltUtoljaraY));
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
    fMozaikok[iTipus].fIttVoltUtoljaraX := StrToInt(lSor);

    Readln(f, lSor);
    fMozaikok[iTipus].fIttVoltUtoljaraY := StrToInt(lSor);

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
  btnLoad.Enabled := lMentveVolt;
  btnSave.Enabled := false;
end;

end.
