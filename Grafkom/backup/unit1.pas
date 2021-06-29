unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  Types, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Spin, Arrow;

type
    element = record
    x,y:integer;
  end;

   objek = record
    point:array of element;
    jml_point:integer;
    width_line : Integer;
    style:TPenStyle;
    area:TRect;
    color:TColor;
    color_outline : TColor ;
    obj_type:String;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    ActivedButton: TStaticText;
    ArrowBottom: TArrow;
    ArrowLeft: TArrow;
    ArrowRight: TArrow;
    ArrowUp: TArrow;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Bucket: TBitBtn;
    Clipboard: TGroupBox;
    Colors: TGroupBox;
    FillColor: TColorButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Line: TGroupBox;
    LineColor: TColorButton;
    Lingkaran: TBitBtn;
    Move: TGroupBox;
    Pentagon: TBitBtn;
    Persegi: TBitBtn;
    Reset: TToggleBox;
    Scale: TGroupBox;
    SegiEnam: TBitBtn;
    Segitiga: TBitBtn;
    Select: TToggleBox;
    SelectedObj: TStaticText;
    Shape: TGroupBox;
    spdEraser: TSpeedButton;
    spdLine: TSpeedButton;
    spdPencil: TSpeedButton;
    SpinMove: TSpinEdit;
    SpinRotate: TSpinEdit;
    PositionX: TStaticText;
    PositionY: TStaticText;
    TebalGaris: TSpinEdit;
    TipeGaris: TComboBox;
    Tools: TGroupBox;
    ZoomIn: TBitBtn;
    ZoomOut: TBitBtn;
    procedure ArrowBottomClick(Sender: TObject);
    procedure ArrowLeftClick(Sender: TObject);
    procedure ArrowRightClick(Sender: TObject);
    procedure ArrowUpClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BucketClick(Sender: TObject);
    procedure FormActive(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label6Click(Sender: TObject);
    procedure LingkaranClick(Sender: TObject);
    procedure PentagonClick(Sender: TObject);
    procedure PersegiClick(Sender: TObject);
    procedure ResetChange(Sender: TObject);
    procedure SegiEnamClick(Sender: TObject);
    procedure SegitigaClick(Sender: TObject);
    procedure SelectChange(Sender: TObject);
    procedure SelectedObjClick(Sender: TObject);
    procedure spdEraserClick(Sender: TObject);
    procedure spdLineClick(Sender: TObject);
    procedure spdPencilClick(Sender: TObject);
    procedure TipeGarisChange(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure TitikTengah(x:integer);
    procedure Tampil();
    procedure BoundaryFill(x, y, boundary, fill: Integer);
    procedure SelectObjek(x , y:integer);
  private

  public

  end;

var
  Form1: TForm1;
  //variabel global yang menangani semua procedure
  obj:array of objek;
  obj_terpilih:integer;
  a,b,i,j,x1,y1,x2,y2,obj_terakhir:integer;
  btn_terpilih:String;
  mousedown_on:Boolean;
  line_style:TPenStyle;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormActive(Sender: TObject);
begin
  //Mengosongkan bidang gambar yang berbentuk persegi panjang dan penetapan obj_terkhir bernilai 0
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
  obj_terakhir:=0;
end;

procedure TForm1.BucketClick(Sender: TObject);
begin
  //Untuk Fill Colour
  btn_terpilih:='warna';
  //Keterangan Actived Button di pojok kiri bawah pada GUI
  ActivedButton.Caption:=btn_terpilih;
end;

//Bergerak Ke Atas
procedure TForm1.ArrowUpClick(Sender: TObject);
begin
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
       //titik-titik koordinat Y dikurangi dengan nilai yang diinputkan agar dapat bergerak ke atas
       obj[obj_terpilih].point[i].y:=obj[obj_terpilih].point[i].y-SpinMove.Value;
  end;

  if obj[obj_terpilih].obj_type='persegi' then
  begin
     //nge-create area(koordinat x titik 0, koordinat y titik 0 baru, koordinat x titik 2, koordinat y titik 2 baru)
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[2].x,obj[obj_terpilih].point[2].y);
  end;

  if obj[obj_terpilih].obj_type='lingkaran' then
  begin
     //nge-create area(koordinat x titik 0, koordinat y titik 0 baru, koordinat x titik (sesuai jumlah titiknya), koordinat y titik (sesuai jumlah titiknya) baru)
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].x,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].y);
  end;

  Tampil();
end;

//Rotasi Ke Kanan
procedure TForm1.BitBtn1Click(Sender: TObject);
var
  Temp:element;
  sdt:real;
begin
  //Pencarian titik tengah berdasarkan objek yang sedang terpilih
  TitikTengah(obj_terpilih);

  //Melakukan perulangan sampai banyak jumlah titik pada objek
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
    //Melakukan pengurangan antara masing-masing koordinat ditiap titik dengan masing masing hasil titik tengah
    obj[obj_terpilih].point[i].x := obj[obj_terpilih].point[i].x - a;
    obj[obj_terpilih].point[i].y := obj[obj_terpilih].point[i].y - b;
    //Hal ini digunakan untuk memindahkan objek sehingga pivot point pada titik pusat(0,0)

    //Ambil nilai yang diinputkan dikali PI dibagi 180 untuk mendapatkan sudut
    sdt := SpinRotate.Value*PI/180;

    //Melakukan perhitungan dengan rumus untuk memutar objek pada titik pusat sesuai besar sudut putar
    Temp.x := Round(obj[obj_terpilih].point[i].x*cos(sdt) - obj[obj_terpilih].point[i].y*sin(sdt));
    Temp.y := Round(obj[obj_terpilih].point[i].x*sin(sdt) + obj[obj_terpilih].point[i].y*cos(sdt));
    //Round digunakan untuk pembulatan hasil

    //Memindahkan objek dari titik pusat ke posisi semula
    obj[obj_terpilih].point[i] := Temp;
    obj[obj_terpilih].point[i].x := obj[obj_terpilih].point[i].x+a;
    obj[obj_terpilih].point[i].y := obj[obj_terpilih].point[i].y+b;
  end;
  Tampil();
end;

//Rotasi Ke Kiri
procedure TForm1.BitBtn2Click(Sender: TObject);
var
  Temp:element;
  sdt:real;
begin
  //Pencarian titik tengah berdasarkan objek yang sedang terpilih
  TitikTengah(obj_terpilih);

  //Melakukan perhitungan sama dengan rotasi kanan
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
    obj[obj_terpilih].point[i].x := obj[obj_terpilih].point[i].x - a;
    obj[obj_terpilih].point[i].y := obj[obj_terpilih].point[i].y - b;

    //Yang membedakan adalah mengambil nilai yang diinputkan menjadi negatif untuk bergerak ke kiri
    sdt := -SpinRotate.Value*PI/180;

    Temp.x := Round(obj[obj_terpilih].point[i].x*cos(sdt) - obj[obj_terpilih].point[i].y*sin(sdt));
    Temp.y := Round(obj[obj_terpilih].point[i].x*sin(sdt) + obj[obj_terpilih].point[i].y*cos(sdt));

    obj[obj_terpilih].point[i] := Temp;
    obj[obj_terpilih].point[i].x := obj[obj_terpilih].point[i].x+a;
    obj[obj_terpilih].point[i].y := obj[obj_terpilih].point[i].y+b;
  end;
  Tampil();
end;

//Bergerak ke kanan
procedure TForm1.ArrowRightClick(Sender: TObject);
begin
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
       //titik-titik koordinat X ditambah dengan nilai yang diinputkan agar dapat bergerak ke kanan
       obj[obj_terpilih].point[i].x:=obj[obj_terpilih].point[i].x+SpinMove.Value;
  end;

  //Jika tipe objeknya persegi
  if obj[obj_terpilih].obj_type='persegi' then
  begin
     //nge-create area(koordinat x titik 0 baru, koordinat y titik 0, koordinat x titik 2 baru, koordinat y titik 2)
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[2].x,obj[obj_terpilih].point[2].y);
  end;

  //jika tipe objeknya lingkaran
  if obj[obj_terpilih].obj_type='lingkaran' then
  begin
    //nge-create area(koordinat x titik 0 baru, koordinat y titik 0, koordinat x titik (sesuai jumlah titiknya) baru, koordinat y titik (sesuai jumlah titiknya))
    obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].x,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].y);
  end;

  Tampil();
end;

//Bergerak Ke Bawah
procedure TForm1.ArrowBottomClick(Sender: TObject);
begin
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
       //titik-titik koordinat Y ditambah dengan nilai yang diinputkan agar dapat bergerak ke bawah
       obj[obj_terpilih].point[i].y:=obj[obj_terpilih].point[i].y+SpinMove.Value;
  end;

  if obj[obj_terpilih].obj_type='persegi' then
  begin
     //nge-create area(koordinat x titik 0, koordinat y titik 0 baru, koordinat x titik 2, koordinat y titik 2 baru)
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[2].x,obj[obj_terpilih].point[2].y);
  end;

  if obj[obj_terpilih].obj_type='lingkaran' then
  begin
     //nge-create area(koordinat x titik 0, koordinat y titik 0 baru, koordinat x titik (sesuai jumlah titiknya), koordinat y titik (sesuai jumlah titiknya) baru)
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].x,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].y);
  end;
  Tampil();
end;

//Bergerak Ke Kiri
procedure TForm1.ArrowLeftClick(Sender: TObject);
begin
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
       //titik-titik koordinat X dikurangi dengan nilai yang diinputkan agar dapat bergerak ke kiri
       obj[obj_terpilih].point[i].x:=obj[obj_terpilih].point[i].x-SpinMove.Value;
  end;
  if obj[obj_terpilih].obj_type='persegi' then
  begin
     //nge-create area(koordinat x titik 0 baru, koordinat y titik 0, koordinat x titik 2 baru, koordinat y titik 2)
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[2].x,obj[obj_terpilih].point[2].y);
  end;
  if obj[obj_terpilih].obj_type='lingkaran' then
  begin
     //nge-create area(koordinat x titik 0 baru, koordinat y titik 0, koordinat x titik (sesuai jumlah titiknya) baru, koordinat y titik (sesuai jumlah titiknya))
     obj[obj_terpilih].area.Create(obj[obj_terpilih].point[0].x,obj[obj_terpilih].point[0].y,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].x,obj[obj_terpilih].point[obj[obj_terpilih].jml_point].y);
  end;
  Tampil();
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //Mengosongkan bidang gambar yang berbentuk persegi panjang
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);

  //Jika objeknya lebih dari 1 maka
  if obj_terakhir > 1 then
  begin
     for i:= 0 to obj_terakhir do
     begin
          //melakukan pergerakan untuk masing masing objek
          Image1.Canvas.MoveTo(obj[i].point[obj[i].jml_point].x,obj[i].point[obj[i].jml_point].y);
          for j:= 0 to obj[i].jml_point do
          begin
               //menarik garis
               Image1.Canvas.LineTo(obj[i].point[j].x,obj[i].point[j].y);
          end;
     end;
     Image1.Refresh;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  x1:=X;
  y1:=Y;

  if btn_terpilih = 'pencil' then
  begin
     //Ambil nilai warna garis, tipe garis, dan tebal garis
     Image1.Canvas.Pen.Color:=LineColor.ButtonColor;
     Image1.Canvas.Pen.Style:=line_style;
     Image1.Canvas.Pen.Width:=TebalGaris.Value;
     //Melakukan pergerakan dari X ke Y
     Image1.Canvas.MoveTo(X,Y);
  end
  else if btn_terpilih = 'eraser' then
  begin
     //Ambil nilai warna putih dan nilai tebal garis
     Image1.Canvas.Pen.Color:=clWhite;
     Image1.Canvas.Pen.Width:=TebalGaris.Value;
     Image1.Canvas.MoveTo(X,Y);
  end
  else if btn_terpilih = 'warna' then
  begin
     //Melakukan pewarnaan dengan mengambil nilai fill colour untuk diproses di BoundaryFill
     BoundaryFill(X,Y,Image1.Canvas.Pen.Color,FillColor.ButtonColor);
     SelectObjek(X,Y);
     obj[obj_terpilih].color:=FillColor.ButtonColor;
  end

  //Jika tombol terpilih adalah select
  else if btn_terpilih = 'select' then
   begin
     //Melakukan select objek
     SelectObjek(X,Y);
   end

  //Jika tombol tidak sama dengan ' '
  else if btn_terpilih <> '' then
  begin
      obj_terakhir:=obj_terakhir+1;
      SetLength(obj,obj_terakhir);
  end;

  mousedown_on:= true;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Untuk menampilkan koordinat X dan Y
  PositionX.Caption:=X.ToString;
  PositionY.Caption:=Y.ToString;
   if mousedown_on = true then
       begin
             if btn_terpilih = 'pencil' then
             begin
                  Image1.Canvas.LineTo(X,Y);
             end
             else if btn_terpilih = 'eraser' then
             begin
                  //Menarik garis dari X ke Y
                  Image1.Canvas.LineTo(X,Y);
             end;


       end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

   x2:=X;
   y2:=Y;

    if btn_terpilih = 'pencil' then
      begin
      end;

     if btn_terpilih = 'line' then
      begin
         //Titiknya ada 2
         SetLength(obj[obj_terakhir-1].point,2);

         //mengambil titik-titik dari koordinat yang ada
         obj[obj_terakhir-1].point[0].x:=x1;   obj[obj_terakhir-1].point[0].y:=y1;
         obj[obj_terakhir-1].point[1].x:=x2;   obj[obj_terakhir-1].point[1].y:=y2;

         //memberi nilai jml_point = 1 dan obj_typenya untuk digunakan di proses lain (rotasi dll)
         obj[obj_terakhir-1].jml_point:=1;
         obj[obj_terakhir-1].obj_type:='line';

         //pemberian warna garis, tipe garis, dan tebal garis
         obj[obj_terakhir-1].color_outline:=LineColor.ButtonColor;
         obj[obj_terakhir-1].style:=line_style;
         obj[obj_terakhir-1].width_line:=TebalGaris.Value;

         //pemanggilan proses tampil
         Tampil();

         //obj_terpilih-1 menjadi objek terpilih
         obj_terpilih:=obj_terakhir-1;
      end;
     if btn_terpilih = 'persegi' then
      begin
           //Titiknya ada 4
           SetLength(obj[obj_terakhir-1].point,4);

           obj[obj_terakhir-1].point[0].x:=x1; obj[obj_terakhir-1].point[0].y:=y1;
           obj[obj_terakhir-1].point[1].x:=x2; obj[obj_terakhir-1].point[1].y:=y1;
           obj[obj_terakhir-1].point[2].x:=x2; obj[obj_terakhir-1].point[2].y:=y2;
           obj[obj_terakhir-1].point[3].x:=x1; obj[obj_terakhir-1].point[3].y:=y2;

           //pemberian jumlah titik objek ada 3
           obj[obj_terakhir-1].jml_point:=3;
           obj[obj_terakhir-1].obj_type:='persegi';

           obj[obj_terakhir-1].color:=clWhite;
           obj[obj_terakhir-1].area.Create(x1,y1,x2,y2);
           obj[obj_terakhir-1].style:=line_style;
           obj[obj_terakhir-1].width_line:=TebalGaris.Value;
           obj[obj_terakhir-1].color_outline:=LineColor.ButtonColor;

           //pemanggilan tampil()
           Tampil();

           //nilai objek ini menjadi obj_terpilih
           obj_terpilih:=obj_terakhir-1;

      end;
      if btn_terpilih = 'lingkaran' then
      begin
         SetLength(obj[obj_terakhir-1].point,2);
         obj[obj_terakhir-1].point[0].x:=x1; obj[obj_terakhir-1].point[0].y:=y1;
         obj[obj_terakhir-1].point[1].x:=x2; obj[obj_terakhir-1].point[1].y:=y2;

         obj[obj_terakhir-1].jml_point:=1;
         obj[obj_terakhir-1].obj_type:='lingkaran';

         obj[obj_terakhir-1].color:=clWhite;
         obj[obj_terakhir-1].area.Create(x1,y1,x2,y2);
         obj[obj_terakhir-1].style:=line_style;
         obj[obj_terakhir-1].width_line:=TebalGaris.Value;
         obj[obj_terakhir-1].color_outline:=LineColor.ButtonColor;

         Tampil();
         obj_terpilih:=obj_terakhir-1;
      end;
       if  btn_terpilih = 'segitiga' then
      begin
         SetLength(obj[obj_terakhir-1].point,3);
         obj[obj_terakhir-1].point[0].x:=x1;                      obj[obj_terakhir-1].point[0].y:=y1;
         obj[obj_terakhir-1].point[1].x:=x1 - (x2-x1);            obj[obj_terakhir-1].point[1].y:=y2;
         obj[obj_terakhir-1].point[2].x:=x2;                      obj[obj_terakhir-1].point[2].y:=y2;

         obj[obj_terakhir-1].jml_point:=2;
         obj[obj_terakhir-1].obj_type:='segitiga';
         obj[obj_terakhir-1].color:=clWhite;
         obj[obj_terakhir-1].area.Create((x1-(x2-x1)),y1,x2,y2);
         obj[obj_terakhir-1].style:=line_style;
         obj[obj_terakhir-1].width_line:=TebalGaris.Value;
         obj[obj_terakhir-1].color_outline:=LineColor.ButtonColor;

         Tampil();
         obj_terpilih:=obj_terakhir-1;
      end;
        if btn_terpilih = 'pentagon' then
      begin
         SetLength(obj[obj_terakhir-1].point,5);
           obj[obj_terakhir-1].point[0].x:=x1;                        obj[obj_terakhir-1].point[0].y:=y1;
           obj[obj_terakhir-1].point[1].x:=(((x2+25-x1) div 2)+x1);   obj[obj_terakhir-1].point[1].y:=y1-40;
           obj[obj_terakhir-1].point[2].x:=x2+25;                     obj[obj_terakhir-1].point[2].y:=y1;
           obj[obj_terakhir-1].point[3].x:=x2;                        obj[obj_terakhir-1].point[3].y:=y2;
           obj[obj_terakhir-1].point[4].x:=x1+25;                     obj[obj_terakhir-1].point[4].y:=y2;

           obj[obj_terakhir-1].jml_point:=4;
           obj[obj_terakhir-1].obj_type:='segilima';

           obj[obj_terakhir-1].color:=clWhite;
           obj[obj_terakhir-1].area.Create(x1,y1-40,x2+25,y2);
           obj[obj_terakhir-1].style:=line_style;
           obj[obj_terakhir-1].width_line:=TebalGaris.Value;
           obj[obj_terakhir-1].color_outline:=LineColor.ButtonColor;
           Tampil();
           obj_terpilih:=obj_terakhir-1;
      end;
      if btn_terpilih = 'segienam' then
      begin
         SetLength(obj[obj_terakhir-1].point,6);
         obj[obj_terakhir-1].point[0].x:=x1;                        obj[obj_terakhir-1].point[0].y:=y1;
         obj[obj_terakhir-1].point[1].x:=(((x2-x1) div 2)+x1);      obj[obj_terakhir-1].point[1].y:=y1-40;
         obj[obj_terakhir-1].point[2].x:=x2;                        obj[obj_terakhir-1].point[2].y:=y1;
         obj[obj_terakhir-1].point[3].x:=x2;                        obj[obj_terakhir-1].point[3].y:=y2;
         obj[obj_terakhir-1].point[4].x:=(((x2-x1) div 2)+x1);      obj[obj_terakhir-1].point[4].y:=y2+40;
         obj[obj_terakhir-1].point[5].x:=x1;                        obj[obj_terakhir-1].point[5].y:=y2;

         obj[obj_terakhir-1].jml_point:=5;
         obj[obj_terakhir-1].obj_type:='segienam';

         obj[obj_terakhir-1].color:=clWhite;
         obj[obj_terakhir-1].area.Create(x1,y1-40,x2,y2+40);
         obj[obj_terakhir-1].style:=line_style;
         obj[obj_terakhir-1].width_line:=TebalGaris.Value;
         obj[obj_terakhir-1].color_outline:=LineColor.ButtonColor;

         Tampil();
         obj_terpilih:=obj_terakhir-1;
      end;

    mousedown_on:= false;
end;

procedure TForm1.Label6Click(Sender: TObject);
begin

end;

procedure TForm1.LingkaranClick(Sender: TObject);
begin
  btn_terpilih:='lingkaran';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.PentagonClick(Sender: TObject);
begin
  btn_terpilih:='pentagon';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.PersegiClick(Sender: TObject);
begin
  btn_terpilih:='persegi';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.ResetChange(Sender: TObject);
begin
  SetLength(obj,0);
  Image1.Canvas.Pen.Style:=psSolid;
  Image1.Canvas.Pen.Color:=clBlack;
  Image1.Canvas.Pen.Width:=1;
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
  obj_terakhir:=0;
end;

procedure TForm1.SegiEnamClick(Sender: TObject);
begin
  btn_terpilih:='segienam';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.SegitigaClick(Sender: TObject);
begin
  btn_terpilih:='segitiga';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.SelectChange(Sender: TObject);
begin
  btn_terpilih:='select';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.SelectedObjClick(Sender: TObject);
begin

end;

procedure TForm1.spdEraserClick(Sender: TObject);
begin
  btn_terpilih:='eraser';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.spdLineClick(Sender: TObject);
begin
  btn_terpilih:='line';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.spdPencilClick(Sender: TObject);
begin
  btn_terpilih:='pencil';
  ActivedButton.Caption:=btn_terpilih;
end;

procedure TForm1.TipeGarisChange(Sender: TObject);
begin
  case TipeGaris.ItemIndex of
  0 : line_style:=psSolid;
  1 : line_style:=psDash;
  2 : line_style:=psDot;
  3 : line_style:=psDashDot;
  4 : line_style:=psDashDotDot;
  end;
end;

//Memperbesar
procedure TForm1.ZoomInClick(Sender: TObject);
begin
  //perulangan sampai banyaknya jumlah titik
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
    // Fix Point dipindah ke pusat, melakukan scalling, dan dikembalikan ke posisi asal dengan rumus scalling :
    // X' = Xf + (X-Xf).Sx
    // Y' = Yf + (Y-Yf).Sy
    obj[obj_terpilih].point[i].x:=round(obj[obj_terpilih].point[0].x+((obj[obj_terpilih].point[i].x - obj[obj_terpilih].point[0].x)*1.5));
    obj[obj_terpilih].point[i].y:=round(obj[obj_terpilih].point[0].y+((obj[obj_terpilih].point[i].y - obj[obj_terpilih].point[0].y)*1.5));

  end;
  Tampil();
end;

//Memperkecil
procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  for i:=0 to obj[obj_terpilih].jml_point do
  begin
  // Fix Point dipindah ke pusat, melakukan scalling, dan dikembalikan ke posisi asal dengan rumus scalling :
  // X' = Xf + (X-Xf).Sx
  // Y' = Yf + (Y-Yf).Sy
  obj[obj_terpilih].point[i].x:=round(obj[obj_terpilih].point[0].x+((obj[obj_terpilih].point[i].x - obj[obj_terpilih].point[0].x)*0.5));
  obj[obj_terpilih].point[i].y:=round(obj[obj_terpilih].point[0].y+((obj[obj_terpilih].point[i].y - obj[obj_terpilih].point[0].y)*0.5));
  end;
  Tampil();
end;

procedure TForm1.TitikTengah(x:integer);
begin
  //Pencarian titik tengah untuk rotasi, scalling
  a:=0;b:=0;
  //perulangan sampai jumlah titik pada objek
  for i:=0 to obj[x].jml_point do
  begin
    a := obj[x].point[i].x + a;
    b := obj[x].point[i].y + b;
  end;
  //hasil a dibagi dengan jumlah titik objek
  a := a div (obj[x].jml_point+1);
  b := b div (obj[x].jml_point+1);
end;

procedure TForm1.BoundaryFill(x, y, boundary, fill: Integer);
var
  current:Integer;
begin
  current:=Image1.Canvas.Pixels[x,y];
  //jika pixelnya tidak sama dengan line colour dan pixel tidak sama dengan fillcolour
  if((current<>boundary) and (current<>fill)) then
  begin
    //melakukan metode rekursif untuk pengisian area dengan menggunakan metode 4-connected dengan parameter posisi titik (x,y), warna isi dan warna batas
    Image1.Canvas.Pixels[x,y]:=fill;
    BoundaryFill(x+1,y,boundary,fill);
    BoundaryFill(x-1,y,boundary,fill);
    BoundaryFill(x,y+1,boundary,fill);
    BoundaryFill(x,y-1,boundary,fill);
  end;
end;

procedure TForm1.SelectObjek(x , y:integer);
var
  point:TPoint;
begin
  point.x:=x;
  point.y:=y;

  //Melakukan perulangan sampai objek terakhir yang tergambar di canvas
  for i:=0 to obj_terakhir-1 do
  begin
    //jika diklik
    if PtInRect(obj[i].area,point) = true then
    begin
      //objek i akan terpilih saat ini
      obj_terpilih:=i;
      SelectedObj.Caption:=IntToStr(obj_terpilih);
    end;
  end;
end;

procedure TForm1.Tampil();
begin
  //digunakan pada bidang gambar saat proses tampil
  Image1.Canvas.Pen.Style:=psSolid;
  Image1.Canvas.Pen.Color:=clBlack;
  Image1.Canvas.Pen.Width:=1;
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);

    //melakukan perulangan sampai banyaknya objek yang ada di canvas
    for i:= 0 to obj_terakhir-1 do
     begin

       //pemberian warna garis, tipe garis, dan tebal garis
       Image1.Canvas.Pen.Style:=obj[i].style;
       Image1.Canvas.Pen.Color:=obj[i].color_outline;
       Image1.Canvas.Pen.Width:=obj[i].width_line;

       //jika tipe objeknya lingkaran
       if obj[i].obj_type = 'lingkaran' then
       begin
          //menggambar lingkaran dengan fungsi ellipse
          Image1.Canvas.Ellipse(obj[i].point[0].x,obj[i].point[0].y,obj[i].point[1].x,obj[i].point[1].y);
       end

       else
       begin
          //menggambar dengan melakukan pergerakan dan memberi garis pada masing-masing titik
          Image1.Canvas.MoveTo(obj[i].point[obj[i].jml_point].x,obj[i].point[obj[i].jml_point].y);
          for j:= 0 to obj[i].jml_point do
          begin
               Image1.Canvas.LineTo(obj[i].point[j].x,obj[i].point[j].y);
          end;

       end;

       //jika nilai fill color tidak sama dengan putih maka
       if obj[i].color <> clWhite then
       begin
          //mencari titik tengah objek
          TitikTengah(i);
          //melakukan proses boundaryfill
          BoundaryFill(a,b,Image1.Canvas.Pen.Color,obj[obj_terpilih].color);
       end;

     end;
     Image1.Refresh;
end;

end.

