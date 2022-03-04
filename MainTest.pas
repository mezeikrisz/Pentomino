unit MainTest;

interface

uses
  TestFrameWork, Main, Sysutils;

implementation

type
  TMainTest = class(TTestCase)
  private
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure testMozaikHasonlit;
    procedure testMozaikSerialize;
    procedure testMozaikDeSerialize;
    procedure testMozaikForgat;
    procedure testMozaikTukroz;
    procedure testMozaikNormalizal;
    procedure testMozaikValtoztat;
    procedure testJatekterSerialize;
    procedure testJatekterDeSerialize;
    procedure testJatekterLyukLenneEgy;
    procedure testJatekterLyukLenneKetto;
    procedure testJatekterLyukLenneHarom;
    procedure testJatekterLyukLenneNegy;
    procedure testJatekterKeresElsoUres;
    procedure testJatekterKirakhatoIde;
    procedure testJatekterKirak;
    procedure testJatekterLevesz;
  end;

{ TMainTest }

procedure TMainTest.SetUp;
begin
  inherited;
end;

procedure TMainTest.TearDown;
begin
  inherited;
end;

procedure TMainTest.testMozaikHasonlit;
var t: TNegyzet;
    mMozaikUres, mMozaikHosszu: TMozaik;
begin
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  //kódból nem tudok ettõl szebb tömb értékadást. deklarációban megy (oMozaikTomb), kódból nem
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikUres.Hasonlit(t), 'Mozaik Hasonlit 1');

  t[1, 1] := 'A';   t[1, 2] := 'A';   t[1, 3] := 'A';   t[1, 4] := 'A';   t[1, 5] := 'A';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHosszu.Hasonlit(t), 'Mozaik Hasonlit 2');

  mMozaikUres.Free;
  mMozaikHosszu.Free;
end;

procedure TMainTest.testMozaikSerialize;
var mMozaikUres, mMozaikHosszu: TMozaik;
begin
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  Check(mMozaikUres.Serialize = '.....'#13#10 +
                                '.....'#13#10 +
                                '.....'#13#10 +
                                '.....'#13#10 +
                                '.....'#13#10, 'Mozaik Serialize 1');

  Check(mMozaikHosszu.Serialize = 'AAAAA'#13#10 +
                                  '.....'#13#10 +
                                  '.....'#13#10 +
                                  '.....'#13#10 +
                                  '.....'#13#10, 'Mozaik Serialize 2');

  mMozaikUres.Free;
  mMozaikHosszu.Free;
end;

procedure TMainTest.testMozaikDeSerialize;
var s: String;
    mMozaikMindegy: TMozaik;
begin
  mMozaikMindegy := TMozaik.Create(Ures);

  s := '*....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  Check(mMozaikMindegy.Serialize = s, 'Mozaik DeSerialize+Serialize 1');

  s := '.***.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  mMozaikMindegy.DeSerialize(s);
  Check(mMozaikMindegy.Serialize = s, 'Mozaik DeSerialize+Serialize 2');

  mMozaikMindegy.Free;

  //itt van azért egy tervezési baki: a serialize-deserialize nem is a TMozaikhoz kéne, hanem a benne szereplõ TNegyzethez, ugyanis ezek a függvények nem a teljes állapotot pakolják ide-oda, pl biztosan nem megy át a mozaiktipus, valtozatindex
  //ez amúgy csak a serialize/deserialize résznél gond. Egyben kellenne futnia az összes adattagnak, elmenteni érdemben nem lehet így.
  //de amúgy mintha a load-ban készültem volna erre...
  //most így hagyom.

  //a két tengelyrõl mit tudunk? ser+deser rutinokban "i majd j" sorrend mind a ciklusokban, mind a tömbindexben
  //ha stringesen kiírjuk, akkor úgy áll, mint a kezdeti tömbkonstansokban (oMozaikTomb)
  //ha kódból adunk a tömbnek értéket, akkor "sorindex majd oszlopindex" a sorrend (testMozaikHasonlit)
  //minden szuper eddig. Összes többit is átalakítani így!
  //TTeglalapnál is "sorindex majd oszlopindex", "7 majd 11", "i majd j"
end;

procedure TMainTest.testMozaikForgat;
var t: TNegyzet;
    s: String;
    mMozaikHazteto, mMozaikMindegy: TMozaik;
begin
  mMozaikHazteto := TMozaik.Create(Hazteto);
  mMozaikMindegy := TMozaik.Create(Ures);

  mMozaikHazteto.Forgat;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := 'C';   t[1, 4] := 'C';   t[1, 5] := 'C';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := 'C';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := 'C';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHazteto.Hasonlit(t), 'Mozaik Forgat 1, Hasonlit-tal');

  s := '.....'#13#10 +
       '.*..*'#13#10 +
       '.*..*'#13#10 +
       '.*..*'#13#10 +
       '.....'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Forgat;
  s := '.....'#13#10 +
       '.***.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.***.'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Forgat 2, DeSer+Ser');

  mMozaikHazteto.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikTukroz;
var t: TNegyzet;
    s: String;
    mMozaikHazteto, mMozaikMindegy: TMozaik;
begin
  mMozaikHazteto := TMozaik.Create(Hazteto);
  mMozaikMindegy := TMozaik.Create(Ures);

  mMozaikHazteto.Tukroz;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := 'C';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := 'C';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := 'C';   t[3, 4] := 'C';   t[3, 5] := 'C';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHazteto.Hasonlit(t), 'Mozaik Tukroz 1, Hasonlit-tal');

  s := '*....'#13#10 +
       '.*...'#13#10 +
       '..*..'#13#10 +
       '...*.'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Forgat;
  s := '....*'#13#10 +
       '...*.'#13#10 +
       '..*..'#13#10 +
       '.*...'#13#10 +
       '*....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Tukroz 2, DeSer+Ser');

  mMozaikHazteto.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikNormalizal;
var t: TNegyzet;
    s: String;
    mMozaikEsbetu, mMozaikMindegy: TMozaik;
begin
  mMozaikEsbetu := TMozaik.Create(Esbetu);
  mMozaikMindegy := TMozaik.Create(Ures);

  mMozaikEsbetu.Forgat;
  mMozaikEsbetu.Forgat;
  mMozaikEsbetu.Normalizal;
  t[1, 1] := 'L';   t[1, 2] := 'L';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := 'L';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := 'L';   t[3, 3] := 'L';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikEsbetu.Hasonlit(t), 'Mozaik Normalizal 1, Hasonlit-tal');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '..*..'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  s := '*....'#13#10 +
       '..*..'#13#10 +
       '.**..'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalizal 2, DeSer+Ser');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  s := '.*...'#13#10 +
       '.*...'#13#10 +
       '**...'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalizal 3, DeSer+Ser');

  s := '..*..'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  s := '*....'#13#10 +
       '.....'#13#10 +
       '..*..'#13#10 +
       '..*..'#13#10 +
       '.**..'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalizal 4, DeSer+Ser');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '..***'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  Check(mMozaikMindegy.fElsoTeliJ = 2, 'Mozaik Normalizal 5, offset');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '*****'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  Check(mMozaikMindegy.fElsoTeliJ = 4, 'Mozaik Normalizal 6, offset');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalizal;
  Check(mMozaikMindegy.fElsoTeliJ = 0, 'Mozaik Normalizal 7, offset');


  mMozaikEsbetu.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikValtoztat;
var t: TNegyzet;
    s: String;
    mMozaikUres, mMozaikElbetu: TMozaik;
    b: Boolean;
begin
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikElbetu := TMozaik.Create(Elbetu);

  b := mMozaikUres.Valtoztat;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(b = true, 'Ures Valtoztat, kimenõ érték true');
  Check(mMozaikUres.Hasonlit(t), 'Ures Valtoztat, eredmény tömb Hasonlit-tal');
  b := mMozaikUres.Valtoztat;
  Check(b = false, 'Ures Valtoztat, kimenõ érték false');
  Check(mMozaikUres.Hasonlit(t), 'Ures Valtoztat megint, eredmény tömb Hasonlit-tal');

  b := mMozaikElbetu.Valtoztat;
  s := 'BB...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 1, kimenõ érték true');
  Check(mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 1, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := '...B.'#13#10 +
       'BBBB.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 2, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 2, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'BB...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 3, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 3, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BBBB.'#13#10 +
       'B....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 4, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 4, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BBBB.'#13#10 +
       '...B.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 5, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 5, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := '.B...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       'BB...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 6, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 6, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'B....'#13#10 +
       'BBBB.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 7, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 7, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BB...'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Valtoztat 8, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 8, Ser');
  b := mMozaikElbetu.Valtoztat;
  s := 'BB...'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       '.....'#13#10;
  Check(b = false, 'Elbetu Valtoztat 9, kimenõ érték false');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Valtoztat 9, Ser');

  mMozaikUres.Free;
end;

procedure TMainTest.testJatekterSerialize;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;
  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  Check(j.Serialize = s, 'Jatekter Serialize');
  j.Free;
end;

procedure TMainTest.testJatekterDeSerialize;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;
  s := '*.........*'#13#10 +
       '..........M'#13#10 +
       '....oo....M'#13#10 +
       '....oo....M'#13#10 +
       '....oo....M'#13#10 +
       '..........M'#13#10 +
       '*MMMMMMMMM*'#13#10;
  j.DeSerialize(s);
  Check(j.Serialize = s, 'Mozaik DeSerialize+Serialize 1');
  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneEgy;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........M'#13#10 +
       'AB........M'#13#10 +
       'AB........M'#13#10 +
       'ABB.......M'#13#10 +
       'A.........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = false, 'LyukLenneEgy, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = false, 'LyukLenneEgy, teli táblánál nincs lyuk, false legyen');

  s := '.DD.......M'#13#10 +
       'DDD.......M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 1');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAA.M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 2');

  s := '.A........M'#13#10 +
       'A.........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 3');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneEgy = true, 'LyukLenneEgy, true legyen 4');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneKetto;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........M'#13#10 +
       'AB........M'#13#10 +
       'AB........M'#13#10 +
       'ABB.......M'#13#10 +
       'A.........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = false, 'LyukLenneKetto, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = false, 'LyukLenneKetto, teli táblánál nincs lyuk, false legyen');

  s := 'AAAAA.....M'#13#10 +
       '..F.......M'#13#10 +
       'FFFF......M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 1');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAA.M'#13#10 +
       'AAAAAAAAA.M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 2');

  s := '.A........M'#13#10 +
       '.A........M'#13#10 +
       'A.........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 3');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 4');

  s := '..........M'#13#10 +
       '...AA.....M'#13#10 +
       '..A..A....M'#13#10 +
       '...AA.....M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneKetto = true, 'LyukLenneKetto, true legyen 5');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneHarom;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........M'#13#10 +
       'AB........M'#13#10 +
       'AB........M'#13#10 +
       'ABB.......M'#13#10 +
       'A.........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, teli táblánál nincs lyuk, false legyen');

  s := '..........M'#13#10 +
       '...AAA....M'#13#10 +
       '..A...A...M'#13#10 +
       '...AAA....M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 1');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 2');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A..A....M'#13#10 +
       '...AA.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 3');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '.A..A.....M'#13#10 +
       '..AA......M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 4');

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '.....AA...M'#13#10 +
       '....A..A..M'#13#10 +
       '.....A.A..M'#13#10 +
       '......A...M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 5');

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '.....AA...M'#13#10 +
       '....A..A..M'#13#10 +
       '....A.A...M'#13#10 +
       '.....A....M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = true, 'LyukLenneHarom, true legyen 6');

  s := '.AAAAAAAA.M'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       '.AAAAAAAA.M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, határmenti kínzás 1');

  s := '.AAA..AAA.M'#13#10 +
       'A.AAAAAAA.M'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'A.AAAAAAA.M'#13#10 +
       '.AAA..AAA.M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneHarom = false, 'LyukLenneHarom, határmenti kínzás 2');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneNegy;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := 'AB........M'#13#10 +
       'AB........M'#13#10 +
       'AB........M'#13#10 +
       'ABB.......M'#13#10 +
       'A.........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, teli táblánál nincs lyuk, false legyen');

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..AAAA....M'#13#10 +
       '.A....A...M'#13#10 +
       '..AAAA....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 1');

  s := '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 2');

  s := '..........M'#13#10 +
       '..A.......M'#13#10 +
       '.A.AA.....M'#13#10 +
       '.A...A....M'#13#10 +
       '..AAA.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 3');

  s := '..........M'#13#10 +
       '....A.....M'#13#10 +
       '..AA.A....M'#13#10 +
       '.A...A....M'#13#10 +
       '..AAA.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 4');

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..AAA.....M'#13#10 +
       '.A...A....M'#13#10 +
       '..AA.A....M'#13#10 +
       '....A.....M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 5');

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..AAA.....M'#13#10 +
       '.A...A....M'#13#10 +
       '.A.AA.....M'#13#10 +
       '..A.......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 6');

  s := '....A.....M'#13#10 +
       '...A.A....M'#13#10 +
       '...A.A....M'#13#10 +
       '...A..A...M'#13#10 +
       '....AA....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 7');

  s := '....A.....M'#13#10 +
       '...A.A....M'#13#10 +
       '...A.A....M'#13#10 +
       '..A..A....M'#13#10 +
       '...AA.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 8');

  s := '...AA.....M'#13#10 +
       '..A..A....M'#13#10 +
       '...A.A....M'#13#10 +
       '...A.A....M'#13#10 +
       '....A.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 9');

  s := '....AA....M'#13#10 +
       '...A..A...M'#13#10 +
       '...A.A....M'#13#10 +
       '...A.A....M'#13#10 +
       '....A.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 10');

  s := '..........M'#13#10 +
       '..A.......M'#13#10 +
       '.A.A......M'#13#10 +
       '.A..A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 11');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '.A..A.....M'#13#10 +
       '.A.A......M'#13#10 +
       '..A.......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 12');

  s := '..........M'#13#10 +
       '...AA.....M'#13#10 +
       '..A..A....M'#13#10 +
       '...A..A...M'#13#10 +
       '....AA....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 13');

  s := '..........M'#13#10 +
       '...AA.....M'#13#10 +
       '..A..A....M'#13#10 +
       '.A..A.....M'#13#10 +
       '..AA......M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 14');

  s := '..........M'#13#10 +
       '...AAA....M'#13#10 +
       '..A...A...M'#13#10 +
       '...A.A....M'#13#10 +
       '....A.....M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 15');

  s := '....A.....M'#13#10 +
       '...A.A....M'#13#10 +
       '..A...A...M'#13#10 +
       '...AAA....M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 16');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '..A..A....M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 17');

  s := '..........M'#13#10 +
       '...A......M'#13#10 +
       '..A.A.....M'#13#10 +
       '.A..A.....M'#13#10 +
       '..A.A.....M'#13#10 +
       '...A......M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 18');

  s := '....AA....M'#13#10 +
       '...A..A...M'#13#10 +
       '...A..A...M'#13#10 +
       '....AA....M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = true, 'LyukLenneNegy, true legyen 19');

  s := '.AAAAAAAA.M'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       '.AAAAAAAA.M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, határmenti kínzás 1');

  s := '.A.A..AA..M'#13#10 +
       'A.AAAAAAA.M'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'A.AAAAAAA.M'#13#10 +
       '.A.A..AA..M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.LyukLenneNegy = false, 'LyukLenneNegy, határmenti kínzás 2');

  j.Free;
end;

procedure TMainTest.testJatekterKeresElsoUres;
var s: String;
    j: TJatekTer;
begin
  j := TJatekTer.Create;

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 1) and (j.fElsoUresJ = 1), 'KeresElsoUres 1');

  s := 'AAA.......M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 1) and (j.fElsoUresJ = 4), 'KeresElsoUres 2');

  s := 'AAAABBBCCCM'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 2) and (j.fElsoUresJ = 1), 'KeresElsoUres 3');

  s := 'AAAABBBCCCM'#13#10 +
       'DDDDDDDDD.M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 2) and (j.fElsoUresJ = 10), 'KeresElsoUres 4');

  s := 'AAAABBBCCCM'#13#10 +
       'DDDDDDDDDDM'#13#10 +
       'EEEEEEEEEEM'#13#10 +
       'FFFFFFFFFFM'#13#10 +
       'GGGGGGGGGGM'#13#10 +
       'HHHHHHHHH.M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 6) and (j.fElsoUresJ = 10), 'KeresElsoUres 5');

  s := 'AAAABBBCCCM'#13#10 +
       'DDDDDDDDDDM'#13#10 +
       'EEEEEEEEEEM'#13#10 +
       'FFFFFFFFFFM'#13#10 +
       'GGGGGGGGGGM'#13#10 +
       'HHHHHHHHHHM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  j.KeresElsoUres;
  Check((j.fElsoUresI = 7) and (j.fElsoUresJ = 11), 'KeresElsoUres 6, ki van rakva');

  j.Free;
end;

procedure TMainTest.testJatekterKirakhatoIde;
var s: String;
    j: TJatekTer;
    b: Boolean;
    mMozaikUres, mMozaikElbetu, mMozaikKereszt, mMozaikLepcso, mMozaikHosszu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikLepcso := TMozaik.Create(Lepcso);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikUres, 1, 1);
  Check(b, 'KirakhatoIde true 1');
  b := j.KirakhatoIde(mMozaikUres, 1, 10);
  Check(b, 'KirakhatoIde true 2');
  b := j.KirakhatoIde(mMozaikUres, 6, 10);
  Check(b, 'KirakhatoIde true 3');
  b := j.KirakhatoIde(mMozaikElbetu, 1, 1);
  Check(b, 'KirakhatoIde true 4');
  b := j.KirakhatoIde(mMozaikElbetu, 1, 9);
  Check(b, 'KirakhatoIde true 5');
  b := j.KirakhatoIde(mMozaikElbetu, 3, 9);
  Check(b, 'KirakhatoIde true 6');
  b := j.KirakhatoIde(mMozaikElbetu, 4, 9);
  Check(not b, 'KirakhatoIde false 7');
  b := j.KirakhatoIde(mMozaikElbetu, 3, 10);
  Check(not b, 'KirakhatoIde false 8');

  s := 'AAAAAAAAAAM'#13#10 +
       'BBBBBBBB..M'#13#10 +
       'CC.CC.....M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikElbetu, 2, 8);
  Check(not b, 'KirakhatoIde false 9');
  b := j.KirakhatoIde(mMozaikElbetu, 2, 9);
  Check(b, 'KirakhatoIde true 10');
  b := j.KirakhatoIde(mMozaikKereszt, 3, 1);
  Check(not b, 'KirakhatoIde false 11');
  b := j.KirakhatoIde(mMozaikKereszt, 3, 2);
  Check(not b, 'KirakhatoIde false 12');
  b := j.KirakhatoIde(mMozaikKereszt, 3, 3);
  Check(b, 'KirakhatoIde true 13');

  s := 'AAAAAAAAAAM'#13#10 +
       'BBBBBBBBBBM'#13#10 +
       'CCCCCCCCCCM'#13#10 +
       'DDDDDDDD.DM'#13#10 +
       'EEEEEEE...M'#13#10 +
       'FFFFFFFF.FM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikKereszt, 4, 7);
  Check(not b, 'KirakhatoIde false 14');
  b := j.KirakhatoIde(mMozaikKereszt, 4, 8);
  Check(not b, 'KirakhatoIde false 15');
  b := j.KirakhatoIde(mMozaikKereszt, 4, 9);
  Check(b, 'KirakhatoIde true 16');
  b := j.KirakhatoIde(mMozaikKereszt, 4, 10);
  Check(not b, 'KirakhatoIde false 17');


  s := 'AAAAAAAAAAM'#13#10 +
       'BBBBB.....M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  b := j.KirakhatoIde(mMozaikLepcso, 2, 5);
  Check(not b, 'KirakhatoIde false 18');
  b := j.KirakhatoIde(mMozaikLepcso, 2, 6);
  Check(b, 'KirakhatoIde true 19');
  b := j.KirakhatoIde(mMozaikHosszu, 2, 5);
  Check(not b, 'KirakhatoIde false 20');
  b := j.KirakhatoIde(mMozaikHosszu, 2, 6);
  Check(b, 'KirakhatoIde true 21');
  b := j.KirakhatoIde(mMozaikHosszu, 2, 7);
  Check(not b, 'KirakhatoIde false 21');
  b := j.KirakhatoIde(mMozaikHosszu, 6, 10);
  Check(not b, 'KirakhatoIde false 22');

  mMozaikUres.Free;
  mMozaikElbetu.Free;
  mMozaikKereszt.Free;
  mMozaikLepcso.Free;
  mMozaikHosszu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterKirak;
var s: String;
    j: TJatekTer;
    mMozaikUres, mMozaikKereszt, mMozaikElbetu, mMozaikHosszu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikUres := TMozaik.Create(Ures);
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  j.Kirak(mMozaikUres, 1, 1);
  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  Check(j.Serialize = s, 'Kirak 1');

  j.Kirak(mMozaikHosszu, 1, 1);
  j.Kirak(mMozaikKereszt, 1, 6);
  j.Kirak(mMozaikElbetu, 3, 7);
  s := 'AAAAAE....M'#13#10 +
       '....EEE...M'#13#10 +
       '.....EBB..M'#13#10 +
       '.......B..M'#13#10 +
       '.......B..M'#13#10 +
       '.......B..M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  Check(j.Serialize = s, 'Kirak 2');

  mMozaikUres.Free;
  mMozaikElbetu.Free;
  mMozaikKereszt.Free;
  mMozaikHosszu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterLevesz;
var s: String;
    j: TJatekTer;
    mMozaikKereszt, mMozaikElbetu, mMozaikHosszu: TMozaik;
begin
  j := TJatekTer.Create;
  mMozaikKereszt := TMozaik.Create(Kereszt);
  mMozaikElbetu := TMozaik.Create(Elbetu);
  mMozaikHosszu := TMozaik.Create(Hosszu);

  j.Kirak(mMozaikHosszu, 1, 1);
  j.Kirak(mMozaikKereszt, 1, 6);
  j.Kirak(mMozaikElbetu, 3, 7);
  j.Levesz(mMozaikHosszu, 1, 1);
  j.Levesz(mMozaikKereszt, 1, 6);
  j.Levesz(mMozaikElbetu, 3, 7);

  s := '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       '..........M'#13#10 +
       'MMMMMMMMMMM'#13#10;
  Check(j.Serialize = s, 'Levesz 1');
  
  mMozaikElbetu.Free;
  mMozaikKereszt.Free;
  mMozaikHosszu.Free;
  j.Free;
end;

initialization
  RegisterTest('', TMainTest.Suite);
end.

