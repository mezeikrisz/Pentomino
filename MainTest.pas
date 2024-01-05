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
    procedure testJatekterHasonlit;
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
    procedure testJatekterKeszVan;
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
var t: TSquare;
    mMozaikUres, mMozaikHosszu: TTile;
begin
  mMozaikUres := TTile.Create(Ures);
  mMozaikHosszu := TTile.Create(Hosszu);

  //kódból nem tudok ettõl szebb tömb értékadást. deklarációban megy (oMozaikTomb), kódból nem. lokális deklarációban sem
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikUres.Compare(t), 'Mozaik Compare 1');

  t[1, 1] := 'A';   t[1, 2] := 'A';   t[1, 3] := 'A';   t[1, 4] := 'A';   t[1, 5] := 'A';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHosszu.Compare(t), 'Mozaik Compare 2');

  mMozaikUres.Free;
  mMozaikHosszu.Free;
end;

procedure TMainTest.testMozaikSerialize;
var mMozaikUres, mMozaikHosszu: TTile;
begin
  mMozaikUres := TTile.Create(Ures);
  mMozaikHosszu := TTile.Create(Hosszu);

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
    mMozaikMindegy: TTile;
begin
  mMozaikMindegy := TTile.Create(Ures);

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
var t: TSquare;
    s: String;
    mMozaikHazteto, mMozaikMindegy: TTile;
begin
  mMozaikHazteto := TTile.Create(Hazteto);
  mMozaikMindegy := TTile.Create(Ures);

  mMozaikHazteto.Rotate;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := 'C';   t[1, 4] := 'C';   t[1, 5] := 'C';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := 'C';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := 'C';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHazteto.Compare(t), 'Mozaik Rotate 1, with Compare');

  s := '.....'#13#10 +
       '.*..*'#13#10 +
       '.*..*'#13#10 +
       '.*..*'#13#10 +
       '.....'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Rotate;
  s := '.....'#13#10 +
       '.***.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.***.'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Rotate 2, DeSer+Ser');

  mMozaikHazteto.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikTukroz;
var t: TSquare;
    s: String;
    mMozaikHazteto, mMozaikMindegy: TTile;
begin
  mMozaikHazteto := TTile.Create(Hazteto);
  mMozaikMindegy := TTile.Create(Ures);

  mMozaikHazteto.Flip;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := 'C';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := 'C';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := 'C';   t[3, 4] := 'C';   t[3, 5] := 'C';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikHazteto.Compare(t), 'Mozaik Flip 1, with Compare');

  s := '*....'#13#10 +
       '.*...'#13#10 +
       '..*..'#13#10 +
       '...*.'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Rotate;
  s := '....*'#13#10 +
       '...*.'#13#10 +
       '..*..'#13#10 +
       '.*...'#13#10 +
       '*....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Flip 2, DeSer+Ser');

  mMozaikHazteto.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikNormalizal;
var t: TSquare;
    s: String;
    mMozaikEsbetu, mMozaikMindegy: TTile;
begin
  mMozaikEsbetu := TTile.Create(Esbetu);
  mMozaikMindegy := TTile.Create(Ures);

  mMozaikEsbetu.Rotate;
  mMozaikEsbetu.Rotate;
  mMozaikEsbetu.Normalize;
  t[1, 1] := 'L';   t[1, 2] := 'L';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := 'L';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := 'L';   t[3, 3] := 'L';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(mMozaikEsbetu.Compare(t), 'Mozaik Normalize 1, with Compare');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '..*..'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalize;
  s := '*....'#13#10 +
       '..*..'#13#10 +
       '.**..'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalize 2, DeSer+Ser');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalize;
  s := '.*...'#13#10 +
       '.*...'#13#10 +
       '**...'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalize 3, DeSer+Ser');

  s := '..*..'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '...**'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalize;
  s := '*....'#13#10 +
       '.....'#13#10 +
       '..*..'#13#10 +
       '..*..'#13#10 +
       '.**..'#13#10;
  Check(mMozaikMindegy.Serialize = s, 'Mozaik Normalize 4, DeSer+Ser');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '..***'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalize;
  Check(mMozaikMindegy.fOffsetJ = 2, 'Mozaik Normalize 5, offset');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '*****'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalize;
  Check(mMozaikMindegy.fOffsetJ = 4, 'Mozaik Normalize 6, offset');

  s := '.....'#13#10 +
       '.....'#13#10 +
       '....*'#13#10 +
       '....*'#13#10 +
       '....*'#13#10;
  mMozaikMindegy.DeSerialize(s);
  mMozaikMindegy.Normalize;
  Check(mMozaikMindegy.fOffsetJ = 0, 'Mozaik Normalize 7, offset');


  mMozaikEsbetu.Free;
  mMozaikMindegy.Free;
end;

procedure TMainTest.testMozaikValtoztat;
var t: TSquare;
    s: String;
    mMozaikUres, mMozaikElbetu: TTile;
    b: Boolean;
begin
  mMozaikUres := TTile.Create(Ures);
  mMozaikElbetu := TTile.Create(Elbetu);

  b := mMozaikUres.Vary;
  t[1, 1] := '.';   t[1, 2] := '.';   t[1, 3] := '.';   t[1, 4] := '.';   t[1, 5] := '.';
  t[2, 1] := '.';   t[2, 2] := '.';   t[2, 3] := '.';   t[2, 4] := '.';   t[2, 5] := '.';
  t[3, 1] := '.';   t[3, 2] := '.';   t[3, 3] := '.';   t[3, 4] := '.';   t[3, 5] := '.';
  t[4, 1] := '.';   t[4, 2] := '.';   t[4, 3] := '.';   t[4, 4] := '.';   t[4, 5] := '.';
  t[5, 1] := '.';   t[5, 2] := '.';   t[5, 3] := '.';   t[5, 4] := '.';   t[5, 5] := '.';
  Check(b = true, 'Ures Valtoztat, kimenõ érték true');
  Check(mMozaikUres.Compare(t), 'Ures Valtoztat, result array with Compare');
  b := mMozaikUres.Vary;
  Check(b = false, 'Ures Vary, kimenõ érték false');
  Check(mMozaikUres.Compare(t), 'Ures Vary megint, result array with Compare');

  b := mMozaikElbetu.Vary;
  s := 'BB...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 1, kimenõ érték true');
  Check(mMozaikElbetu.Serialize = s, 'Elbetu Vary 1, Ser');
  b := mMozaikElbetu.Vary;
  s := '...B.'#13#10 +
       'BBBB.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 2, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 2, Ser');
  b := mMozaikElbetu.Vary;
  s := 'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'BB...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 3, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 3, Ser');
  b := mMozaikElbetu.Vary;
  s := 'BBBB.'#13#10 +
       'B....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 4, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 4, Ser');
  b := mMozaikElbetu.Vary;
  s := 'BBBB.'#13#10 +
       '...B.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 5, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 5, Ser');
  b := mMozaikElbetu.Vary;
  s := '.B...'#13#10 +
       '.B...'#13#10 +
       '.B...'#13#10 +
       'BB...'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 6, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 6, Ser');
  b := mMozaikElbetu.Vary;
  s := 'B....'#13#10 +
       'BBBB.'#13#10 +
       '.....'#13#10 +
       '.....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 7, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 7, Ser');
  b := mMozaikElbetu.Vary;
  s := 'BB...'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       '.....'#13#10;
  Check(b = true, 'Elbetu Vary 8, kimenõ érték true');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 8, Ser');
  b := mMozaikElbetu.Vary;
  s := 'BB...'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       'B....'#13#10 +
       '.....'#13#10;
  Check(b = false, 'Elbetu Vary 9, kimenõ érték false');
  Check( mMozaikElbetu.Serialize = s, 'Elbetu Vary 9, Ser');

  mMozaikUres.Free;
end;

procedure TMainTest.testJatekterHasonlit;
var t: TRectangle;
    j: TPlayGround;
begin
  j := TPlayGround.Create;

  //kódból nem tudok ettõl szebb tömb értékadást. deklarációban megy (oMozaikTomb), kódból nem. lokális deklarációban sem
  t[-4, -4] := 'M'; t[-4, -3] := 'M'; t[-4, -2] := 'M'; t[-4, -1] := 'M'; t[-4, 0] := 'M'; t[-4, 1] := 'M'; t[-4, 2] := 'M'; t[-4, 3] := 'M'; t[-4, 4] := 'M'; t[-4, 5] := 'M'; t[-4, 6] := 'M'; t[-4, 7] := 'M'; t[-4, 8] := 'M'; t[-4, 9] := 'M'; t[-4, 10] := 'M'; t[-4, 11] := 'M'; t[-4, 12] := 'M'; t[-4, 13] := 'M'; t[-4, 14] := 'M'; t[-4, 15] := 'M';
  t[-3, -4] := 'M'; t[-3, -3] := 'M'; t[-3, -2] := 'M'; t[-3, -1] := 'M'; t[-3, 0] := 'M'; t[-3, 1] := 'M'; t[-3, 2] := 'M'; t[-3, 3] := 'M'; t[-3, 4] := 'M'; t[-3, 5] := 'M'; t[-3, 6] := 'M'; t[-3, 7] := 'M'; t[-3, 8] := 'M'; t[-3, 9] := 'M'; t[-3, 10] := 'M'; t[-3, 11] := 'M'; t[-3, 12] := 'M'; t[-3, 13] := 'M'; t[-3, 14] := 'M'; t[-3, 15] := 'M';
  t[-2, -4] := 'M'; t[-2, -3] := 'M'; t[-2, -2] := 'M'; t[-2, -1] := 'M'; t[-2, 0] := 'M'; t[-2, 1] := 'M'; t[-2, 2] := 'M'; t[-2, 3] := 'M'; t[-2, 4] := 'M'; t[-2, 5] := 'M'; t[-2, 6] := 'M'; t[-2, 7] := 'M'; t[-2, 8] := 'M'; t[-2, 9] := 'M'; t[-2, 10] := 'M'; t[-2, 11] := 'M'; t[-2, 12] := 'M'; t[-2, 13] := 'M'; t[-2, 14] := 'M'; t[-2, 15] := 'M';
  t[-1, -4] := 'M'; t[-1, -3] := 'M'; t[-1, -2] := 'M'; t[-1, -1] := 'M'; t[-1, 0] := 'M'; t[-1, 1] := 'M'; t[-1, 2] := 'M'; t[-1, 3] := 'M'; t[-1, 4] := 'M'; t[-1, 5] := 'M'; t[-1, 6] := 'M'; t[-1, 7] := 'M'; t[-1, 8] := 'M'; t[-1, 9] := 'M'; t[-1, 10] := 'M'; t[-1, 11] := 'M'; t[-1, 12] := 'M'; t[-1, 13] := 'M'; t[-1, 14] := 'M'; t[-1, 15] := 'M';
  t[0, -4] := 'M';  t[0, -3] := 'M';  t[0, -2] := 'M';  t[0, -1] := 'M';  t[0, 0] := 'M';  t[0, 1] := 'M';  t[0, 2] := 'M';  t[0, 3] := 'M';  t[0, 4] := 'M';  t[0, 5] := 'M';  t[0, 6] := 'M';  t[0, 7] := 'M';  t[0, 8] := 'M';  t[0, 9] := 'M';  t[0, 10] := 'M';  t[0, 11] := 'M';  t[0, 12] := 'M';  t[0, 13] := 'M';  t[0, 14] := 'M';  t[0, 15] := 'M';
  t[1, -4] := 'M';  t[1, -3] := 'M';  t[1, -2] := 'M';  t[1, -1] := 'M';  t[1, 0] := 'M';  t[1, 1] := '.';  t[1, 2] := '.';  t[1, 3] := '.';  t[1, 4] := '.';  t[1, 5] := '.';  t[1, 6] := '.';  t[1, 7] := '.';  t[1, 8] := '.';  t[1, 9] := '.';  t[1, 10] := '.';  t[1, 11] := 'M';  t[1, 12] := 'M';  t[1, 13] := 'M';  t[1, 14] := 'M';  t[1, 15] := 'M';
  t[2, -4] := 'M';  t[2, -3] := 'M';  t[2, -2] := 'M';  t[2, -1] := 'M';  t[2, 0] := 'M';  t[2, 1] := '.';  t[2, 2] := '.';  t[2, 3] := '.';  t[2, 4] := '.';  t[2, 5] := '.';  t[2, 6] := '.';  t[2, 7] := '.';  t[2, 8] := '.';  t[2, 9] := '.';  t[2, 10] := '.';  t[2, 11] := 'M';  t[2, 12] := 'M';  t[2, 13] := 'M';  t[2, 14] := 'M';  t[2, 15] := 'M';
  t[3, -4] := 'M';  t[3, -3] := 'M';  t[3, -2] := 'M';  t[3, -1] := 'M';  t[3, 0] := 'M';  t[3, 1] := '.';  t[3, 2] := '.';  t[3, 3] := '.';  t[3, 4] := '.';  t[3, 5] := '.';  t[3, 6] := '.';  t[3, 7] := '.';  t[3, 8] := '.';  t[3, 9] := '.';  t[3, 10] := '.';  t[3, 11] := 'M';  t[3, 12] := 'M';  t[3, 13] := 'M';  t[3, 14] := 'M';  t[3, 15] := 'M';
  t[4, -4] := 'M';  t[4, -3] := 'M';  t[4, -2] := 'M';  t[4, -1] := 'M';  t[4, 0] := 'M';  t[4, 1] := '.';  t[4, 2] := '.';  t[4, 3] := '.';  t[4, 4] := '.';  t[4, 5] := '.';  t[4, 6] := '.';  t[4, 7] := '.';  t[4, 8] := '.';  t[4, 9] := '.';  t[4, 10] := '.';  t[4, 11] := 'M';  t[4, 12] := 'M';  t[4, 13] := 'M';  t[4, 14] := 'M';  t[4, 15] := 'M';
  t[5, -4] := 'M';  t[5, -3] := 'M';  t[5, -2] := 'M';  t[5, -1] := 'M';  t[5, 0] := 'M';  t[5, 1] := '.';  t[5, 2] := '.';  t[5, 3] := '.';  t[5, 4] := '.';  t[5, 5] := '.';  t[5, 6] := '.';  t[5, 7] := '.';  t[5, 8] := '.';  t[5, 9] := '.';  t[5, 10] := '.';  t[5, 11] := 'M';  t[5, 12] := 'M';  t[5, 13] := 'M';  t[5, 14] := 'M';  t[5, 15] := 'M';
  t[6, -4] := 'M';  t[6, -3] := 'M';  t[6, -2] := 'M';  t[6, -1] := 'M';  t[6, 0] := 'M';  t[6, 1] := '.';  t[6, 2] := '.';  t[6, 3] := '.';  t[6, 4] := '.';  t[6, 5] := '.';  t[6, 6] := '.';  t[6, 7] := '.';  t[6, 8] := '.';  t[6, 9] := '.';  t[6, 10] := '.';  t[6, 11] := 'M';  t[6, 12] := 'M';  t[6, 13] := 'M';  t[6, 14] := 'M';  t[6, 15] := 'M';
  t[7, -4] := 'M';  t[7, -3] := 'M';  t[7, -2] := 'M';  t[7, -1] := 'M';  t[7, 0] := 'M';  t[7, 1] := 'M';  t[7, 2] := 'M';  t[7, 3] := 'M';  t[7, 4] := 'M';  t[7, 5] := 'M';  t[7, 6] := 'M';  t[7, 7] := 'M';  t[7, 8] := 'M';  t[7, 9] := 'M';  t[7, 10] := 'M';  t[7, 11] := 'M';  t[7, 12] := 'M';  t[7, 13] := 'M';  t[7, 14] := 'M';  t[7, 15] := 'M';
  t[8, -4] := 'M';  t[8, -3] := 'M';  t[8, -2] := 'M';  t[8, -1] := 'M';  t[8, 0] := 'M';  t[8, 1] := 'M';  t[8, 2] := 'M';  t[8, 3] := 'M';  t[8, 4] := 'M';  t[8, 5] := 'M';  t[8, 6] := 'M';  t[8, 7] := 'M';  t[8, 8] := 'M';  t[8, 9] := 'M';  t[8, 10] := 'M';  t[8, 11] := 'M';  t[8, 12] := 'M';  t[8, 13] := 'M';  t[8, 14] := 'M';  t[8, 15] := 'M';
  t[9, -4] := 'M';  t[9, -3] := 'M';  t[9, -2] := 'M';  t[9, -1] := 'M';  t[9, 0] := 'M';  t[9, 1] := 'M';  t[9, 2] := 'M';  t[9, 3] := 'M';  t[9, 4] := 'M';  t[9, 5] := 'M';  t[9, 6] := 'M';  t[9, 7] := 'M';  t[9, 8] := 'M';  t[9, 9] := 'M';  t[9, 10] := 'M';  t[9, 11] := 'M';  t[9, 12] := 'M';  t[9, 13] := 'M';  t[9, 14] := 'M';  t[9, 15] := 'M';
  t[10, -4] := 'M'; t[10, -3] := 'M'; t[10, -2] := 'M'; t[10, -1] := 'M'; t[10, 0] := 'M'; t[10, 1] := 'M'; t[10, 2] := 'M'; t[10, 3] := 'M'; t[10, 4] := 'M'; t[10, 5] := 'M'; t[10, 6] := 'M'; t[10, 7] := 'M'; t[10, 8] := 'M'; t[10, 9] := 'M'; t[10, 10] := 'M'; t[10, 11] := 'M'; t[10, 12] := 'M'; t[10, 13] := 'M'; t[10, 14] := 'M'; t[10, 15] := 'M';
  t[11, -4] := 'M'; t[11, -3] := 'M'; t[11, -2] := 'M'; t[11, -1] := 'M'; t[11, 0] := 'M'; t[11, 1] := 'M'; t[11, 2] := 'M'; t[11, 3] := 'M'; t[11, 4] := 'M'; t[11, 5] := 'M'; t[11, 6] := 'M'; t[11, 7] := 'M'; t[11, 8] := 'M'; t[11, 9] := 'M'; t[11, 10] := 'M'; t[11, 11] := 'M'; t[11, 12] := 'M'; t[11, 13] := 'M'; t[11, 14] := 'M'; t[11, 15] := 'M';

  Check(j.Compare(t), 'Jatekter Compare 1');
  j.Free;
end;

procedure TMainTest.testJatekterSerialize;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;
  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  Check(j.Serialize = s, 'Jatekter Serialize');
  j.Free;
end;

procedure TMainTest.testJatekterDeSerialize;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;
  s := '..........'#13#10 +
       '..........'#13#10 +
       '....oo....'#13#10 +
       '....oo....'#13#10 +
       '....oo....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.Serialize = s, 'Mozaik DeSerialize+Serialize');
  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneEgy;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereSingleHole = false, 'LyukLenneEgy, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'AAAAAAAAAAM'#13#10 +
       'MMMMMMMMMMM'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereSingleHole = false, 'LyukLenneEgy, teli táblánál nincs lyuk, false legyen');

  s := '.DD.......'#13#10 +
       'DDD.......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereSingleHole = true, 'LyukLenneEgy, true legyen 1');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereSingleHole = true, 'LyukLenneEgy, true legyen 2');

  s := '.A........'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereSingleHole = true, 'LyukLenneEgy, true legyen 3');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereSingleHole = true, 'LyukLenneEgy, true legyen 4');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneKetto;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = false, 'LyukLenneKetto, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = false, 'LyukLenneKetto, teli táblánál nincs lyuk, false legyen');

  s := 'AAAAA.....'#13#10 +
       '..F.......'#13#10 +
       'FFFF......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = true, 'LyukLenneKetto, true legyen 1');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAA.'#13#10 +
       'AAAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = true, 'LyukLenneKetto, true legyen 2');

  s := '.A........'#13#10 +
       '.A........'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = true, 'LyukLenneKetto, true legyen 3');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = true, 'LyukLenneKetto, true legyen 4');

  s := '..........'#13#10 +
       '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '...AA.....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereDoubleHole = true, 'LyukLenneKetto, true legyen 5');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneHarom;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = false, 'LyukLenneHarom, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = false, 'LyukLenneHarom, teli táblánál nincs lyuk, false legyen');

  s := '..........'#13#10 +
       '...AAA....'#13#10 +
       '..A...A...'#13#10 +
       '...AAA....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = true, 'LyukLenneHarom, true legyen 1');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = true, 'LyukLenneHarom, true legyen 2');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A..A....'#13#10 +
       '...AA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = true, 'LyukLenneHarom, true legyen 3');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '.A..A.....'#13#10 +
       '..AA......'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = true, 'LyukLenneHarom, true legyen 4');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '.....AA...'#13#10 +
       '....A..A..'#13#10 +
       '.....A.A..'#13#10 +
       '......A...'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = true, 'LyukLenneHarom, true legyen 5');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '.....AA...'#13#10 +
       '....A..A..'#13#10 +
       '....A.A...'#13#10 +
       '.....A....'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = true, 'LyukLenneHarom, true legyen 6');

  s := '.AAAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       '.AAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = false, 'LyukLenneHarom, határmenti kínzás 1');

  s := '.AAA..AAA.'#13#10 +
       'A.AAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'A.AAAAAAA.'#13#10 +
       '.AAA..AAA.'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereTripleHole = false, 'LyukLenneHarom, határmenti kínzás 2');

  j.Free;
end;

procedure TMainTest.testJatekterLyukLenneNegy;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;

  s := 'AB........'#13#10 +
       'AB........'#13#10 +
       'AB........'#13#10 +
       'ABB.......'#13#10 +
       'A.........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = false, 'LyukLenneNegy, két elemnél nincs lyuk, false legyen');

  s := 'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = false, 'LyukLenneNegy, teli táblánál nincs lyuk, false legyen');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..AAAA....'#13#10 +
       '.A....A...'#13#10 +
       '..AAAA....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 1');

  s := '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 2');

  s := '..........'#13#10 +
       '..A.......'#13#10 +
       '.A.AA.....'#13#10 +
       '.A...A....'#13#10 +
       '..AAA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 3');

  s := '..........'#13#10 +
       '....A.....'#13#10 +
       '..AA.A....'#13#10 +
       '.A...A....'#13#10 +
       '..AAA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 4');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..AAA.....'#13#10 +
       '.A...A....'#13#10 +
       '..AA.A....'#13#10 +
       '....A.....'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 5');

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..AAA.....'#13#10 +
       '.A...A....'#13#10 +
       '.A.AA.....'#13#10 +
       '..A.......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 6');

  s := '....A.....'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '...A..A...'#13#10 +
       '....AA....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 7');

  s := '....A.....'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '..A..A....'#13#10 +
       '...AA.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 8');

  s := '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '....A.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 9');

  s := '....AA....'#13#10 +
       '...A..A...'#13#10 +
       '...A.A....'#13#10 +
       '...A.A....'#13#10 +
       '....A.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 10');

  s := '..........'#13#10 +
       '..A.......'#13#10 +
       '.A.A......'#13#10 +
       '.A..A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 11');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '.A..A.....'#13#10 +
       '.A.A......'#13#10 +
       '..A.......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 12');

  s := '..........'#13#10 +
       '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '...A..A...'#13#10 +
       '....AA....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 13');

  s := '..........'#13#10 +
       '...AA.....'#13#10 +
       '..A..A....'#13#10 +
       '.A..A.....'#13#10 +
       '..AA......'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 14');

  s := '..........'#13#10 +
       '...AAA....'#13#10 +
       '..A...A...'#13#10 +
       '...A.A....'#13#10 +
       '....A.....'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 15');

  s := '....A.....'#13#10 +
       '...A.A....'#13#10 +
       '..A...A...'#13#10 +
       '...AAA....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 16');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '..A..A....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 17');

  s := '..........'#13#10 +
       '...A......'#13#10 +
       '..A.A.....'#13#10 +
       '.A..A.....'#13#10 +
       '..A.A.....'#13#10 +
       '...A......'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 18');

  s := '....AA....'#13#10 +
       '...A..A...'#13#10 +
       '...A..A...'#13#10 +
       '....AA....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = true, 'LyukLenneNegy, true legyen 19');

  s := '.AAAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       '.AAAAAAAA.'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = false, 'LyukLenneNegy, határmenti kínzás 1');

  s := '.A.A..AA..'#13#10 +
       'A.AAAAAAA.'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'AAAAAAAAAA'#13#10 +
       'A.AAAAAAA.'#13#10 +
       '.A.A..AA..'#13#10;
  j.DeSerialize(s);
  Check(j.IsThereQuadrupleHole = false, 'LyukLenneNegy, határmenti kínzás 2');

  j.Free;
end;

procedure TMainTest.testJatekterKeresElsoUres;
var s: String;
    j: TPlayGround;
begin
  j := TPlayGround.Create;

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.FindFirstEmpty;
  Check((j.fFirstEmptyI = 1) and (j.fFirstEmptyJ = 1), 'KeresElsoUres 1');

  s := 'AAA.......'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.FindFirstEmpty;
  Check((j.fFirstEmptyI = 1) and (j.fFirstEmptyJ = 4), 'KeresElsoUres 2');

  s := 'AAAABBBCCC'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.FindFirstEmpty;
  Check((j.fFirstEmptyI = 2) and (j.fFirstEmptyJ = 1), 'KeresElsoUres 3');

  s := 'AAAABBBCCC'#13#10 +
       'DDDDDDDDD.'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  j.FindFirstEmpty;
  Check((j.fFirstEmptyI = 2) and (j.fFirstEmptyJ = 10), 'KeresElsoUres 4');

  s := 'AAAABBBCCC'#13#10 +
       'DDDDDDDDDD'#13#10 +
       'EEEEEEEEEE'#13#10 +
       'FFFFFFFFFF'#13#10 +
       'GGGGGGGGGG'#13#10 +
       'HHHHHHHHH.'#13#10;
  j.DeSerialize(s);
  j.FindFirstEmpty;
  Check((j.fFirstEmptyI = 6) and (j.fFirstEmptyJ = 10), 'KeresElsoUres 5');

  s := 'AAAABBBCCC'#13#10 +
       'DDDDDDDDDD'#13#10 +
       'EEEEEEEEEE'#13#10 +
       'FFFFFFFFFF'#13#10 +
       'GGGGGGGGGG'#13#10 +
       'HHHHHHHHHH'#13#10;
  j.DeSerialize(s);
  j.FindFirstEmpty;
  Check((j.fFirstEmptyI = 7) and (j.fFirstEmptyJ = 11), 'KeresElsoUres 6, ki van rakva');

  j.Free;
end;

procedure TMainTest.testJatekterKirakhatoIde;
var s: String;
    j: TPlayGround;
    b: Boolean;
    mMozaikUres, mMozaikElbetu, mMozaikKereszt, mMozaikLepcso, mMozaikHosszu: TTile;
begin
  j := TPlayGround.Create;
  mMozaikUres := TTile.Create(Ures);
  mMozaikElbetu := TTile.Create(Elbetu);
  mMozaikKereszt := TTile.Create(Kereszt);
  mMozaikLepcso := TTile.Create(Lepcso);
  mMozaikHosszu := TTile.Create(Hosszu);

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  b := j.IsPuttableHere(mMozaikUres, 1, 1);
  Check(b, 'KirakhatoIde true 1');
  b := j.IsPuttableHere(mMozaikUres, 1, 10);
  Check(b, 'KirakhatoIde true 2');
  b := j.IsPuttableHere(mMozaikUres, 6, 10);
  Check(b, 'KirakhatoIde true 3');
  b := j.IsPuttableHere(mMozaikElbetu, 1, 1);
  Check(b, 'KirakhatoIde true 4');
  b := j.IsPuttableHere(mMozaikElbetu, 1, 9);
  Check(b, 'KirakhatoIde true 5');
  b := j.IsPuttableHere(mMozaikElbetu, 3, 9);
  Check(b, 'KirakhatoIde true 6');
  b := j.IsPuttableHere(mMozaikElbetu, 4, 9);
  Check(not b, 'KirakhatoIde false 7');
  b := j.IsPuttableHere(mMozaikElbetu, 3, 10);
  Check(not b, 'KirakhatoIde false 8');

  s := 'AAAAAAAAAA'#13#10 +
       'BBBBBBBB..'#13#10 +
       'CC.CC.....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  b := j.IsPuttableHere(mMozaikElbetu, 2, 8);
  Check(not b, 'KirakhatoIde false 9');
  b := j.IsPuttableHere(mMozaikElbetu, 2, 9);
  Check(b, 'KirakhatoIde true 10');
  b := j.IsPuttableHere(mMozaikKereszt, 3, 1);
  Check(not b, 'KirakhatoIde false 11');
  b := j.IsPuttableHere(mMozaikKereszt, 3, 2);
  Check(not b, 'KirakhatoIde false 12');
  b := j.IsPuttableHere(mMozaikKereszt, 3, 3);
  Check(b, 'KirakhatoIde true 13');

  s := 'AAAAAAAAAA'#13#10 +
       'BBBBBBBBBB'#13#10 +
       'CCCCCCCCCC'#13#10 +
       'DDDDDDDD.D'#13#10 +
       'EEEEEEE...'#13#10 +
       'FFFFFFFF.F'#13#10;
  j.DeSerialize(s);
  b := j.IsPuttableHere(mMozaikKereszt, 4, 7);
  Check(not b, 'KirakhatoIde false 14');
  b := j.IsPuttableHere(mMozaikKereszt, 4, 8);
  Check(not b, 'KirakhatoIde false 15');
  b := j.IsPuttableHere(mMozaikKereszt, 4, 9);
  Check(b, 'KirakhatoIde true 16');
  b := j.IsPuttableHere(mMozaikKereszt, 4, 10);
  Check(not b, 'KirakhatoIde false 17');


  s := 'AAAAAAAAAA'#13#10 +
       'BBBBB.....'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  j.DeSerialize(s);
  b := j.IsPuttableHere(mMozaikLepcso, 2, 5);
  Check(not b, 'KirakhatoIde false 18');
  b := j.IsPuttableHere(mMozaikLepcso, 2, 6);
  Check(b, 'KirakhatoIde true 19');
  b := j.IsPuttableHere(mMozaikHosszu, 2, 5);
  Check(not b, 'KirakhatoIde false 20');
  b := j.IsPuttableHere(mMozaikHosszu, 2, 6);
  Check(b, 'KirakhatoIde true 21');
  b := j.IsPuttableHere(mMozaikHosszu, 2, 7);
  Check(not b, 'KirakhatoIde false 21');
  b := j.IsPuttableHere(mMozaikHosszu, 6, 10);
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
    j: TPlayGround;
    mMozaikUres, mMozaikKereszt, mMozaikElbetu, mMozaikHosszu: TTile;
begin
  j := TPlayGround.Create;
  mMozaikUres := TTile.Create(Ures);
  mMozaikKereszt := TTile.Create(Kereszt);
  mMozaikElbetu := TTile.Create(Elbetu);
  mMozaikHosszu := TTile.Create(Hosszu);

  j.Put(mMozaikUres, 1, 1);
  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  Check(j.Serialize = s, 'Kirak 1');

  j.Put(mMozaikHosszu, 1, 1);
  j.Put(mMozaikKereszt, 1, 6);
  j.Put(mMozaikElbetu, 3, 7);
  s := 'AAAAAE....'#13#10 +
       '....EEE...'#13#10 +
       '.....EBB..'#13#10 +
       '.......B..'#13#10 +
       '.......B..'#13#10 +
       '.......B..'#13#10;
  Check(j.Serialize = s, 'Kirak 2');

  mMozaikUres.Free;
  mMozaikElbetu.Free;
  mMozaikKereszt.Free;
  mMozaikHosszu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterLevesz;
var s: String;
    j: TPlayGround;
    mMozaikHosszu, mMozaikElbetu, mMozaikHazteto, mMozaikSonka, mMozaikKereszt, mMozaikPuska, mMozaikLapat, mMozaikCsunya, mMozaikTebetu, mMozaikLepcso, mMozaikUbetu, mMozaikEsbetu: TTile;
begin
  j := TPlayGround.Create;
  mMozaikHosszu := TTile.Create(Hosszu);
  mMozaikElbetu := TTile.Create(Elbetu);
  mMozaikHazteto := TTile.Create(Hazteto);
  mMozaikSonka := TTile.Create(Sonka);
  mMozaikKereszt := TTile.Create(Kereszt);
  mMozaikPuska := TTile.Create(Puska);
  mMozaikLapat := TTile.Create(Lapat);
  mMozaikCsunya := TTile.Create(Csunya);
  mMozaikTebetu := TTile.Create(Tebetu);
  mMozaikLepcso := TTile.Create(Lepcso);
  mMozaikUbetu := TTile.Create(Ubetu);
  mMozaikEsbetu := TTile.Create(Esbetu);

  j.Put(mMozaikSonka, 1, 1);
  j.Put(mMozaikUbetu, 1, 4);
  j.Put(mMozaikCsunya, 1, 7);
  j.Put(mMozaikElbetu, 1, 9);
  j.Put(mMozaikLapat, 2, 3);
  j.Put(mMozaikKereszt, 2, 5);
  j.Put(mMozaikPuska, 2, 7);
  j.Put(mMozaikEsbetu, 3, 1);
  j.Put(mMozaikTebetu, 3, 9);
  j.Put(mMozaikHazteto, 4, 1);
  j.Put(mMozaikLepcso, 4, 6);
  j.Put(mMozaikHosszu, 6, 6);

  j.TakeOff(mMozaikHosszu, 6, 6);
  j.TakeOff(mMozaikLepcso, 4, 6);
  j.TakeOff(mMozaikHazteto, 4, 1);
  j.TakeOff(mMozaikTebetu, 3, 9);
  j.TakeOff(mMozaikEsbetu, 3, 1);
  j.TakeOff(mMozaikPuska, 2, 7);
  j.TakeOff(mMozaikKereszt, 2, 5);
  j.TakeOff(mMozaikLapat, 2, 3);
  j.TakeOff(mMozaikElbetu, 1, 9);
  j.TakeOff(mMozaikCsunya, 1, 7);
  j.TakeOff(mMozaikUbetu, 1, 4);
  j.TakeOff(mMozaikSonka, 1, 1);

  s := '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10 +
       '..........'#13#10;
  Check(j.Serialize = s, 'Levesz 1');

  mMozaikHosszu.Free;
  mMozaikElbetu.Free;
  mMozaikHazteto.Free;
  mMozaikSonka.Free;
  mMozaikKereszt.Free;
  mMozaikPuska.Free;
  mMozaikLapat.Free;
  mMozaikCsunya.Free;
  mMozaikTebetu.Free;
  mMozaikLepcso.Free;
  mMozaikUbetu.Free;
  mMozaikEsbetu.Free;
  j.Free;
end;

procedure TMainTest.testJatekterKeszVan;
var s: String;
    j: TPlayGround;
    mMozaikHosszu, mMozaikElbetu, mMozaikHazteto, mMozaikSonka, mMozaikKereszt, mMozaikPuska, mMozaikLapat, mMozaikCsunya, mMozaikTebetu, mMozaikLepcso, mMozaikUbetu, mMozaikEsbetu: TTile;
begin
  j := TPlayGround.Create;
  mMozaikHosszu := TTile.Create(Hosszu);
  mMozaikElbetu := TTile.Create(Elbetu);
  mMozaikHazteto := TTile.Create(Hazteto);
  mMozaikSonka := TTile.Create(Sonka);
  mMozaikKereszt := TTile.Create(Kereszt);
  mMozaikPuska := TTile.Create(Puska);
  mMozaikLapat := TTile.Create(Lapat);
  mMozaikCsunya := TTile.Create(Csunya);
  mMozaikTebetu := TTile.Create(Tebetu);
  mMozaikLepcso := TTile.Create(Lepcso);
  mMozaikUbetu := TTile.Create(Ubetu);
  mMozaikEsbetu := TTile.Create(Esbetu);

  Check(not j.IsReady, 'KeszVan 1 false');
  j.Put(mMozaikSonka, 1, 1);
  j.Put(mMozaikUbetu, 1, 4);
  j.Put(mMozaikCsunya, 1, 7);
  j.Put(mMozaikElbetu, 1, 9);
  j.Put(mMozaikLapat, 2, 3);
  j.Put(mMozaikKereszt, 2, 5);
  j.Put(mMozaikPuska, 2, 7);
  j.Put(mMozaikEsbetu, 3, 1);
  j.Put(mMozaikTebetu, 3, 9);
  j.Put(mMozaikHazteto, 4, 1);
  j.Put(mMozaikLepcso, 4, 6);
  Check(not j.IsReady, 'KeszVan 2 false');
  j.Put(mMozaikHosszu, 6, 6);
  Check(j.IsReady, 'KeszVan 3 true');

  mMozaikHosszu.Free;
  mMozaikElbetu.Free;
  mMozaikHazteto.Free;
  mMozaikSonka.Free;
  mMozaikKereszt.Free;
  mMozaikPuska.Free;
  mMozaikLapat.Free;
  mMozaikCsunya.Free;
  mMozaikTebetu.Free;
  mMozaikLepcso.Free;
  mMozaikUbetu.Free;
  mMozaikEsbetu.Free;
  j.Free;
end;

initialization
  RegisterTest('', TMainTest.Suite);
end.

