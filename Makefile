oscad = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
fn = 200

3d_formats = stl off amf 3mf csg png echo ast term nef3 nefdbg 
3d_formats = stl

logos = Logo LogoCircle LogoCircle-Inside
Logo = -D model=0 -D logo=-1
LogoCircle = -D model=0 -D logo=0
labels = Label LabelCircle LabelCircle-Inside LabelKey LabelKey-Inside LabelCar LabelCar-Inside LabelBag LabelBag-Inside
Label = -D model=1 -D label=-1
LabelCircle = -D model=1 -D label=0
LabelKey = -D model=1 -D label=1
LabelCar = -D model=1 -D label=2
LabelBag = -D model=1 -D label=3
Inside = -D engraving_depth=0.5 -D engraving_side=1
C = -D keyring_orientation=0
P = -D keyring_orientation=1

model_files = $(foreach orientation,C P,$(foreach logo,$(logos),$(foreach format,$(3d_formats),output/AirTag-KeyRing-$(orientation)-$(logo).$(format)))) \
              $(foreach orientation,C P,$(foreach label,$(labels),$(foreach format,$(3d_formats),output/AirTag-KeyRing-$(orientation)-$(label).$(format)))) \
              $(foreach logo,$(logos),$(foreach format,$(3d_formats),output/AirTag-Case-$(logo).$(format))) \
              $(foreach label,$(labels),$(foreach format,$(3d_formats),output/AirTag-Case-$(label).$(format)))

Closed = -D model=2
Open = -D model=3
ClosedSection = -D model=4
Default = -D projection=\"DEFAULT\"
Front = -D projection=\"FRONT\"
Back = -D projection=\"BACK\"
Top = -D projection=\"TOP\"
Bottom = -D projection=\"BOTTOM\"
Left = -D projection=\"LEFT\"
Right = -D projection=\"RIGHT\"

images_files = $(foreach orientation,C P,$(foreach model,Logo Label,$(foreach projection,Default Front Back Top Bottom Left Right,output/AirTag-$(orientation)-$(model)-$(projection).png))) \
               $(foreach orientation,C P,$(foreach model,Closed,$(foreach projection,Default Front Back Top Bottom Left Right,output/AirTag-$(orientation)-$(model)-$(projection).png))) \
               $(foreach orientation,C P,$(foreach model,Open,$(foreach projection,Default Front Back Left Right,output/AirTag-$(orientation)-$(model)-$(projection).png))) \
               $(foreach orientation,C P,$(foreach model,ClosedSection,$(foreach projection,Right,output/AirTag-$(orientation)-$(model)-$(projection).png))) \

all: $(model_files) $(images_files)

options=$(subst -, ,$(subst ., ,$*))

output/AirTag-KeyRing-%: AirTagKeyRing.scad Makefile | output
	$(oscad) -o $@ $< $($(word 1,$(options))) $($(word 2,$(options))) $($(word 3,$(options))) -D fn=$(fn)

output/AirTag-Case-%: AirTagKeyRing.scad Makefile | output
	$(oscad) -o $@ $< $($(word 1,$(options))) $($(word 2,$(options))) $($(word 3,$(options))) -D add_hole=0 -D fn=$(fn)

view = --view=axes,crosshairs,edges,scales,wireframe
view = 

output/AirTag-%.png: AirTagKeyRing.scad Makefile | output
	$(oscad) -o $@ $< --camera=0,10,0,0,0,0,200 --imgsize=2000,2000 --projection=o $(view) --colorscheme=Starnight $($(word 1,$(options))) $($(word 2,$(options))) $($(word 3,$(options))) -D fn=$(fn)

output:
	mkdir -p $@

clean:
	rm -f $(model_files) $(images_files)
